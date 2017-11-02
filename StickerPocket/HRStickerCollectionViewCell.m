//
//  HRStickerCollectionViewCell.m
//  StickerPocket
//
//  Created by Rui Hou on 01/11/2017.
//  Copyright © 2017 Rui Hou. All rights reserved.
//

#import "HRStickerCollectionViewCell.h"

@implementation HRStickerCollectionViewCell
- (void)prepareForReuse {
    [super prepareForReuse];
    _imageView.hidden = NO;
}
@end
