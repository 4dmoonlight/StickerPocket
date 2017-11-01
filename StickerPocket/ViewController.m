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
@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self fetchData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchData {
    HRWeakSelf;
    [[FMDatabaseQueue shareInstense] selectAllModelWithCompletion:^(NSArray *data) {
        HRStrongSelf;
        strongSelf.dataArray = [data mutableCopy];
        [strongSelf.collectionView reloadData];
    }];
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
            [strongSelf.collectionView performBatchUpdates:^{
                [strongSelf.dataArray addObject:model];
                [strongSelf.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.dataArray.count-1 inSection:0]]];
            } completion:^(BOOL finished) {
                
            }];
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
    cell.imageView.image = [[SDImageCache shareGroupInstance] imageFromCacheForKey:model.url];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH/3);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HRStickerModel *model = self.dataArray[indexPath.item];
    IDMPhoto *photo = [IDMPhoto photoWithCacheKey:model.url];
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:@[photo] animatedFromView:[collectionView cellForItemAtIndexPath:indexPath]];
    [self presentViewController:browser animated:YES completion:^{
        
    }];
}
@end
