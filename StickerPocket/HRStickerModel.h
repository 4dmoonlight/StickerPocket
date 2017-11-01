//
//  HRStickerModel.h
//  Sticker
//
//  Created by Rui Hou on 15/09/2017.
//  Copyright © 2017 Rui Hou. All rights reserved.
//

#import <Mantle/Mantle.h>
@interface HRStickerModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, strong) NSNumber *date;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, strong) NSNumber *isFav;

@property (nonatomic, strong) NSNumber *imgId;

@end
