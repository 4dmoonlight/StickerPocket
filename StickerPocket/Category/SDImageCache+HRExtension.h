//
//  SDImageCache+HRExtension.h
//  Sticker
//
//  Created by Rui Hou on 13/10/2017.
//  Copyright © 2017 Rui Hou. All rights reserved.
//

//#import <SDWebImage/SDImageCache.h>
#import "SDImageCache.h"
#import "HRStickerModel.h"
@interface SDImageCache (HRExtension)
+ (instancetype)shareGroupInstance;
- (void)saveImageWithInfo:(NSDictionary *)info completion:(void(^)(BOOL isSuccess,UIImage *image,HRStickerModel *model,NSError *error))completion;
@end
