//
//  CWSEvaluationViewController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/5.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSEvaluationViewController.h"
#import "UIImageView+WebCache.h"
@interface CWSEvaluationViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    int _count;//图片张数
    NSMutableArray *imagViewArry;
    UIView *whiteView;
    NSMutableArray *firstStarArray;
    NSMutableArray *secondStarArray;
    NSMutableArray *thirdStarArray;
    NSInteger      firstStarSelectNumder;
    NSInteger      secondStarSelectNumder;
    NSInteger      thirdStarSelectNumder;
}

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitBtnTop;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *tenantPhoto;
- (IBAction)starButtonClick:(UIButton *)sender;


@end

@implementation CWSEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价晒单";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    imagViewArry = [[NSMutableArray alloc] init];
    firstStarArray = [[NSMutableArray alloc] init];
    secondStarArray = [[NSMutableArray alloc] init];;
    thirdStarArray = [[NSMutableArray alloc] init];
    _count = 0;
    firstStarSelectNumder = 0;
    secondStarSelectNumder = 0;
    thirdStarSelectNumder = 0;
    [self initalizeUserInterface];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    firstStarSelectNumder = 0;
    secondStarSelectNumder = 0;
    thirdStarSelectNumder = 0;
}


#pragma mark - 界面
- (void)initalizeUserInterface
{
    self.storeNameLabel.text = self.order.seller_name;
    self.serviceNameLabel.text = self.order.categoryName;
    self.ordeMoneyLabel.text = [NSString stringWithFormat:@"%@",self.order.price]; 
    NSString*url=[NSString stringWithFormat:@"%@%@",kBaseUrl ,self.order.tenantPhoto];
    NSURL*logoImgUrl=[NSURL URLWithString:url];
    [self.tenantPhoto setImageWithURL:logoImgUrl placeholderImage:[UIImage imageNamed:@"normal_car_brand"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
    
    self.textView.delegate = self;
    
    //添加晒单图片
    self.addPhotoButton = (UIButton *)[self.view viewWithTag:20];
    self.addPhotoButton.layer.borderWidth = 1.0;
    self.addPhotoButton.layer.borderColor = [UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1].CGColor;
    [self.addPhotoButton addTarget:self action:@selector(addPhotoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //发表评论
    self.addEvaluationButton = (UIButton *)[self.view viewWithTag:21];
    [self.addEvaluationButton addTarget:self action:@selector(addEvaluationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    float width = ([UIScreen mainScreen].bounds.size.width-20)/6;
    whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 440, [UIScreen mainScreen].bounds.size.width, width+20)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.alpha = 0;
    [self.contentView addSubview:whiteView];
    
    for (int i = 0; i<5; i++) {
        UIButton *firstButton = (UIButton *)[self.view viewWithTag:30+i];
        UIButton *secondButton = (UIButton *)[self.view viewWithTag:40+i];
        UIButton *threeButton = (UIButton *)[self.view viewWithTag:50+i];
        [firstStarArray addObject:firstButton];
        [secondStarArray addObject:secondButton];
        [thirdStarArray addObject:threeButton];
    }
}


#pragma mark - 添加晒单照片
- (void)addPhotoButtonPressed:(UIButton *)sender
{
    if (_count == 5) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多上传5张图片" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
    }
    else {
        UIActionSheet *sheet;
        //判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册 ",@"拍照", nil];
            [sheet setTintColor:KBlackMainColor];
        }else{
            sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", nil];
            
        }
        
        [sheet showInView:self.view];
    }
}

#pragma mark - 发表评论按钮
- (void)addEvaluationButtonPressed:(UIButton *)sender
{
    
    
    if (firstStarSelectNumder != 0 ) {
        
        NSNumber *selectNumber = [NSNumber numberWithInteger:firstStarSelectNumder];
        [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
        NSDictionary *dic = @{@"userId":KUserInfo.desc,@"token":KUserInfo.token,@"tenantId":self.order.seller_id,@"recordId":self.order.orderId,@"score":selectNumber};
        [HttpHelper insertTenantEvaluateDoRateWithUserDic:dic success:^(AFHTTPRequestOperation *operation,id object){
            NSDictionary *dataDic = (NSDictionary *)object;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([dataDic[@"code"] isEqualToString:SERVICE_SUCCESS]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadDataArray" object:nil];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"评论成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] ;
                [alert show];
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dataDic[@"desc"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] ;
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
        
        
    }
    else {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择服务评价星级" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] ;
        [alert show];
        
    }
}

#pragma -mark actionSheet
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSUInteger sourceType = 0;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                // 相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 1:
                // 相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
        }
        if (buttonIndex==0||buttonIndex==1) {
            // 跳转到相机或相册页面
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = sourceType;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }
    }
    else {
        NSLog(@"%zi",buttonIndex);
        if (buttonIndex == 0) {
            //相册
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            // 跳转到相机或相册页面
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = sourceType;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        } else {
            return;
        }
        
    }
    
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    // 保存图片至本地，方法见下文
    whiteView.alpha = 1;
    
    float width = ([UIScreen mainScreen].bounds.size.width-20)/6;
    
    UIImageView *productImage=[[UIImageView alloc]initWithFrame:CGRectMake(10+_count*width+12*_count, 10, width, width)];
    productImage.image=image;
    [whiteView addSubview:productImage];
    [imagViewArry addObject:productImage];
    if (_count == 0) {
        self.submitBtnTop.constant += (whiteView.H+20);
        self.contentViewHeight.constant += (whiteView.H+20);
    }
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(productImage.endX-15, productImage.Y-15, 30, 30);
    [deleteBtn setImage:[UIImage imageNamed:@"pingjia_shan"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.tag = 2000+_count;
    [whiteView addSubview:deleteBtn];
    
    _count++;
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

#pragma mark - deleteBtnPressed
- (void)deleteBtnPressed:(UIButton *)sender
{
    UIImageView *imageView = imagViewArry[sender.tag-2000];
    if (_count == 1) {
        [imageView removeFromSuperview];
        [imagViewArry removeObject:imagViewArry[0]];
        whiteView.alpha = 0;
        self.submitBtnTop.constant -= (whiteView.H+20);
        self.contentViewHeight.constant -= (whiteView.H+20);
    }
    if (_count == 2) {
        if (sender.tag -2000 == 0) {
            //删除第一张照片
            UIImageView *secondImageView = imagViewArry[1];//获得第二张照片
            imageView.image=secondImageView.image;
            [imagViewArry removeObject:imagViewArry[1]];
            [secondImageView removeFromSuperview];
        }
        if (sender.tag-2000==1) {
            //删除第二张照片
            UIImageView *secondImageView = imagViewArry[1];//获得第二张照片
            [imagViewArry removeObject:imagViewArry[1]];
            [secondImageView removeFromSuperview];
        }
    }
    if (_count == 3) {
        if (sender.tag -2000 == 0) {
            //删除第一张照片
            UIImageView *secondImageView = imagViewArry[1];//获得第二张照片
            UIImageView *threeImageView = imagViewArry[2];//获得第三张照片
            imageView.image=secondImageView.image;
            secondImageView.image=threeImageView.image;
            [threeImageView removeFromSuperview];
        }
        if (sender.tag-2000==1) {
            //删除第二张照片
            UIImageView *threeImageView = imagViewArry[2];//获得第三张照片
            imageView.image=threeImageView.image;
            [threeImageView removeFromSuperview];
        }
        if (sender.tag -2000 == 2) {
            //删除第三张照片
            [imageView removeFromSuperview];
        }
        [imagViewArry removeObject:imagViewArry[2]];
    }
    if (_count == 4) {
        if (sender.tag -2000 == 0) {
            //删除第一张照片
            UIImageView *secondImageView = imagViewArry[1];//获得第二张照片
            UIImageView *threeImageView = imagViewArry[2];//获得第三张照片
            UIImageView *fourImageView = imagViewArry[3];//获得第四张照片
            imageView.image=secondImageView.image;
            secondImageView.image=threeImageView.image;
            threeImageView.image = fourImageView.image;
            [fourImageView removeFromSuperview];
        }
        if (sender.tag-2000==1) {
            //删除第二张照片
            UIImageView *threeImageView = imagViewArry[2];//获得第三张照片
            UIImageView *fourImageView = imagViewArry[3];//获得第四张照片
            imageView.image=threeImageView.image;
            threeImageView.image = fourImageView.image;
            [fourImageView removeFromSuperview];
        }
        if (sender.tag -2000 == 2) {
            //删除第三张照片
            UIImageView *fourImageView = imagViewArry[3];//获得第四张照片
            imageView.image=fourImageView.image;
            [fourImageView removeFromSuperview];
        }
        if (sender.tag -2000 == 3) {
            //删除第四张照片
            
            [imageView removeFromSuperview];
        }
        
    }
    
    if (_count == 5) {
        if (sender.tag -2000 == 0) {
            //删除第一张照片
            UIImageView *secondImageView = imagViewArry[1];//获得第二张照片
            UIImageView *threeImageView = imagViewArry[2];//获得第三张照片
            UIImageView *fourImageView = imagViewArry[3];//获得第四张照片
            UIImageView *fiveImageView = imagViewArry[4];//获得第五张照片
            imageView.image=secondImageView.image;
            secondImageView.image=threeImageView.image;
            threeImageView.image = fourImageView.image;
            fourImageView.image = fiveImageView.image;
            [fiveImageView removeFromSuperview];
        }
        if (sender.tag-2000==1) {
            //删除第二张照片
            UIImageView *threeImageView = imagViewArry[2];//获得第三张照片
            UIImageView *fourImageView = imagViewArry[3];//获得第四张照片
            UIImageView *fiveImageView = imagViewArry[4];//获得第五张照片
            imageView.image=threeImageView.image;
            threeImageView.image = fourImageView.image;
            fourImageView.image = fiveImageView.image;
            [fiveImageView removeFromSuperview];
        }
        if (sender.tag -2000 == 2) {
            //删除第三张照片
            UIImageView *fourImageView = imagViewArry[3];//获得第四张照片
            UIImageView *fiveImageView = imagViewArry[4];//获得第五张照片
            imageView.image=fourImageView.image;
            fourImageView.image = fiveImageView.image;
            [fiveImageView removeFromSuperview];
        }
        if (sender.tag -2000 == 3) {
            //删除第四张照片
            UIImageView *fiveImageView = imagViewArry[4];//获得第五张照片
            imageView.image = fiveImageView.image;
            [fiveImageView removeFromSuperview];
        }
        if (sender.tag -2000 == 4) {
            
            //删除第五张照片
            [imageView removeFromSuperview];
            
        }
        [imagViewArry removeObject:imagViewArry[4]];
    }
    [(UIButton *)[self.view viewWithTag:2000+_count-1] removeFromSuperview];
    _count = _count-1;
    
    
}

#pragma mark - 保存图片至相册
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存照片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    NSLog(@"%@",msg);
}

#pragma mark - textview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.messageLabel.alpha = 0;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.textView.text.length != 0) {
        self.messageLabel.alpha = 0;
    }
    else {
        self.messageLabel.alpha = 1;
    }
    
}
#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%d",buttonIndex);
    if (buttonIndex==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 星级按钮
- (IBAction)starButtonClick:(UIButton *)sender {
    
    if (sender.tag>= 30 && sender.tag<= 34) {
        //全部按钮置于未选择状态
        for (UIButton *button in firstStarArray) {
            button.selected = NO;
        }
        //将比当前点击按钮下标小的按钮置于选择状态
        for (int i = 0; i<=sender.tag-30; i++) {
            UIButton *button = (UIButton *)firstStarArray[i];
            button.selected = YES;
            firstStarSelectNumder = sender.tag-30;
        }
    }
    else if (sender.tag>= 40 && sender.tag<= 44) {
        for (UIButton *button in secondStarArray) {
            button.selected = NO;
        }
        
        for (int i = 0; i<=sender.tag-40; i++) {
            UIButton *button = (UIButton *)secondStarArray[i];
            button.selected = YES;
            secondStarSelectNumder = sender.tag-40;
        }
    }
    else if (sender.tag>= 50 && sender.tag<= 54) {
        for (UIButton *button in thirdStarArray) {
            button.selected = NO;
        }
        
        for (int i = 0; i<=sender.tag-50; i++) {
            UIButton *button = (UIButton *)thirdStarArray[i];
            button.selected = YES;
            thirdStarSelectNumder = sender.tag-50;
        }
    }

}
@end
