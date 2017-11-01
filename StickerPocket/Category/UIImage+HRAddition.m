//
//  UIImage+HRAddition.m
//  Sticker
//
//  Created by Rui Hou on 15/09/2017.
//  Copyright © 2017 Rui Hou. All rights reserved.
//

#import "UIImage+HRAddition.h"
#define kGetMostColorSize 40

@implementation UIImage (HRAddition)
- (UIColor *)getMostAreaColor {
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    CGSize thumbSize=CGSizeMake(kGetMostColorSize, kGetMostColorSize);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, self.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    unsigned char* data = CGBitmapContextGetData (context);
    
    if (data == NULL) return nil;
    
    NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    
    for (int x=0; x<thumbSize.width; x++) {
        for (int y=0; y<thumbSize.height; y++) {
            
            int offset = 4*(x*y);
            
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            
            NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
            [cls addObject:clr];
        }
    }
    CGContextRelease(context);
    
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    
    NSArray *MaxColor=nil;
    NSUInteger MaxCount=0;
    
    while ( (curColor = [enumerator nextObject]) != nil )
    {
        NSUInteger tmpCount = [cls countForObject:curColor];
        if ( tmpCount < MaxCount ) continue;
        MaxCount=tmpCount;
        MaxColor=curColor;
    }
    
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];

}

- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.6);
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    NSData *imageData = [self imageWithImage:image scaledToSize:size];
    NSLog(@"result image length %lu",(long)imageData.length/1000);
    image = [UIImage imageWithData:imageData];
    return image;
}

- (UIImage *)reSizeImage
{
    // 缩放处理
    CGFloat height = self.size.height;
    if (self.size.width > self.size.height) {
        height = self.size.width;
    }
    
    UIImage *reSizeImage = self;
    //    if (height > 618) {
    //        CGFloat scaleSize = 618/height;
    //        UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scaleSize, self.size.height * scaleSize));
    //        [self drawInRect:CGRectMake(0, 0, self.size.width * scaleSize, self.size.height * scaleSize)];
    //        reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    //        UIGraphicsEndImageContext();
    //    }
    UIImage *resultImage;
    if (reSizeImage.size.height < reSizeImage.size.width) {
        resultImage = [self resizeImage:reSizeImage withSize:CGSizeMake(618, 618*reSizeImage.size.height/reSizeImage.size.width)];
    } else {
        resultImage = [self resizeImage:reSizeImage withSize:CGSizeMake(618 * reSizeImage.size.width/reSizeImage.size.height, 618)];
    }
    DebugLog(@"%f,%f",resultImage.size.width,resultImage.size.height);
    return resultImage;
}

@end
