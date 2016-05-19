//
//  CWSDetectionScanViewController.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/15.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSDetectionScanViewController.h"
#import "CWSCarReportViewController.h"
#import "DriveBehaviorDetailsController.h"
#import "CWSDetectionDetailViewController.h"

#define CARWIDTH 145.0f
#define CARHEIGHT 265.0f
#define SCANBUTTON_WIDTH 156.0f
#define SCANBUTTON_HEIGHT 33.0f
#define CARIMAGE_BETWEEN_TOP 65.0f
#define SCANBUTTON_BETWEEN_CARIMAGE 70.0f
#define SCANNING_IMAGE_WIDTH 180.0f
#define SCANNING_IMAGE_HEIGHT 100.0f
#define SYSTEMBUTTON_WIDTH 84.0f
#define SYSTEMBUTTON_HEIGHT 50.0f
#define DETECTRESULTBUTTON_WIDTH 100.0f
#define DETECTRESULTBUTTON_HEIGHT 35.0f
@interface CWSDetectionScanViewController (){

    UIImageView* carOriginalBodyImage; //车辆完整图
    UIImageView* carFrameBodyImage;    //车辆骨架图
    UIImageView* scanningImageView;    //扫描过程图

    UIButton* startScanButton;         //开始扫描按钮
    
    NSTimer* timer;
    
    /**检测状态按钮区*/
    UIButton* motiveSystemButton;      //动力系统
    UIButton* chassisSystemButton;     //底盘系统
    UIButton* bodyworkSystemButton;    //车身系统
    UIButton* applianceSystemButton;   //电器设备    //tag=200~203
    
    
    UIButton* detectResultButton;      //车辆报告300 和 查看详情 301
    
    
    BOOL isScanning;                   //是否正在扫描中
//    NSMutableArray                            *powerArray;//动力系统
//    NSMutableArray                            *frameArray;//车身系统
//    NSMutableArray                            *electricalArray;//电器系统
//    NSMutableArray                            *chassisArray;//底盘系统
}

@end

@implementation CWSDetectionScanViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for (NSDictionary* thyDict in self.obdDataArray) {
        if([PublicUtils isMatchOneOfStringWithObject:thyDict andKey:@"name" andRangeOfString:@"发动机,气节门,空燃比"]){ //动力系统有问题
            if([[thyDict valueForKey:@"fault"] boolValue]){
                [motiveSystemButton setImage:[UIImage imageNamed:@"jiance_wenxian"] forState:UIControlStateNormal];
            }
        }
        if([PublicUtils isMatchOneOfStringWithObject:thyDict andKey:@"name" andRangeOfString:@"水温,环境,油,车速"]){ //车身系统有问题
            if([[thyDict valueForKey:@"fault"] boolValue]){
                [bodyworkSystemButton setImage:[UIImage imageNamed:@"jiance_wenxian"] forState:UIControlStateNormal];
            }
        }
        if([PublicUtils isMatchOneOfStringWithObject:thyDict andKey:@"name" andRangeOfString:@"OBD,obd,养护"]){  //底盘系统有问题
            if([[thyDict valueForKey:@"fault"] boolValue]){
                [chassisSystemButton setImage:[UIImage imageNamed:@"jiance_wenxian"] forState:UIControlStateNormal];
            }
        }
        if([PublicUtils isMatchOneOfStringWithObject:thyDict andKey:@"name" andRangeOfString:@"蓄电池"]){   //电器设备有问题
            if([[thyDict valueForKey:@"fault"] boolValue]){
                [applianceSystemButton setImage:[UIImage imageNamed:@"jiance_wenxian"] forState:UIControlStateNormal];
            }
        }
    }
}

-(instancetype)init{
    if(self = [super init]){
        self.obdDataArray = @[].copy;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"安全扫描";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithRed:0.086f green:0.149f blue:0.173f alpha:1.00f];
    [Utils changeBackBarButtonStyle:self];
    
    //加载完整图
    carOriginalBodyImage = [[UIImageView alloc]init];
    carOriginalBodyImage.frame = CGRectMake((kSizeOfScreen.width-CARWIDTH)/2, CARIMAGE_BETWEEN_TOP, CARWIDTH, CARHEIGHT);
    carOriginalBodyImage.image = [UIImage imageNamed:@"saomiaoqian"];
    [self.view addSubview:carOriginalBodyImage];
    
    
    //加载骨架图
    carFrameBodyImage = [[UIImageView alloc]initWithFrame:CGRectMake((kSizeOfScreen.width-CARWIDTH)/2, CARIMAGE_BETWEEN_TOP, CARWIDTH, 0)];
    carFrameBodyImage.image = [UIImage imageNamed:@"saomiaohou"];
    carFrameBodyImage.hidden = YES;
    carFrameBodyImage.clipsToBounds = YES;
    carFrameBodyImage.contentMode = UIViewContentModeTop;
    [self.view addSubview:carFrameBodyImage];
    

    
    //加载扫描过程图
    scanningImageView = [[UIImageView alloc]initWithFrame:CGRectMake((kSizeOfScreen.width-SCANNING_IMAGE_WIDTH)/2, 0-(SCANNING_IMAGE_HEIGHT-CARIMAGE_BETWEEN_TOP), SCANNING_IMAGE_WIDTH, SCANNING_IMAGE_HEIGHT)];
    scanningImageView.image = [UIImage imageNamed:@"yinying"];
    [scanningImageView setAlpha:0.0f];
    [self.view addSubview:scanningImageView];
    
    
    //加载扫描按钮
    startScanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startScanButton.frame = CGRectMake((kSizeOfScreen.width-SCANBUTTON_WIDTH)/2, CGRectGetMaxY(carOriginalBodyImage.frame)+SCANBUTTON_BETWEEN_CARIMAGE, SCANBUTTON_WIDTH, SCANBUTTON_HEIGHT);
    startScanButton.layer.masksToBounds = YES;
    startScanButton.layer.borderColor = [UIColor whiteColor].CGColor;
    startScanButton.layer.borderWidth = 1.0f;
    startScanButton.layer.cornerRadius = 5.0f;
    [startScanButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, SCANBUTTON_WIDTH/5)];
    [startScanButton setTitle:@"立即扫描" forState:UIControlStateNormal];
    [startScanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startScanButton addTarget:self action:@selector(startScanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startScanButton];
    
    //[self createData];
    [self createDetectSystemButton];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(scanningTimer:) userInfo:nil repeats:YES];
    timer.fireDate = [NSDate distantFuture];
}

//- (void)createData
//{
//    MyLog(@"---------------------------");
//    MyLog(@"%@",self.dataDic[@"dtc"][@"name"]);
//    for (NSDictionary *dic in self.dataDic[@"obd"]) {
//        MyLog(@"%@",dic[@"name"]);
//    }
//    
//    MyLog(@"---------------------------");
//    
//    powerArray = [NSMutableArray array];
//    frameArray= [NSMutableArray array];
//    electricalArray= [NSMutableArray array];
//    chassisArray= [NSMutableArray array];
////    [frameArray addObject:self.dataDic[@"dtc"]];//故障码检测
//    for (NSDictionary *dic in self.dataDic[@"obd"]) {
//        //电气系统
//        if ([dic[@"name"] isEqualToString:@"蓄电池电压"]) {
//            [electricalArray addObject:dic];
//        }
//        //底盘系统
//        else if ([dic[@"name"] isEqualToString:@"OBD时间"] || [dic[@"name"] isEqualToString:@"养护状态"]){
//            [chassisArray addObject:dic];
//        }
//        //车身系统
//        else if ([dic[@"name"] isEqualToString:@"车速"] || [dic[@"name"] isEqualToString:@"环境温度"] || [dic[@"name"] isEqualToString:@"水温"] ){
//            [frameArray addObject:dic];
//        }
//        //动力系统
//        else if ([dic[@"name"] isEqualToString:@"空燃比系数"] || [dic[@"name"] isEqualToString:@"节气门开度"] || [dic[@"name"] isEqualToString:@"发动机负荷"]|| [dic[@"name"] isEqualToString:@"发动机运行时间"] || [dic[@"name"] isEqualToString:@"发动机转速"]){
//            [powerArray addObject:dic];
//        }
//    }
//}

#pragma mark -==============================================CreateUI
-(void)createDetectSystemButton{

    NSArray* detectResultButtonTitle = @[@"车辆报告",@"查看详情"];
    NSInteger tag1 = 0;//动力系统
    NSInteger tag2 = 0;//车身系统
    NSInteger tag3 = 0;//电器系统
    NSInteger tag4 = 0;//底盘系统
//    for (NSDictionary *dic in powerArray) {
//        tag1 += [dic[@"fault"] integerValue];
//    }
//    for (NSDictionary *dic in frameArray) {
//        tag2 += [dic[@"fault"] integerValue];
//    }
//    for (NSDictionary *dic in electricalArray) {
//        tag3 += [dic[@"fault"] integerValue];
//    }
//    for (NSDictionary *dic in chassisArray) {
//        tag4 += [dic[@"fault"] integerValue];
//    }
    
    motiveSystemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    motiveSystemButton.frame = CGRectMake(CGRectGetMinX(scanningImageView.frame)-SYSTEMBUTTON_WIDTH, CGRectGetMinY(carOriginalBodyImage.frame)+57, SYSTEMBUTTON_WIDTH, SYSTEMBUTTON_HEIGHT);
    [self.view addSubview:motiveSystemButton];
    motiveSystemButton.tag = 200;
    motiveSystemButton.hidden = YES;
    [motiveSystemButton setTitle:@"动力系统" forState:UIControlStateNormal];
    [motiveSystemButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [motiveSystemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [motiveSystemButton setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    if (tag1 == 0) {
        [motiveSystemButton setImage:[UIImage imageNamed:@"jiance_zhengchang"] forState:UIControlStateNormal];
        
    }
    else {
        [motiveSystemButton setImage:[UIImage imageNamed:@"jiance_wenxian"] forState:UIControlStateNormal];
    }
    
    [motiveSystemButton setImageEdgeInsets:UIEdgeInsetsMake(0, 33, 20, 0)];


   
    
    chassisSystemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chassisSystemButton.frame = CGRectMake(CGRectGetMaxX(scanningImageView.frame)-20, CGRectGetMinY(motiveSystemButton.frame), SYSTEMBUTTON_WIDTH, SYSTEMBUTTON_HEIGHT);
    chassisSystemButton.tag = 201;
    chassisSystemButton.hidden = YES;
    chassisSystemButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [chassisSystemButton setTitle:@"底盘系统" forState:UIControlStateNormal];
    if (tag4 == 0) {
        [chassisSystemButton setImage:[UIImage imageNamed:@"jiance_zhengchang"] forState:UIControlStateNormal];
    }
    else {
        [chassisSystemButton setImage:[UIImage imageNamed:@"jiance_wenxian"] forState:UIControlStateNormal];
    }
    
    
    [chassisSystemButton setImageEdgeInsets:UIEdgeInsetsMake(0, 33, 20, 0)];
    [chassisSystemButton setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    [self.view addSubview:chassisSystemButton];
    
    
    bodyworkSystemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bodyworkSystemButton.frame = CGRectMake(CGRectGetMinX(scanningImageView.frame)-SYSTEMBUTTON_WIDTH, CGRectGetMaxY(motiveSystemButton.frame)+82, SYSTEMBUTTON_WIDTH, SYSTEMBUTTON_HEIGHT);
    bodyworkSystemButton.tag = 202;
    bodyworkSystemButton.hidden = YES;
    bodyworkSystemButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [bodyworkSystemButton setTitle:@"车身系统" forState:UIControlStateNormal];
    if (tag2 == 0) {
        [bodyworkSystemButton setImage:[UIImage imageNamed:@"jiance_zhengchang"] forState:UIControlStateNormal];
    }
    else {
        [bodyworkSystemButton setImage:[UIImage imageNamed:@"jiance_wenxian"] forState:UIControlStateNormal];
    }
    
    
    [bodyworkSystemButton setImageEdgeInsets:UIEdgeInsetsMake(0, 33, 20, 0)];
    [bodyworkSystemButton setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    [self.view addSubview:bodyworkSystemButton];
    
    applianceSystemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    applianceSystemButton.frame = CGRectMake(CGRectGetMaxX(scanningImageView.frame)-20, CGRectGetMinY(bodyworkSystemButton.frame), SYSTEMBUTTON_WIDTH, SYSTEMBUTTON_HEIGHT);
    applianceSystemButton.tag = 203;
    applianceSystemButton.hidden = YES;
    applianceSystemButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [applianceSystemButton setTitle:@"电器设备" forState:UIControlStateNormal];
    if (tag3 == 0) {
        [applianceSystemButton setImage:[UIImage imageNamed:@"jiance_zhengchang"] forState:UIControlStateNormal];
    }
    else {
        [applianceSystemButton setImage:[UIImage imageNamed:@"jiance_wenxian"] forState:UIControlStateNormal];
    }
    
    
    [applianceSystemButton setImageEdgeInsets:UIEdgeInsetsMake(0, 33, 20, 0)];
    [applianceSystemButton setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    [self.view addSubview:applianceSystemButton];
    
    CGFloat detectButtonTrim = (kSizeOfScreen.width-2*DETECTRESULTBUTTON_WIDTH)/3;
    
    for(int i=0; i<detectResultButtonTitle.count; i++){
        detectResultButton = [UIButton buttonWithType:UIButtonTypeCustom];
        detectResultButton.frame = CGRectMake(i*(DETECTRESULTBUTTON_WIDTH+detectButtonTrim) + detectButtonTrim, CGRectGetMinY(startScanButton.frame), DETECTRESULTBUTTON_WIDTH , DETECTRESULTBUTTON_HEIGHT);
        detectResultButton.tag = 300 + i;
        detectResultButton.hidden = YES;
        detectResultButton.layer.masksToBounds = YES;
        detectResultButton.layer.borderColor = [UIColor whiteColor].CGColor;
        detectResultButton.layer.borderWidth = 1.0f;
        detectResultButton.layer.cornerRadius = 5.0f;
        [detectResultButton setTitle:detectResultButtonTitle[i] forState:UIControlStateNormal];
        [self.view addSubview:detectResultButton];
    }

}



#pragma mark -==============================================OtherCallBack
/**开始扫描的按钮回调*/
-(void)startScanButtonClicked:(UIButton*)sender{
   // carOriginalBodyImage.hidden = !carOriginalBodyImage.hidden;
    
    //检测数据请求
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setValue:KUserManager.uid forKey:@"uid"];
//    [dic setValue:KUserManager.mobile forKey:@"mobile"];
//    [dic setValue:KUserManager.car.cid forKey:@"cid"];
//    [ModelTool getCarCheckWithParameter:dic andSuccess:^(id object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if ([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
//                NSLog(@"%@",object);
//                
//            }
//            else {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
//            }
//        });
//        
//    } andFail:^(NSError *err) {
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求有问题,请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    [alert show];
//    }];
    
    if(!isScanning){
        sender.selected = YES;
        [startScanButton setTitle:@"正在扫描..." forState:UIControlStateNormal];
        [startScanButton setImage:[UIImage imageNamed:@"shuaxin"] forState:UIControlStateNormal];
        isScanning = YES;
        [UIView animateWithDuration:0.6 animations:^{
            [scanningImageView setAlpha:1.0f];
        }];
        carFrameBodyImage.hidden = NO;
        timer.fireDate = [NSDate distantPast];
        [self startScanningRotateAnimation];
    }
}

/**扫描结束按钮选择*/
-(void)detectResultButtonClicked:(UIButton*)sender{
    
    switch(sender.tag-300){
    
        case 0:{
            //车辆报告
            CWSCarReportViewController* reportVc = [CWSCarReportViewController new];
            [self.navigationController pushViewController:reportVc animated:YES];
            
        };break;
        case 1:{
            //查看详情
            CWSDetectionDetailViewController* detailVc = [[CWSDetectionDetailViewController alloc] init];
            detailVc.obdDataArray = self.obdDataArray;
            [self.navigationController pushViewController:detailVc animated:YES];
        
        };break;
    
        default:break;
    }
    
}


-(void)scanningTimer:(NSTimer*)thyTimer{
    
    CGRect currentScanningImageViewFrame = scanningImageView.frame;
    CGRect currentCarFrameImageViewFrame = carFrameBodyImage.frame;
    float currentScanningY = currentScanningImageViewFrame.origin.y + 1.0f;
    float currentCarFrameHeight = currentCarFrameImageViewFrame.size.height + 1;
    currentScanningImageViewFrame.origin.y = currentScanningY;
    currentCarFrameImageViewFrame.size.height = currentCarFrameHeight;
    scanningImageView.frame = currentScanningImageViewFrame;
    carFrameBodyImage.frame = currentCarFrameImageViewFrame;
    if(currentCarFrameHeight >= CARHEIGHT + 20){
        [UIView animateWithDuration:0.6 animations:^{
            [scanningImageView setAlpha:0.0f];
        }];
    }
    if(currentCarFrameHeight >= CARHEIGHT+30){
        scanningImageView.hidden = YES;
        startScanButton.selected = NO;
        startScanButton.hidden = YES;
        isScanning = NO;
        [startScanButton.imageView.layer removeAllAnimations];
        for(int i=0; i<2; i++){
            UIButton* button = (UIButton*)[self.view viewWithTag:300+i];
            button.hidden = NO;
            [button addTarget:self action:@selector(detectResultButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        timer.fireDate = [NSDate distantFuture];
        [timer invalidate];
    }
    if(CGRectGetMaxY(scanningImageView.frame) == CGRectGetMaxY(motiveSystemButton.frame)+20){
        chassisSystemButton.hidden = NO;
        motiveSystemButton.hidden = NO;
    }
    if(CGRectGetMaxY(scanningImageView.frame) == CGRectGetMaxY(bodyworkSystemButton.frame)+20){
        bodyworkSystemButton.hidden = NO;
        applianceSystemButton.hidden = NO;
    }
}

/**扫描图片旋转*/
-(void)startScanningRotateAnimation{
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    rotationAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//    rotationAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0)];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100;
    [startScanButton.imageView.layer addAnimation:rotationAnimation forKey:nil];
}
-(CATransition*)showUpViewAnimation{
    
    CATransition* transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type = @"pageCurl";
    transition.subtype = kCATransitionFromBottom;
    return transition;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
