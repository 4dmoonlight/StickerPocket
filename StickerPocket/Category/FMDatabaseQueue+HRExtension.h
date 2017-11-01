//
//  FMDatabaseQueue+HRExtension.h
//  Sticker
//
//  Created by Rui Hou on 30/09/2017.
//  Copyright © 2017 Rui Hou. All rights reserved.
//

#import <FMDB/FMDB.h>
#import "HRStickerModel.h"
@interface FMDatabaseQueue (HRExtension)

+ (instancetype)shareInstense;
- (void)createStickerSql;
- (void)insertModel:(HRStickerModel *)model completion:(void(^)(BOOL isSuccess))completion;
- (void)selectAllModelWithCompletion:(void(^)(NSArray *data))completion;

@end
