//
//  SDImageCache+HRExtension.m
//  Sticker
//
//  Created by Rui Hou on 13/10/2017.
//  Copyright © 2017 Rui Hou. All rights reserved.
//

#import "SDImageCache+HRExtension.h"

@implementation SDImageCache (HRExtension)
+ (instancetype)shareGroupInstance {
    static SDImageCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[self class] hr_makeDiskCachePath:@"default"];
        cache = [[SDImageCache alloc] initWithNamespace:@"default" diskCacheDirectory:path];
    });
    return cache;
}

+ (nullable NSString *)hr_makeDiskCachePath:(nonnull NSString*)fullNamespace {
    //    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:GROUP_URL];
    NSString *paths = containerURL.path;
    
    return [paths stringByAppendingPathComponent:fullNamespace];
}

@end
