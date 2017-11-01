//
//  ViewController.m
//  StickerPocket
//
//  Created by Rui Hou on 31/10/2017.
//  Copyright © 2017 Rui Hou. All rights reserved.
//

#import "ViewController.h"
#import "SDImageCache+HRExtension.h"
@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    HRWeakSelf;
    [[SDImageCache shareGroupInstance] saveImageWithInfo:info completion:^(BOOL isSuccess, UIImage *image, HRStickerModel *model) {
        HRStrongSelf;
        if (isSuccess) {
            [strongSelf.dataArray addObject:model];
            
        }
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
@end
