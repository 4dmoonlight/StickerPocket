//
//  FMDatabaseQueue+HRExtension.m
//  Sticker
//
//  Created by Rui Hou on 30/09/2017.
//  Copyright © 2017 Rui Hou. All rights reserved.
//

#import "FMDatabaseQueue+HRExtension.h"
#import <objc/runtime.h>
#define DB_PATH [GROUP_DIRECTORY stringByAppendingPathComponent:STICKER_TABLE_NAME]
static NSString * const createStickerSQL = @"CREATE TABLE if not exists 'Sticker' ('img_id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,'img_url' VARCHAR(500), 'color' VARCHAR(50), 'add_date' DOUBLE, 'tag' VARCHAR(500), 'fav' INTEGER, 'count' INTEGER,'license' VARCHAR(500),'from' VARCHAR(500))";

@implementation FMDatabaseQueue (HRExtension)
+ (instancetype)shareInstense {
    static FMDatabaseQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [FMDatabaseQueue databaseQueueWithPath:DB_PATH];
    });
    return queue;
}

+ (void)createStickerSql {
    [[FMDatabaseQueue shareInstense] inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:createStickerSQL];
    }];
}

+ (void)insertModel:(HRStickerModel *)model completion:(void (^)(BOOL))completion {
    [[FMDatabaseQueue shareInstense] inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        NSString * sql = @"insert into Sticker (img_url, color, add_date) values(?, ?, ?) ";
        BOOL res = [db executeUpdate:sql, model.url, model.color,model.date];
        if (completion) {
            completion(res);
        }
    }];
}

+ (void)deleteModel:(HRStickerModel *)model completion:(void (^)(BOOL))completion {
    [[FMDatabaseQueue shareInstense] inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        DebugLog(@"%@",[NSThread currentThread]);
        NSString *sql = [NSString stringWithFormat:@"delete from Sticker where img_id = %li",model.imgId.longValue];
        BOOL res = [db executeUpdate:sql];
        if (completion) {
            completion(res);
        }
        
    }];
}

+ (void)selectAllModelWithCompletion:(void (^)(NSArray *))completion {
    [[FMDatabaseQueue shareInstense] inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        NSMutableArray *array = [NSMutableArray new];
        NSString * sql = @"select * from Sticker";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *dic = [rs resultDictionary];
            NSError *error = nil;
            HRStickerModel *model = [MTLJSONAdapter modelOfClass:[HRStickerModel class] fromJSONDictionary:dic error:&error];
            if (!error) {
                DebugLog(@"%@",dic);
                [array addObject:model];
            } else {
                DebugLog(@"%@",error.localizedDescription);
                //delete data
            }
            if (completion) {
                completion(array);
            }
        }
    }];
}

+ (void)checkModelExist:(NSString *)imgUrl completion:(void (^)(BOOL))completion {
    [[FMDatabaseQueue shareInstense] inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL flag = NO;
        NSString *statement = [NSString stringWithFormat:@"SELECT * FROM Sticker WHERE img_url = '%@'",imgUrl];
        FMResultSet *resultSet = [db executeQuery:statement];
        if ([resultSet next]) {
            flag = YES;
        }
        if (completion) {
            completion(flag);
        }
    }];
}
@end
