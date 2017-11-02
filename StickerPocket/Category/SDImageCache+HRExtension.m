//
//  SDImageCache+HRExtension.m
//  Sticker
//
//  Created by Rui Hou on 13/10/2017.
//  Copyright © 2017 Rui Hou. All rights reserved.
//

#import "SDImageCache+HRExtension.h"
#import <Colours/Colours.h>
#import "UIImage+HRAddition.h"
#import "NSData+HRAddition.h"
#import "FMDatabaseQueue+HRExtension.h"
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

- (void)saveImageWithInfo:(NSDictionary *)info completion:(void (^)(BOOL, UIImage *, HRStickerModel *))completion {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIColor *color = [image getMostAreaColor];
    NSString *hexStr = color.hexString;
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    NSString *url = imageData.getUniqueKey;
    
    __block BOOL insertSeccess = NO;
    dispatch_group_t serviceGroup = dispatch_group_create();
    dispatch_group_enter(serviceGroup);
    [[SDImageCache shareGroupInstance] storeImage:image forKey:url completion:^{
        DebugLog(@"sdimage store success");
        dispatch_group_leave(serviceGroup);
    }];

    dispatch_group_enter(serviceGroup);
    HRStickerModel *model = [HRStickerModel new];
    model.color = hexStr;
    model.url = url;
    [[FMDatabaseQueue shareInstense] insertModel:model completion:^(BOOL isSuccess) {
        insertSeccess = isSuccess;
        DebugLog(@"fmdatabase store success");
        dispatch_group_leave(serviceGroup);
    }];
    
    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        if (completion) {
            DebugLog(@"group notify");
            completion(insertSeccess,image,model);
        }
    });
}
@end
