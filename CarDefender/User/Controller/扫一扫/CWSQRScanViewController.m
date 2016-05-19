//
//  CWSQRScanViewController.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/16.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSQRScanViewController.h"

#import <AVFoundation/AVFoundation.h>

static const CGFloat KBorderWidth = 100;
static const CGFloat KMargin = 30;
@interface CWSQRScanViewController ()<UIAlertViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{


}
@property (nonatomic,strong) AVCaptureSession* captureSession;  //会话
@property (nonatomic,weak)   UIView* maskView;     //遮罩
@property (nonatomic,strong) UIView* scanWindow;    //扫描窗口视图
@property (nonatomic,strong) UIImageView* scanNetImageView;   //扫描窗口的网状视图

@end

@implementation CWSQRScanViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
  //  self.navigationController.navigationBarHidden = YES;
    [self resumeAnimation];
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.view.clipsToBounds = YES;
    self.title = @"扫一扫";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    
    [self createMaskView];
    [self createBottomBar];
    [self createTitleView];
    //[self createNavigation];
    [self createScanWindowView];
    [self beginScanning];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resumeAnimation) name:@"EnterForeground" object:nil];
}


#pragma mark -=============================CreateUI


/**设置遮罩*/
-(void)createMaskView{
    
    UIView* mask = [UIView new];
    _maskView = mask;
    
    mask.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6].CGColor;
    mask.layer.borderWidth = KBorderWidth;
    mask.frame = CGRectMake(0, 0, self.view.W + KBorderWidth + KMargin, self.view.w + KBorderWidth + KMargin); //用边框来实现遮罩?
    mask.center = CGPointMake(self.view.w * 0.5, self.view.h * 0.5);
    mask.y = 0;
    
    [self.view addSubview:mask];
}

/**设置下边栏*/
-(void)createBottomBar{

    UIView* bottomBar = [[UIView alloc]initWithFrame:CGRectMake(0, kSizeOfScreen.height-kDockHeight-self.view.h*0.1, self.view.w, self.view.h * 0.1)];
    bottomBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:bottomBar];
    
    UIButton* myQRCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myQRCodeButton.frame = CGRectMake(0, 0, self.view.h * 0.1*35/49, self.view.h*0.1);
    myQRCodeButton.center = CGPointMake(self.view.w/2, self.view.h*0.1/2);
    [myQRCodeButton setImage:[UIImage imageNamed:@"qrcode_scan_btn_photo_down"] forState:UIControlStateNormal];
    myQRCodeButton.contentMode = UIViewContentModeScaleAspectFit;
    [myQRCodeButton addTarget:self action:@selector(myQRCodeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:myQRCodeButton];
    
    UIView* mask = [[UIView alloc]initWithFrame:CGRectMake(0, _maskView.Y+_maskView.H, self.view.W, KBorderWidth)];
    mask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    mask.userInteractionEnabled = YES;
    [bottomBar addSubview:mask];

}

/**提示文本*/
-(void)createTitleView{
    
//    //bottomBar遮罩View
//    UIView* mask = [[UIView alloc]initWithFrame:CGRectMake(0, _maskView.Y+_maskView.H, self.view.W, KBorderWidth)];
//    mask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
//    mask.userInteractionEnabled = YES;
//    [self.view addSubview:mask];
    
    
    UILabel* tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.H * 0.9 - KBorderWidth*2, kSizeOfScreen.width, KBorderWidth)];
    tipLabel.text = @"将取景框对准二维码，即可自动扫描";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipLabel.numberOfLines = 2;
    tipLabel.font=[UIFont systemFontOfSize:12];
    tipLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipLabel];

}

/**创建顶部导航*/
-(void)createNavigation{
    
    //1.返回
    
    UIButton* backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 30, 25, 25);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_nor"] forState:UIControlStateNormal];
    backBtn.contentMode=UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

    //2.相册
    UIButton* albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    albumButton.frame = CGRectMake(0, 0, 35, 49);
    albumButton.center = CGPointMake(self.view.w/2, 20+49/0.2);
    [albumButton setImage:[UIImage imageNamed:@"qrcode_scan_btn_photo_down"] forState:UIControlStateNormal];
    albumButton.contentMode = UIViewContentModeScaleAspectFit;
    [albumButton addTarget:self action:@selector(albumButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:albumButton];
    
    //3.
    UIButton* flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    flashButton.frame = CGRectMake(self.view.w-55, 20, 35, 49);
    [flashButton setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    flashButton.contentMode = UIViewContentModeScaleAspectFit;
    [flashButton addTarget:self action:@selector(flashButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:flashButton];
}


-(void)createScanWindowView{
    
    CGFloat scanWindowHeight = kSizeOfScreen.width - KMargin * 2;
    CGFloat scanWindowWidth = kSizeOfScreen.width - KMargin * 2;
    _scanWindow = [[UIView alloc]initWithFrame:CGRectMake(KMargin, KBorderWidth-3, scanWindowWidth, scanWindowHeight)];
    _scanWindow.clipsToBounds = YES;
    [self.view addSubview:_scanWindow];
    
    _scanNetImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scan_net"]];
    CGFloat buttonWH = 18;
    
    UIButton* topLeft = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, buttonWH, buttonWH)];
    [topLeft setImage:[UIImage imageNamed:@"scan_1"] forState:UIControlStateNormal];
    [_scanWindow addSubview:topLeft];
    
    UIButton* topRight = [[UIButton alloc]initWithFrame:CGRectMake(scanWindowWidth-buttonWH, 0, buttonWH, buttonWH)];
    [topRight setImage:[UIImage imageNamed:@"scan_2"] forState:UIControlStateNormal];
    [_scanWindow addSubview:topRight];
    
    UIButton* bottomLeft = [[UIButton alloc]initWithFrame:CGRectMake(0, scanWindowHeight-buttonWH, buttonWH, buttonWH)];
    [bottomLeft setImage:[UIImage imageNamed:@"scan_3"] forState:UIControlStateNormal];
    [_scanWindow addSubview:bottomLeft];
    
    UIButton* bottomRight = [[UIButton alloc]initWithFrame:CGRectMake(topRight.x, bottomLeft.y, buttonWH, buttonWH)];
    [bottomRight setImage:[UIImage imageNamed:@"scan_4"] forState:UIControlStateNormal];
    [_scanWindow addSubview:bottomRight];
}

-(void)beginScanning{
    
    //获取摄像设备
    AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput* deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if(!deviceInput) return;

    //创建输出流
    AVCaptureMetadataOutput* dataOutput = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [dataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置有效扫描区域
    CGRect scanCrop = [self getScanCrop:_scanWindow.bounds andReaderViewBounds:self.view.frame];
    dataOutput.rectOfInterest = scanCrop;
    
    //初始化链接对象
    _captureSession = [[AVCaptureSession alloc]init];
    //高质量采样
    [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_captureSession addInput:deviceInput];
    [_captureSession addOutput:dataOutput];
    
    //设置扫码支持的编码格式(条形码和二维码)
    dataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer* layer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    //开始捕获
    [_captureSession startRunning];
}


#pragma mark -=============================OtherCallBack


/**恢复动画*/
-(void)resumeAnimation{
    
    CAAnimation* animation = [_scanNetImageView.layer animationForKey:@"translationAnimation"];
    if(animation){
    
        //1.将动画的时间偏移量作为暂停时的时间点
        CFTimeInterval pauseTime = _scanNetImageView.layer.timeOffset;
        //2.根据媒体时间计算出准确的启动动画的时间，对之前动画进行修正
        CFTimeInterval beginTime = CACurrentMediaTime() - pauseTime;
        
        //3.要把偏移量时间清零
        [_scanNetImageView.layer setTimeOffset:0.0];
        //4.设置图层开始动画时间
        [_scanNetImageView.layer setBeginTime:beginTime];
        
        [_scanNetImageView.layer setSpeed:1.0];
    
    }else{
        
        CGFloat scanNetImageViewHeight = 241;
        CGFloat scanWindowHeight = self.view.w - KMargin * 2;
        CGFloat scanNetImageViewWidth = _scanWindow.w;
        
        _scanNetImageView.frame = CGRectMake(0, -scanNetImageViewHeight, scanNetImageViewWidth, scanNetImageViewHeight);
        CABasicAnimation* scanNetAnimation = [CABasicAnimation animation];
        scanNetAnimation.keyPath = @"transform.translation.y";
        scanNetAnimation.byValue = @(scanWindowHeight);
        scanNetAnimation.duration = 1.0;
        scanNetAnimation.repeatCount = MAXFLOAT;
        [_scanNetImageView.layer addAnimation:scanNetAnimation forKey:@"translationAnimation"];
        [_scanWindow addSubview:_scanNetImageView];
    
    
    }

}

/**获取扫描区域*/
-(CGRect)getScanCrop:(CGRect)thyRect andReaderViewBounds:(CGRect)thyReaderViewBounds{
    
    CGFloat x,y,width,height;
    
    x = (CGRectGetHeight(thyReaderViewBounds)-CGRectGetHeight(thyRect))/2/CGRectGetHeight(thyReaderViewBounds);
    y = (CGRectGetWidth(thyReaderViewBounds)-CGRectGetWidth(thyRect))/2/CGRectGetWidth(thyReaderViewBounds);
    width = CGRectGetHeight(thyRect)/CGRectGetHeight(thyReaderViewBounds);
    height = CGRectGetWidth(thyRect)/CGRectGetWidth(thyReaderViewBounds);
    
    return CGRectMake(x, y, width, height);

}


/**打开相册*/
-(void)myQRCodeButtonClicked:(UIButton*)sender{
    
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){  //判断是否有权限打开相册
        
        //1.初始化相册拾取器
        UIImagePickerController* imagePickController = [[UIImagePickerController alloc]init];
        
        //2.设置代理
        imagePickController.delegate = self;
        //3.设置资源
        //UIImagePickerControllerSourceTypePhotoLibrary(相册)，UIImagePickerControllerSourceTypeCamera(相机)，UIImagePickerControllerSourceTypeSavedPhotosAlbum(照片库)
        imagePickController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //4.设置模态转场
        imagePickController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:imagePickController animated:YES completion:nil];
        
    
    }else{
    
        [WCAlertView showAlertWithTitle:@"温馨提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置" customizationBlock:nil completionBlock:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    
    }
}


#pragma mark -=============================ButtonClickedCallBack
- (void)disMiss{
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark -=============================扫描的代理
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if(metadataObjects.count){
        
        [_captureSession stopRunning];
        AVMetadataMachineReadableCodeObject* metaDataObject = [metadataObjects objectAtIndex:0];
        
//        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:metaDataObject.stringValue delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"重新扫描", nil];
//        [alertView show];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:metaDataObject.stringValue]];

    }
    [_captureSession startRunning];
}


#pragma mark -=============================相册拾取器代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //1.获取选择的图片
    UIImage* selectedImage = info[UIImagePickerControllerOriginalImage];
    if (selectedImage.size.width > 768 && selectedImage.size.height>1024) {
        selectedImage =  [self scaleImage:selectedImage toScale:0.5];
    }
    
    //2.初始化一个监测器(判断是否是二维码图片)
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        //监测到的结果数组
        NSArray* features = [detector featuresInImage:[CIImage imageWithCGImage:selectedImage.CGImage] options:nil];
        if(features.count){
            
            /**结果对象做处理*/
            CIQRCodeFeature* feature = [features objectAtIndex:0];
            NSString* scannedResult = feature.messageString;
//            [WCAlertView showAlertWithTitle:@"扫描结果" message:scannedResult customizationBlock:nil completionBlock:nil cancelButtonTitle:@"" otherButtonTitles:nil, nil];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scannedResult]];

        }else{
            [WCAlertView showAlertWithTitle:@"温馨提示" message:@"该图片没有包含二维码!" customizationBlock:nil completionBlock:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        }
    }];


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


#pragma mark -=============================alertViewCallBack
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex){
        [_captureSession startRunning];
    }else{
        [self disMiss];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
