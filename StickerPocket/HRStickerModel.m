//
//  HRStickerModel.m
//  Sticker
//
//  Created by Rui Hou on 15/09/2017.
//  Copyright © 2017 Rui Hou. All rights reserved.
//

#import "HRStickerModel.h"
@interface HRStickerModel ()

@end

@implementation HRStickerModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"url" : @"img_url",
        @"tag" : @"tag",
        @"date" : @"add_date",
        @"color" : @"color",
        @"isFav" : @"fav",
        @"imgId" : @"img_id"
    };
}


@end
