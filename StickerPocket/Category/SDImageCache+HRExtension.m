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
        cache.config.shouldDisableiCloud = NO;
    });
    return cache;
}

+ (nullable NSString *)hr_makeDiskCachePath:(nonnull NSString*)fullNamespace {
    //    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:GROUP_URL];
    NSString *paths = containerURL.path;
    
    return [paths stringByAppendingPathComponent:fullNamespace];
}

- (void)saveImageWithInfo:(NSDictionary *)info completion:(void (^)(BOOL, UIImage *, HRStickerModel *, NSError *))completion {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (!image) {
        if (completion) {
            NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:@{
                                                                            NSLocalizedFailureReasonErrorKey:NSLocalizedString(@"Image not exist", nil)
                                                                            }];
            completion(NO,image,nil,error);
        }
        return;
    }
    if (image.size.width > 1000||image.size.height > 1000) {
        DebugLog(@"image size:%f,%f",image.size.width,image.size.height);
        if (completion) {
            NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:@{
                                                                            NSLocalizedFailureReasonErrorKey:NSLocalizedString(@"Image is too large", nil)
                                                                            }];
            completion(NO,image,nil,error);
        }
        return;
    }
    UIColor *color = [image getMostAreaColor];
    NSString *hexStr = color.hexString;
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    NSString *url = imageData.getUniqueKey;
    NSLog(@"%@",url);
    dispatch_group_t checkGroup = dispatch_group_create();
    dispatch_group_enter(checkGroup);
    __block BOOL urlExist = NO;
    [FMDatabaseQueue checkModelExist:url completion:^(BOOL isExist) {
        urlExist = isExist;
        dispatch_group_leave(checkGroup);
    }];
    dispatch_group_notify(checkGroup, dispatch_get_main_queue(), ^{
        if (urlExist) {
            if (completion) {
                NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:@{
                                                                                NSLocalizedFailureReasonErrorKey:NSLocalizedString(@"Stickers already added", nil)
                                                                                }];
                completion(NO,image,nil,error);
            }
        } else {
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
            NSTimeInterval addDate = [[NSDate date] timeIntervalSince1970];
            model.date = @(addDate);
            [FMDatabaseQueue insertModel:model completion:^(BOOL isSuccess) {
                insertSeccess = isSuccess;
                DebugLog(@"fmdatabase store success");
                dispatch_group_leave(serviceGroup);
            }];
            
            dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
                if (completion) {
                    DebugLog(@"group notify");
                    if(insertSeccess) {
                        completion(insertSeccess,image,model,nil);
                    } else {
                        NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:@{
                                                                                        NSLocalizedFailureReasonErrorKey:NSLocalizedString(@"Insert image fail", nil)
                                                                                        }];
                        completion(insertSeccess,image,model,error);
                    }
                }
            });
        }
    });
    

}
@end
