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

- (void)createStickerSql {
    [[FMDatabaseQueue shareInstense] inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:createStickerSQL];
    }];
}

- (void)insertModel:(HRStickerModel *)model completion:(void (^)(BOOL))completion {
    [[FMDatabaseQueue shareInstense] inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        NSString * sql = @"insert into Sticker (img_url, color, add_date) values(?, ?, ?) ";
        NSTimeInterval addDate = [[NSDate date] timeIntervalSince1970];
        NSString *color = model.color;
        BOOL res = [db executeUpdate:sql, model.url, color,@(addDate)];
        if (completion) {
            completion(res);
        }
    }];
}
@end
