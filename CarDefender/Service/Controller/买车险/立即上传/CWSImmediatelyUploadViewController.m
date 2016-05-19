//
//  CWSImmediatelyUploadViewController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/7.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSImmediatelyUploadViewController.h"


@interface CWSImmediatelyUploadViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray *_headImageViewArray;
    NSMutableArray *_footImageViewArray;
    NSInteger      _tag;//判断点击的是上面添加图片还是下面
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headPhotoCustomTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footPhotoCustomTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeight;


@end

@implementation CWSImmediatelyUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传资料信息";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    [self initDataSource];
    [self initalizeUserInterface];
}

#pragma mark - 数据
- (void)initDataSource
{
    _headImageViewArray = [NSMutableArray array];
    _footImageViewArray = [NSMutableArray array];
}


#pragma mark - 界面
- (void)initalizeUserInterface
{
    self.headTakePhotoBtn = (UIButton *)[self.view viewWithTag:1];
    self.headTakePhotoBtn.layer.borderWidth = 1.0;
    self.headTakePhotoBtn.layer.borderColor = [UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1].CGColor;
    [self.headTakePhotoBtn addTarget:self action:@selector(photoBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.headChooseBtn = (UIButton *)[self.view viewWithTag:2];
    self.headChooseBtn.layer.borderWidth = 1.0;
    self.headChooseBtn.layer.borderColor = [UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1].CGColor;
    [self.headChooseBtn addTarget:self action:@selector(photoBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.footTakePhotoBtn = (UIButton *)[self.view viewWithTag:3];
    self.footTakePhotoBtn.layer.borderWidth = 1.0;
    self.footTakePhotoBtn.layer.borderColor = [UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1].CGColor;
    [self.footTakePhotoBtn addTarget:self action:@selector(photoBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.footChooseBtn = (UIButton *)[self.view viewWithTag:4];
    self.footChooseBtn.layer.borderWidth = 1.0;
    self.footChooseBtn.layer.borderColor = [UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1].CGColor;
    [self.footChooseBtn addTarget:self action:@selector(photoBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.immediatelySubmitBtn = (UIButton *)[self.view viewWithTag:5];
    [self.immediatelySubmitBtn addTarget:self action:@selector(immediatelySubmitBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.headPhotoCustomView = (UIView *)[self.view viewWithTag:10];
    self.footPhotoCusstomView = (UIView *)[self.view viewWithTag:12];
    
    self.mainView = (UIView *)[self.view viewWithTag:20];
    
    self.headImageView = (UIImageView *)[self.view viewWithTag:30];
    self.footImageView = (UIImageView *)[self.view viewWithTag:31];
}

#pragma mark - 相机
- (void)photoBtnPressed:(UIButton *)sender
{

    switch (sender.tag) {
        //上面拍照
        case 1:{
            _tag = 10;
            [self showCamera];
        }
            break;
        //上面选取
        case 2:{
            _tag = 10;
            [self showImage];
        }
            break;
        //下面拍照
        case 3:{
            _tag = 11;
            [self showCamera];
        }
            break;
        //下面选取
        case 4:{
            _tag = 11;
            [self showImage];
        }
            break;
        default:
            break;
    }
        
}

- (void)showImage
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [imagePickerController shouldAutorotate];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

- (void)showCamera
{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;  //是否可编辑
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
        
    }
}

#pragma mark - 立即提交
- (void)immediatelySubmitBtnPressed:(UIButton *)sender
{
    if (_headImageViewArray.count != 0 && _footImageViewArray.count != 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - <UIImagePickerControllerDelegate>


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [self addPhoto:info];//添加图片
        
    }
    else {
        [self addPhoto:info];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)addPhoto:(NSDictionary *)info
{
    //添加相册中图片，放到相应位置并加入图片数组

    //上面
    if (_tag == 10) {

        self.headImageView.alpha = 1;
        self.headImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (_headImageViewArray.count == 0) {
            self.headPhotoCustomTop.constant += 174;
            [_headImageViewArray addObject:self.headImageView];
        }
        [self.view layoutIfNeeded];
        
    }
    //下面
    else {
        
        self.footImageView.alpha = 1;
        self.footImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.view layoutIfNeeded];
        if (_footImageViewArray.count == 0) {
            self.footPhotoCustomTop.constant += 174;
            [_footImageViewArray addObject:self.footImageView];
            if (_headImageViewArray.count != 0) {
                self.mainViewHeight.constant += 50;
            }
        }
        [self.view layoutIfNeeded];
    }
    
}

#pragma mark-压缩图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


@end
