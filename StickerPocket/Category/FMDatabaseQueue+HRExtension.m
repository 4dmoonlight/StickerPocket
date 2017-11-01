//
//  FMDatabaseQueue+HRExtension.m
//  Sticker
//
//  Created by Rui Hou on 30/09/2017.
//  Copyright © 2017 Rui Hou. All rights reserved.
//

#import "FMDatabaseQueue+HRExtension.h"
#define DB_PATH [GROUP_DIRECTORY stringByAppendingPathComponent:STICKER_TABLE_NAME]
@implementation FMDatabaseQueue (HRExtension)
+ (instancetype)shareInstense {
    static FMDatabaseQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [FMDatabaseQueue databaseQueueWithPath:DB_PATH];
    });
    return queue;
}
@end
