//
//  NSData+HRAddition.m
//  Sticker
//
//  Created by Rui Hou on 12/10/2017.
//  Copyright © 2017 Rui Hou. All rights reserved.
//

#import "NSData+HRAddition.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (HRAddition)
- (NSString *)getUniqueKey {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([self bytes], (CC_LONG)[self length], result);
    NSString *imageHash = [NSString stringWithFormat:
                           @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return imageHash;
}

@end
