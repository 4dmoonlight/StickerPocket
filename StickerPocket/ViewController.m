//
//  ViewController.m
//  StickerPocket
//
//  Created by Rui Hou on 31/10/2017.
//  Copyright © 2017 Rui Hou. All rights reserved.
//

#import "ViewController.h"
#import <Colours/Colours.h>
#import "UIImage+HRAddition.h"
#import "NSData+HRAddition.h"
@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addItemAction:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypePhotoLibrary)]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        //        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
}

- (IBAction)editItemAction:(id)sender {
    NSLog(@"edit");
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];

    UIColor *color = [image getMostAreaColor];
    NSString *hexStr = color.hexString;
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    NSString *url = imageData.getUniqueKey;

    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
