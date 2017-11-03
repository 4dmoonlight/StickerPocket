//
//  ViewController.m
//  StickerPocket
//
//  Created by Rui Hou on 31/10/2017.
//  Copyright © 2017 Rui Hou. All rights reserved.
//

#import "ViewController.h"
#import "SDImageCache+HRExtension.h"
#import "FMDatabaseQueue+HRExtension.h"
#import "HRStickerCollectionViewCell.h"
#import "IDMPhotoBrowser.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,IDMPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipLabelDidTap:)];
    [_tipLabel addGestureRecognizer:tapGes];
    _tipLabel.userInteractionEnabled = YES;
    [self fetchData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tipLabelDidTap:(id)sender {
    [self addItemAction:nil];
}

- (void)fetchData {
    HRWeakSelf;
    [FMDatabaseQueue selectAllModelWithCompletion:^(NSArray *data) {
        HRStrongSelf;
        strongSelf.dataArray = [data mutableCopy];
        [strongSelf.collectionView reloadData];
    }];
}

- (IBAction)addItemAction:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypePhotoLibrary)]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        //        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    HRWeakSelf;
    [[SDImageCache shareGroupInstance] saveImageWithInfo:info completion:^(BOOL isSuccess, UIImage *image, HRStickerModel *model, NSError *error) {
        HRStrongSelf;
        if (isSuccess) {
            [strongSelf.collectionView performBatchUpdates:^{
                [strongSelf.dataArray addObject:model];
                [strongSelf.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.dataArray.count-1 inSection:0]]];
            } completion:^(BOOL finished) {
                
            }];
        } else {
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = error.localizedFailureReason;
            [self.view addSubview:hud];
            [hud showAnimated:YES];
            [hud hideAnimated:YES afterDelay:1.5];
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
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HRStickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StickerCell" forIndexPath:indexPath];
    HRStickerModel *model = self.dataArray[indexPath.item];
//    cell.imageView.image = [[SDImageCache shareGroupInstance] imageFromCacheForKey:model.url];
    [[SDImageCache shareGroupInstance] queryCacheOperationForKey:model.url done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
        cell.imageView.image = image;
    }];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.dataArray.count;
    if (count>0) {
        _tipLabel.hidden = YES;
    } else {
        _tipLabel.hidden = NO;
    }
    return count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH/3);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HRStickerModel *model = self.dataArray[indexPath.item];
    IDMPhoto *photo = [IDMPhoto photoWithCacheKey:model.url];
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:@[photo] animatedFromView:[(HRStickerCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath] imageView]];
    browser.delegate = self;
    browser.useWhiteBackgroundColor = YES;
    browser.dismissOnTouch = YES;
    browser.displayDoneButton = NO;
    browser.actionButtonTitles = @[NSLocalizedString(@"Delete", nil),NSLocalizedString(@"Save to album", nil)];
    [self presentViewController:browser animated:YES completion:^{
        
    }];
}

- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissActionSheetWithButtonIndex:(NSUInteger)buttonIndex photoIndex:(NSUInteger)photoIndex {
    switch (buttonIndex) {
        case 0:
        {
            UIAlertController *alertController;
            if (CURRENT_DEVICE_IS_IPAD) {
                alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
            } else {
                alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            }
            HRWeakSelf;
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                HRStrongSelf;
                NSInteger index = [strongSelf.collectionView indexPathsForSelectedItems].firstObject.item;
                [strongSelf deletePhotoAtIndex:index];
                [photoBrowser animateDismissWithCompletion:nil];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:deleteAction];
            [alertController addAction:cancelAction];
            [photoBrowser presentViewController:alertController animated:YES completion:nil];
        }
            break;
        case 1:
        {
            NSInteger index = [self.collectionView indexPathsForSelectedItems].firstObject.item;
            HRStickerModel *model = self.dataArray[index];
            [[SDImageCache shareGroupInstance] queryCacheOperationForKey:model.url done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
                void* contextInfo = NULL;
                UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:),contextInfo);
            }];
        }
            break;
        default:
            break;
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.label.text = NSLocalizedString(@"Save success", nil);
    hud.mode = MBProgressHUDModeText;
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:2];
}

- (void)deletePhotoAtIndex:(NSInteger)photoIndex {
    HRStickerModel *model = self.dataArray[photoIndex];
    HRWeakSelf;
    [FMDatabaseQueue deleteModel:model completion:^(BOOL isSuccess) {
        HRStrongSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isSuccess) {
                [strongSelf.collectionView performBatchUpdates:^{
                    [strongSelf.dataArray removeObject:model];
                    //                [strongSelf.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:photoIndex inSection:0]]];
                    [strongSelf.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:photoIndex inSection:0]]];
                } completion:^(BOOL finished) {
                    
                }];
            }
        });

    }];
}
@end
