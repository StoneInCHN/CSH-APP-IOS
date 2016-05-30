//
//  CWSAddCarController.m
//  CarDefender
//
//  Created by 周子涵 on 15/3/28.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSAddCarController.h"
#import "CWSInputCarNubController.h"
#import "CarManagerMsg.h"
#import "LHPChooseCarMenulController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "UIImageView+WebCache.h"
#import "ChooseCarColorView.h"
#import "CWSAboutAdditionalController.h"
#import "CWSAddCarNexCheckView.h"

#import "CWSCarManagerDeviceOkController.h"

#import "CWSCarMangerAddNoDeviceController.h"

#import "CWSCarManageController.h"

#import "CWSCarMangerChooseOKController.h"

#import "CWSCarBoundOKController.h"//设备ID第二次绑定跳转位置


#import "CWSSelectCarAreaController.h"

#import "IQKeyboardManager.h"
#import "CWSBoundIDViewController.h"

@interface CWSAddCarController ()<UIActionSheetDelegate,UITextFieldDelegate,BMKGeoCodeSearchDelegate,ChooseCarColorViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate,CWSAddCarNexCheckViewDelegate>
{
    UIScrollView*_scrollView;
    __weak IBOutlet UILabel*  _carColorLabel;
    __weak IBOutlet UIView *   _carColorView;
    NSMutableDictionary*_bodyDic;
    NSString*   _cityStr;
    BMKGeoCodeSearch*        _geocodesearch;
    bool                     isGeoSearch;
    NSDictionary*simpleDic;
    
    NSArray* areaArray;
    
    NSString*shortString;
    ChooseCarColorView*chooseColorView;
    NSDictionary*colorDic;
    
    UIButton*btn;
    float moreHeight;
    
    CWSAddCarNexCheckView*_chooseCheckTime;
    
    BOOL _isEditing;//判断是否被编辑过
    
    BOOL _gotoChooseCost;//1表示跳转到选费界面0表示返回到上一个界面
    UIView  *helpBackView;
    UIView *helpPhotoView;
    NSDictionary*carBackDic;//车辆信息返回数据
    
    int identifier;  //标示年检和保险
}
@end

@implementation CWSAddCarController

-(void)getLocationCity{
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    isGeoSearch = false;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = (CLLocationCoordinate2D){KManager.currentPt.latitude, KManager.currentPt.longitude};
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        MyLog(@"反geo检索发送成功");
    }
    else
    {
        MyLog(@"反geo检索发送失败");
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.carNumberTextField.keyboardType=UIKeyboardTypeDefault;
   
    
    [Utils changeBackBarButtonStyle:self];
    _isEditing=NO;
    _gotoChooseCost=NO;
    [self buildUI];
    
    //判断是添加还是编辑
    [self judgeAddOrEdit];
    //设置只可以点击一次
    
    [self.chooseCarBtn setExclusiveTouch:YES];
    
   // [self.carNubBtn setExclusiveTouch:YES];
    //[self.carColorBtn setExclusiveTouch:YES];
    
    
}

#pragma mark - 键盘通知
-(void)buildKeyboardNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 键盘出现
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if ([self.currentKiloText isFirstResponder]){
        [self keboardAppearAndBaseViewMoveWithTextField:self.currentKiloText withCGsize:kbSize];
    }else if ([self.lastKilomText isFirstResponder]) {
        [self keboardAppearAndBaseViewMoveWithTextField:self.lastKilomText withCGsize:kbSize];
    }else if ([self.nextCheckText isFirstResponder]){
        [self keboardAppearAndBaseViewMoveWithTextField:self.nextCheckText withCGsize:kbSize];
    }else if ([self.carBoundIdTextFiled isFirstResponder]){
        [self keboardAppearAndBaseViewMoveWithTextField:self.carBoundIdTextFiled withCGsize:kbSize];
    }
    else if ([self.carFrameField isFirstResponder]){
        [self keboardAppearAndBaseViewMoveWithTextField:self.carFrameField withCGsize:kbSize];
    }
}
-(void)keboardAppearAndBaseViewMoveWithTextField:(UITextField*)textField withCGsize:(CGSize)kbSize
{
    
    CGRect viewFrame;
    float heightText=self.groundView.frame.origin.y+textField.superview.frame.size.height+textField.superview.frame.origin.y-self.scrollerView.contentOffset.y;
    if (heightText+kbSize.height>self.view.frame.size.height-100) {
        viewFrame=self.view.frame;
        
        viewFrame.origin.y=self.view.frame.size.height-heightText-kbSize.height-120;
        self.view.frame=viewFrame;
    }
    
}
#pragma mark - 键盘消失
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    CGRect viewFrame;
    viewFrame=self.view.frame;
    
    viewFrame.origin.y=0;
    
    self.view.frame=viewFrame;
}

#pragma mark - 试图将要显示
-(void)viewWillAppear:(BOOL)animated
{
    [self.carNumberTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.navigationController setNavigationBarHidden:NO];
    _scrollerView.contentOffset=CGPointMake(0, 0);
    
    //关闭当前键盘第三方的处理，避免引起冲突
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    [self buildKeyboardNoti];
    if (btn==nil) {
        btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 90, 44)];
        btn.backgroundColor=[UIColor clearColor];
        //判断是否放弃编辑
        [btn addTarget:self action:@selector(goBackEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.navigationController.view addSubview:btn];
    
    if (self.carNubString) {//添加车牌号
        self.carNumberTextField.text = self.carNubString;
        [_bodyDic setObject:[self.carNubString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"plateNo"];
    }
    if ([self.noDeviceComeBackEdit isEqualToString:@"回来了"]) {
        _isEditing = NO;
    }else{
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chooseCarMsgBack:) name:@"chooseCarBack" object:nil];//选车返回
}

#pragma mark - 试图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    
    [btn removeFromSuperview];
    self.noDeviceComeBackEdit = nil;
    if (_gotoChooseCost) {
        _gotoChooseCost=NO;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [ModelTool stopAllOperation];
}

//点击事件
-(void)goBackEvent:(UIButton*)sender
{
    if (_isEditing) {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否放弃添加车辆信息？" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"继续添加", nil];
        alert.tag=1111;
        [alert show];
    }else{
        if ([self.noDeviceComeBackEdit isEqualToString:@"回来了"]) {
            self.noDeviceComeBackEdit = @"";
            if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] isKindOfClass:[CWSCarManageController class]]) {
                CWSCarManageController *carManager = (CWSCarManageController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
                carManager.backMsg = @"回来了";
                [self.navigationController popToViewController:carManager animated:YES];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}



#pragma mark - 提示框代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1111) {
        if (buttonIndex==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (alertView.tag==1110){
        if (buttonIndex==1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"4007930888"]]];
        }
    }
}
#pragma mark - 创建试图
-(void)buildUI{
    self.scrollerView.scrollEnabled = YES;
    [self.sureBtn setTitle:@"保存" forState:UIControlStateNormal];
    [Utils setViewRiders:_carColorView riders:8];
    [Utils setBianKuang:[UIColor colorWithRed:(255)/255.0 green:(247)/255.0 blue:(25)/255.0 alpha:0.5] Wide:0.5 view:_carColorView];
  //  self.carJiaNubText.delegate=self;
  //  self.carIDText.delegate=self;
    self.carBoundIdTextFiled.delegate = self;
    self.carNumberTextField.delegate = self;
    [self.scrollerView addSubview:self.groundView];
    [self.groundView setFrame:CGRectMake(0, 0, kSizeOfScreen.width, self.groundView.frame.size.height)];
    self.scrollerView.contentSize = CGSizeMake(0, self.groundView.frame.size.height);
    self.scrollerView.showsHorizontalScrollIndicator=NO;
    self.scrollerView.delegate=self;
    _bodyDic=[NSMutableDictionary dictionary];

    [self getLocationCity];
    UITapGestureRecognizer*tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
    [self.view addGestureRecognizer:tapGesture1];
    simpleDic=@{@"浙江省":@"浙",@"福建省":@"闽",@"广东省":@"粤",@"北京市":@"京",@"天津市":@"津",@"河北省":@"冀",@"山西省":@"晋",@"内蒙古自治区":@"蒙",@"辽宁省":@"辽",@"吉林省":@"吉",@"黑龙江省":@"黑",@"上海市":@"泸",@"江苏省":@"苏",@"安徽省":@"皖",@"江西省":@"赣",@"山东省":@"鲁",@"河南省":@"豫",@"湖北省":@"鄂",@"湖南省":@"湘",@"广西壮族自治区":@"桂",@"海南省":@"琼",@"重庆市":@"渝",@"四川省":@"川",@"贵州省":@"贵",@"云南省":@"云",@"西藏自治区":@"藏",@"陕西省":@"陕",@"甘肃省":@"甘",@"青海省":@"青",@"宁夏回族自治区":@"宁",@"新疆维吾尔族自治区":@"新"};
    colorDic=@{@"黑色":KBlackMainColor,@"白色":[UIColor whiteColor],@"红色":[UIColor redColor],@"蓝色":[UIColor blueColor],@"绿色":[UIColor greenColor],@"银灰色":[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1],@"黄色":[UIColor yellowColor]};
    [self.chooseCarBtn setBackgroundImage:[UIImage imageNamed:@"btnHight_whiteBack"] forState:UIControlStateHighlighted];
    //[self.carNubBtn setBackgroundImage:[UIImage imageNamed:@"btnHight_whiteBack"] forState:UIControlStateHighlighted];
   // [self.carColorBtn setBackgroundImage:[UIImage imageNamed:@"btnHight_whiteBack"] forState:UIControlStateHighlighted];
    
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    fmt.dateFormat = @"YYYY-MM-dd";
//    NSString *time = [fmt stringFromDate:[NSDate date]];
//    self.nextCheckText.text=time;
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self Actiondo:nil];
}
#pragma mark - 判断是添加还是编辑
-(void)judgeAddOrEdit
{
    //编辑
    NSLog(@"edit=%@",self.editDic);
    if (self.editDic!=nil) {
        
        if (1) {
            
            CGRect backViewFrame=self.groundView.frame;
            backViewFrame.origin.y=self.addCarHeadView.frame.size.height;
            self.groundView.frame=backViewFrame;
            
            self.scrollerView.contentSize=CGSizeMake(self.view.frame.size.width, self.groundView.frame.size.height+self.groundView.frame.origin.y);
            
            NSString*url=[NSString stringWithFormat:@"%@%@",kBaseUrl ,self.editDic[@"brandIcon"]];
            NSURL*logoImgUrl=[NSURL URLWithString:url];
            [self.carImage setImageWithURL:logoImgUrl placeholderImage:[UIImage imageNamed:@"normal_car_brand"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
        }
        
        self.carCheXinLabel.text=[NSString stringWithFormat:@"%@",self.editDic[@"vehicleFullBrand"]];
        //车牌
        
        self.carNumberTextField.text = [self.editDic[@"plate"] substringFromIndex:2];
        self.carAreaLabel.text = [self.editDic[@"plate"] substringToIndex:1];
        self.carLetterLabel.text = [self.editDic[@"plate"] substringWithRange:NSMakeRange(1, 1)];
        
        
        //上次保养后行驶里程  MMile
        
        self.lastKilomText.text=[NSString stringWithFormat:@"%@",self.editDic[@"lastMaintainMileage"]];
        //当前里程  MMileage
        
        self.currentKiloText.text=[NSString stringWithFormat:@"%@",self.editDic[@"driveMileage"]];
        //下次年检时间  NInspect
        
        self.nextCheckText.text=[NSString stringWithFormat:@"%@",self.editDic[@"nextAnnualInspection"]];
        
        //下次交强险时间  NInspect
        
        self.jiaoqiangxian.text=[NSString stringWithFormat:@"%@",self.editDic[@"trafficInsuranceExpiration"]];
        
        //下次商业时间  NInspect
        
//        self.shangyexian.text=[NSString stringWithFormat:@"%@",self.editDic[@"commercialInsuranceExpiration"]];
        //设备ID
        if ([PublicUtils checkNSNullWithgetString:self.editDic[@"device"]] != nil) {
            self.carBoundIdTextFiled.text  = [NSString stringWithFormat:@"%@",[PublicUtils checkNSNullWithgetString:self.editDic[@"device"]]];
            self.carBoundIdTextFiled.enabled = NO;
        }else {
            self.bindIDView.alpha = 0;
        }
        
        if (self.carBoundIdTextFiled.text.length == 0) {
            self.bindIDView.alpha = 0;
        }else {
            self.bindIDView.alpha = 1;
        }
        
        //车架号码
        if ([PublicUtils checkNSNullWithgetString:self.editDic[@"vehicleNo"]]) {
            self.carFrameField.text = [NSString stringWithFormat:@"%@",[PublicUtils checkNSNullWithgetString:self.editDic[@"vehicleNo"]]];
        }
        
    }else{
        [self.sureBtn setTitle:@"保存" forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:[UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1] forState:UIControlStateNormal];

    }
}
#pragma mark - 收键盘
-(void)Actiondo:(UIGestureRecognizer*)sender{
//    if ([self.carIDText isFirstResponder]) {
//        [self.carIDText resignFirstResponder];
//        return;
//    }else if ([self.carJiaNubText isFirstResponder]) {
//        [self.carJiaNubText resignFirstResponder];
//        return;
//    }else if ([self.currentKiloText isFirstResponder]) {
//        [self.currentKiloText resignFirstResponder];
//        return;
//    }else if ([self.lastKilomText isFirstResponder]) {
//        [self.lastKilomText resignFirstResponder];
//        return;
//    }
//    [self.view endEditing:YES];
}
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    _cityStr = result.addressDetail.city;
    NSArray*array=[simpleDic allKeys];
    if ([array containsObject:_cityStr]) {
        shortString=simpleDic[_cityStr];
    }
}
#pragma mark - 车辆信息返回数据

-(void)chooseCarMsgBack:(NSNotification*)sender
{
    carBackDic = [NSDictionary dictionaryWithDictionary:sender.object];
    
    NSLog(@"sdfsdfs=%@",carBackDic);
//    [_bodyDic setObject:carBackDic[@"brandCar"][@"id"] forKey:@"brand"];//车辆品牌
//    [_bodyDic setObject:carBackDic[@"modelCar"][@"id"] forKey:@"series"];//车系
//    [_bodyDic setObject:carBackDic[@"styleCar"][@"id"] forKey:@"module"];//车型
//    [_bodyDic setObject:@"black" forKey:@"color"];
    [_bodyDic setObject:carBackDic[@"styleCar"][@"id"] forKey:@"brandDetailId"];
    CGRect backViewFrame=self.groundView.frame;
    backViewFrame.origin.y=self.addCarHeadView.frame.size.height;
    self.groundView.frame=backViewFrame;
    
    self.scrollerView.contentSize=CGSizeMake(self.view.frame.size.width, self.groundView.frame.size.height+self.groundView.frame.origin.y);
   
    self.carCheXinLabel.text=[NSString stringWithFormat:@"%@-%@",carBackDic[@"brandCar"][@"name"],carBackDic[@"modelCar"][@"name"]];
   
    NSString*url=[NSString stringWithFormat:@"http://120.27.92.247:10001/csh-interface%@",carBackDic[@"brandCar"][@"icon"]];
    NSURL*logoImgUrl=[NSURL URLWithString:url];
    [self.carImage setImageWithURL:logoImgUrl placeholderImage:[UIImage imageNamed:@"normal_car_brand"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self Actiondo:nil];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _isEditing=YES;

}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.carNumberTextField) {
        if (textField.text.length > 5) {
            textField.text = [textField.text substringToIndex:5];
        }
    }
}


- (IBAction)shopIDTextChange:(UITextField *)sender {
    sender.text=sender.text.uppercaseString;
}

- (IBAction)btnClick:(UIButton *)sender {
//    [self resignFirst];
    _isEditing=YES;
    [self Actiondo:nil];
    switch (sender.tag) {
        case 1://车型选择
        {
            LHPChooseCarMenulController*chooseCarVC=[[LHPChooseCarMenulController alloc]initWithNibName:@"LHPChooseCarMenulController" bundle:nil];
            chooseCarVC.notiKey=@"chooseCarBack";
            [self.navigationController pushViewController:chooseCarVC animated:YES];
        }
            break;
        case 2://车牌号输入
        {
            
            CWSInputCarNubController*inputVC=[[CWSInputCarNubController alloc]initWithNibName:@"CWSInputCarNubController" bundle:nil];
            if (self.carNumberTextField.text.length==7) {
                inputVC.carNubAllString=self.carNumberTextField.text;
            }else{
                if (shortString.length) {
                    inputVC.shortString=shortString;
                }
            }
            [self.navigationController pushViewController:inputVC animated:YES];
        }
            break;
        case 3://车型颜色
        {
            
            
            if (chooseColorView==nil) {
                chooseColorView=[[ChooseCarColorView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                [chooseColorView buildView];
                chooseColorView.delegate=self;
            }
            [self.view addSubview:chooseColorView];
        }
            break;
        case 4:
        {
            [self sureEvent];
        }
            break;
        case 5:
        {
            MyLog(@"5");
        }
            break;
        case 6://惯用油
        {
            UIActionSheet*actionSheet=[[UIActionSheet alloc]initWithTitle:@"惯用油" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"97#汽油",@"93#汽油",@"0#柴油", nil];
            actionSheet.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
            [actionSheet showInView:self.view];
        }
            break;
        case 7://距下次年检
        {
            if (_chooseCheckTime==nil) {
                _chooseCheckTime = [[CWSAddCarNexCheckView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            }
            [_chooseCheckTime loadDatePickerView];
            _chooseCheckTime.delegate=self;
            [self.view addSubview:_chooseCheckTime];
            [self.view endEditing:YES];
            identifier = 7;
        }
            break;
        case 9://交强险
        {
            if (_chooseCheckTime==nil) {
                _chooseCheckTime = [[CWSAddCarNexCheckView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            }
            [_chooseCheckTime loadDatePickerView];
            _chooseCheckTime.delegate=self;
            [self.view addSubview:_chooseCheckTime];
            [self.view endEditing:YES];
            identifier = 9;
        }
            break;
        case 10://商业险
        {
            if (_chooseCheckTime==nil) {
                _chooseCheckTime = [[CWSAddCarNexCheckView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            }
            [_chooseCheckTime loadDatePickerView];
            _chooseCheckTime.delegate=self;
            [self.view addSubview:_chooseCheckTime];
            [self.view endEditing:YES];
            identifier = 10;
        }
            break;
        case 8://车架号码帮助
        {
            [self.view endEditing:YES];
            helpBackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            helpBackView.backgroundColor = KBlackMainColor;
            helpBackView.alpha = 0.2;
            helpPhotoView = [[[NSBundle mainBundle] loadNibNamed:@"HelpView" owner:self options:nil] lastObject];
            [self.view addSubview:helpBackView];
            [self.view addSubview:helpPhotoView];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 确认添加或保持编辑
-(void)sureEvent{
//    [self checkMsgIsOK];
    
    if (!self.carCheXinLabel.text.length) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择车型" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    if (!self.carNumberTextField.text.length) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入车牌号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }

    
    [_bodyDic setObject:KUserInfo.desc forKey:@"userId"]; //uid
    [_bodyDic setObject:KUserInfo.token forKey:@"token"]; //电话
    
    if(self.carNumberTextField.text){  //车牌号码
        NSString* myPlate = [NSString stringWithFormat:@"%@%@%@",self.carAreaLabel.text,self.carLetterLabel.text,self.carNumberTextField.text];
       // NSString* myPlate = [temp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_bodyDic setObject:myPlate forKey:@"plateNo"];
    }
    
    if (self.currentKiloText.text.length) {  //行驶里程
        if ([self.currentKiloText.text floatValue]>=0 && [self.currentKiloText.text floatValue]<1000001) {
            [_bodyDic setObject:self.currentKiloText.text forKey:@"driveMileage"];
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前里程输入有误，其里程数应该为0-1000000km" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
        }
    }
    
    if(self.lastKilomText.text.length){  //上次保养里程
        [_bodyDic setObject:self.lastKilomText.text forKey:@"lastMaintainMileage"];
    }else{
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前里程输入有误，其里程数应该为0-1000000km" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    
    if (self.nextCheckText.text.length) {   //下次年检
        [_bodyDic setObject:[self.nextCheckText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"nextAnnualInspection"];
    }else{
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入年检时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    
    if (self.currentKiloText.text.length && self.lastKilomText.text.length) {
        if ([self.currentKiloText.text integerValue]<[self.lastKilomText.text integerValue]) {
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前里程必须大于或等于上次保养后行驶里程。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
        }
    }
    if (self.jiaoqiangxian.text.length) {   //交强险
        [_bodyDic setObject:[self.jiaoqiangxian.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"trafficInsuranceExpiration"];
    }else{
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入交强险时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    
  
#pragma mark -====================================================参数验证
    if (self.carBoundIdTextFiled.text.length) { //绑定设备ID
        if (self.carBoundIdTextFiled.text.length==10) {
            //[_bodyDic setObject:self.carBoundIdTextFiled.text forKey:@""];
        }else{
            //[[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的设备ID" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            //return;
        }
    }
    
    if ([Utils checkNubOrLetter:self.carFrameField.text]) {//判断车架号是否符合字母和数字要求
        [_bodyDic setObject:self.carFrameField.text forKey:@"vehicleNo"];
    }else{
        if (self.carFrameField.text.length) {
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"车架号只能含有字母和数字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
        }
    }
    
    

    
    if ([self.title isEqualToString:@"编辑车辆"]) {//编辑
        
//        [self showHudInView:self.view hint:@"编辑保存中"];
//        [ModelTool httpAppUpCarWithParameter:_bodyDic success:^(id object) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                MyLog(@"%@",object);
//                if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
////                    NSString*feedMsg = object[@"data"][@"feed"];//判断是否跳转
////                    NSString*cidCarString=[NSString stringWithFormat:@"%@",object[@"data"][@"msg"]];//车辆id
//                    if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] isKindOfClass:[CWSCarManageController class]]) {//是重车辆管理跳过来的
//                        CWSCarManageController* carManagerVC = (CWSCarManageController* )[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
//                        carManagerVC.backMsg = @"回来了";
//                    }
//                    if (self.carIDText.userInteractionEnabled) {//新添加的设备id
//                        if (self.carIDText.text.length) {//有设备id
//                            //获取app登陆信息
//                            [ModelTool httpAppGainNewLoginWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key} success:^(id object) {
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    [self hideHud];
//                                    if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
//                                        [self setUserMsg:object[@"data"]];
//                                        if (KUserManager.type) {//隐藏
//                                            [self goBackToCarManger];
//                                        }else{//显示
////                                            if ([feedMsg isEqualToString:@"0"]) {//已选择过费用
//                                                CWSCarBoundOKController*boundOKVC = [[CWSCarBoundOKController alloc]initWithNibName:@"CWSCarBoundOKController" bundle:nil];
//                                                [self.navigationController pushViewController:boundOKVC animated:YES];
////                                            }else{//没有选择过费用
////                                                CWSCarManagerDeviceOkController*carDeviceOk=[[CWSCarManagerDeviceOkController alloc]initWithNibName:@"CWSCarManagerDeviceOkController" bundle:nil];
////                                                _gotoChooseCost=YES;
////                                                carDeviceOk.carCid=cidCarString;
////                                                [self.navigationController pushViewController:carDeviceOk animated:YES];
////                                            }
//                                        }
//                                    }
//                                });
//                            } faile:^(NSError *err) {
//                                [self hideHud];
//                            }];
//                        }else{//没有设备id
//                            [self hideHud];
//                            if (KUserManager.type) {//隐藏
//                                [self goBackToCarManger];
//                            }else{//显示
//                                CWSCarMangerAddNoDeviceController*nodevice=[[CWSCarMangerAddNoDeviceController alloc]initWithNibName:@"CWSCarMangerAddNoDeviceController" bundle:nil];
//                                _gotoChooseCost=YES;
//                                [self.navigationController pushViewController:nodevice animated:YES];
//                            }
//                        }
//                    }else{
//                        [self hideHud];
//                        [self goBackToCarManger];
//                    }
//                }else{
//                    [self hideHud];
//                    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [alert show];
//                }
//            });
//        } faile:^(NSError *err) {
//            [self hideHud];
//        }];
        //车id
        [_bodyDic setValue:self.editDic[@"id"] forKey:@"vehicleId"];
//        [_bodyDic setValue:self.editDic[@"brand"][@"brand"] forKey:@"brand"];
//        [_bodyDic setValue:self.editDic[@"brand"][@"series"] forKey:@"series"];
//        [_bodyDic setValue:self.editDic[@"brand"][@"module"] forKey:@"module"];

        
        
        
        if ([self respondsToSelector:@selector(chooseCarMsgBack:)]) {
            if (carBackDic != nil) {
//                [_bodyDic setObject:carBackDic[@"brandCar"][@"id"] forKey:@"brand"];//车辆品牌
//                [_bodyDic setObject:carBackDic[@"modelCar"][@"id"] forKey:@"series"];//车系
//                [_bodyDic setObject:carBackDic[@"styleCar"][@"id"] forKey:@"module"];//车型
                [_bodyDic setObject:carBackDic[@"styleCar"][@"id"] forKey:@"brandDetailId"];//车型id
                //[_bodyDic setObject:carBackDic[@"modelCar"][@"id"] forKey:@"vehicleId"];//车系
            }
            
        }
        NSLog(@"%@",_bodyDic);
        [self editCarDetail:_bodyDic];
       // [_bodyDic setValue:@"black" forKey:@"color"];
        
       /*[MBProgressHUD showMessag:@"编辑保存中..." toView:self.view];
        
        [ModelTool editVehicleInfoWithParameter:_bodyDic andSuccess:^(id object) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]){
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    MyLog(@"------insert-------%@",object);
                    if(object[@"data"][@"id"]){
                        NSString* userCid = object[@"data"][@"id"];
                        NSUserDefaults* thyUserDefaults = [NSUserDefaults standardUserDefaults];
                        [thyUserDefaults setValue:userCid forKey:@"cid"];
                        [NSUserDefaults resetStandardUserDefaults];
                        KUserManager.userCID = userCid;
                        MyLog(@"我的CID：%@",KUserManager.userCID);
                        //编辑的时候若没有显示设备ID可跳转页面
                        if(!self.bindIDView.alpha){
                            CWSBoundIDViewController* boundIdVc = [[CWSBoundIDViewController alloc]init];
                            boundIdVc.idString = _bodyDic[@"cid"];
                            [self.navigationController pushViewController:boundIdVc animated:YES];
                        }else{
                            [WCAlertView showAlertWithTitle:@"提示" message:@"保存成功!" customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                                if(!buttonIndex){
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                            } cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                        }
                    }
                    
                }else {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[PublicUtils showServiceReturnMessage:object[@"message"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            });
            
        } andFail:^(NSError *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络出错,请重新加载" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];*/
        
    }else{//添加
        
        

#if USENEWVERSION
//    MyLog(@"-------------添加的车辆信息-------------:%@",_bodyDic);
//    [ModelTool insertVehicleInfoWithParameter:_bodyDic andSuccess:^(id object) {
//        MyLog(@"------insert-------%@",object[@"message"]);
//        MyLog(@"------insert-------%@",object);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]){
//                if(object[@"data"][@"id"]){
//                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                    if (!KUserManager.userCID) {
//                        NSString* userCid = object[@"data"][@"id"];
//                        NSUserDefaults* thyUserDefaults = [NSUserDefaults standardUserDefaults];
//                        [thyUserDefaults setValue:userCid forKey:@"cid"];
//                        [NSUserDefaults resetStandardUserDefaults];
//                        KUserManager.userCID = userCid;
//                        MyLog(@"我的CID：%@",KUserManager.userCID);
//                    }
//                    
//                    CWSBoundIDViewController *vc = [[CWSBoundIDViewController alloc] init];
//                    vc.idString = _bodyDic[@"cid"];
//                    [self.navigationController pushViewController:vc animated:YES];
//                    
//             
//               }
//            }else {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[PublicUtils showServiceReturnMessage:object[@"message"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//        });
//    } andFail:^(NSError *err) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络出错,请重新加载" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }];
        NSLog(@"bodydic=%@",_bodyDic);
        [self addCarDetail:_bodyDic];
        
#else
    [ModelTool httpGetAppAddCarWithParameter:_bodyDic success:^(id object) {
        MyLog(@"%@\n%@",object,object[@"data"]);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                NSString*feedMsg = object[@"data"][@"feed"];
                NSString*cidCarString=[NSString stringWithFormat:@"%@",object[@"data"][@"msg"]];
                if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] isKindOfClass:[CWSCarManageController class]]) {//是重车辆管理跳过来的
                    CWSCarManageController* carManagerVC = (CWSCarManageController* )[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
                    carManagerVC.backMsg = @"回来了";
                }
                //获取app登陆信息
                [self getUserMsgWithFeed:feedMsg andWith:cidCarString withCarID:object[@"data"][@"msg"]];
            }else{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if ([object[@"data"][@"msg"] isEqualToString:@"设备效验失败，请联系销售商户，或拨打4007930888"]) {
                    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
                    [alert show];
                    alert.tag=1110;
                    return;
                }else{
                    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
        });
    } faile:^(NSError *err) {
        [self hideHud];
    }];
#endif
    }
}
//编辑车辆

-(void)editCarDetail:(NSDictionary*)dic{
    [MBProgressHUD showMessag:@"编辑保存中..." toView:self.view];
    [HttpHelper insertVehicleEditWithUserID:dic success:^(AFHTTPRequestOperation *operation,id object){
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if([object[@"code"] isEqualToString:SERVICE_SUCCESS]){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                MyLog(@"------insert-------%@",object);
                
                //编辑的时候若没有显示设备ID可跳转页面
                NSLog(@"%@",self.editDic);
                NSString *deviceNo = [NSString stringWithFormat:@"%@",self.editDic[@"deviceNo"]];
                NSLog(@"%@",deviceNo);

                if([deviceNo isEqualToString:@"<null>"]){
                    CWSBoundIDViewController* boundIdVc = [[CWSBoundIDViewController alloc]init];
                    boundIdVc.idString = self.editDic[@"id"];
                    [self.navigationController pushViewController:boundIdVc animated:YES];
                }else{
                    [WCAlertView showAlertWithTitle:@"提示" message:@"保存成功!" customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        if(!buttonIndex){
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    } cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                }
                
                
            }else {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[PublicUtils showServiceReturnMessage:object[@"message"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        });

    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

}
//添加车辆的接口
-(void)addCarDetail:(NSDictionary *)dic{
    [MBProgressHUD showMessag:@"添加中..." toView:self.view];
    [HttpHelper insertVehicleAddWithUserID:dic success:^(AFHTTPRequestOperation *operation,id object){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"object==%@",object);
        if ([object[@"code"] isEqualToString:SERVICE_SUCCESS]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!KUserManager.userCID) {
                    NSString* userCid = object[@"desc"];
                    NSUserDefaults* thyUserDefaults = [NSUserDefaults standardUserDefaults];
                    [thyUserDefaults setValue:userCid forKey:@"cid"];
                    [NSUserDefaults resetStandardUserDefaults];
                    KUserManager.userCID = userCid;
                    MyLog(@"我的CID：%@",KUserManager.userCID);
                }
                
                CWSBoundIDViewController *vc = [[CWSBoundIDViewController alloc] init];
                //vc.idString = _bodyDic[@"cid"];
                vc.idString = object[@"desc"];
                NSLog(@"%@",vc.idString);
                [self.navigationController pushViewController:vc animated:YES];
                
                
                
                
            });
            
        }else{
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[PublicUtils showServiceReturnMessage:object[@"desc"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];

        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络出错,请重新加载" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];

}
-(void)getUserMsgWithFeed:(NSString*)feedMsg andWith:(NSString*)cidCarString withCarID:(NSString*)carID
{
    [ModelTool httpAppGainNewLoginWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key} success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                [self setUserMsg:object[@"data"]];
                if (KUserManager.type) {//隐藏
                    [self goBackToCarManger];
                }else{//显示
                    if ([_bodyDic[@"device"] length]) {//有设备
//                        if ([feedMsg isEqualToString:@"0"]) {//设备选择过费用
                            CWSCarBoundOKController*boundOKVC = [[CWSCarBoundOKController alloc]initWithNibName:@"CWSCarBoundOKController" bundle:nil];
                            _gotoChooseCost=YES;
                            [self.navigationController pushViewController:boundOKVC animated:YES];
//                        }else{//设备没有选择过费用
//                            CWSCarManagerDeviceOkController*carDeviceOk=[[CWSCarManagerDeviceOkController alloc]initWithNibName:@"CWSCarManagerDeviceOkController" bundle:nil];
//                            _gotoChooseCost=YES;
//                            carDeviceOk.carCid=cidCarString;
//                            [self.navigationController pushViewController:carDeviceOk animated:YES];
//                        }
                    }else{//没有设备
                        CWSCarMangerAddNoDeviceController*nodevice=[[CWSCarMangerAddNoDeviceController alloc]initWithNibName:@"CWSCarMangerAddNoDeviceController" bundle:nil];
                        _gotoChooseCost=YES;
                        [_bodyDic setObject:carID forKey:@"cid"];
                        [self.navigationController pushViewController:nodevice animated:YES];
                    }
                }
            }
        });
    } faile:^(NSError *err) { 
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
-(void)goBackToCarManger
{
    if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] isKindOfClass:[CWSCarManageController class]]) {//是重车辆管理跳过来的
        CWSCarManageController* carManagerVC = (CWSCarManageController* )[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
        carManagerVC.backMsg = @"回来了";
        [self.navigationController popToViewController:carManagerVC animated:YES];
    }else{//主界面跳转过来的
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 检测数据是否合格
-(void)checkMsgIsOK
{
    
}
-(void)addCarNexCheckViewChooseDate:(NSDate *)chooseDate
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"YYYY-MM-dd"; // @"yyyy-MM-dd HH:mm:ss"
    NSString *time = [fmt stringFromDate:chooseDate];
    if(identifier == 7){
        self.nextCheckText.text=time;
    }else if (identifier == 9){
        self.jiaoqiangxian.text = time;
    }else if (identifier == 10){
        self.shangyexian.text = time;
    }
}
-(void)setUserMsg:(NSDictionary*)dic
{
    NSMutableDictionary*dicMsg=[NSMutableDictionary dictionaryWithDictionary:dic];
    NSDictionary*dic1=dicMsg[@"car"];
    NSMutableDictionary*carMsgDic=[NSMutableDictionary dictionaryWithDictionary:dic1];
    [carMsgDic setObject:[Utils checkNSNullWithgetString:carMsgDic[@"isDefault"]] forKey:@"isDefault"];
    [dicMsg setObject:carMsgDic forKey:@"car"];

    UserNew* lUser = [[UserNew alloc] initWithDic:dic];
    KUserManager = lUser;
    NSUserDefaults*user=[[NSUserDefaults alloc]init];
    [user setObject:dicMsg forKey:@"user"];
    [NSUserDefaults resetStandardUserDefaults];
}
-(void)chooseCarColorWithColorTitle:(NSString *)colorString
{
    _carColorLabel.text=colorString;
    _carColorView.backgroundColor=colorDic[colorString];
}
-(void)chooseCarColorViewTouch
{
    
}
#pragma mark - 选择项的点击事件
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            //self.hibitOilText.text = @"97#汽油";
        }
            break;
        case 1:
        {
            //self.hibitOilText.text = @"93#汽油";
        }
            break;
        case 2:
        {
           // self.hibitOilText.text = @"0#柴油";
        }
            break;
        default:
            break;
    }
}

- (IBAction)selectAreaButtonClicked:(UIButton *)sender {
    //选择地区
    areaArray = @[@"京(北京)",@"沪(上海)",@"粤(广东)",@"浙(浙江)",@"津(天津)",@"渝(重庆)",@"川(四川)",@"黑(黑龙江)",@"吉(吉林)",@"辽(辽宁)",@"鲁(山东)",@"湘(湖南)",@"蒙(内蒙古)",@"冀(河北)",@"新(新疆)",@"甘(甘肃)",@"青(青海)",@"陕(陕西)",@"宁(宁夏)",@"豫(河南)",@"晋(山西)",@"皖(安徽)",@"鄂(湖北)",@"苏(江苏)",@"贵(贵州)",@"黔(贵州)",@"云(云南)",@"桂(广西)",@"藏(西藏)",@"赣(江西)",@"闽(福建)",@"琼(海南)",@"使(大使馆)",];
    
    CWSSelectCarAreaController* selectVc = [CWSSelectCarAreaController new];
    selectVc.selectWhat = @"选择地区";
    selectVc.dataArray = areaArray;
    selectVc.selectedAreaOrLetter = ^(NSString* thySelectedArea){
        self.carAreaLabel.text = thySelectedArea;
    };
    [self.navigationController pushViewController:selectVc animated:YES];
    areaArray = nil;
}

- (IBAction)selectLetterButtonClicked:(UIButton *)sender {
    
    //选择字母
    areaArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    CWSSelectCarAreaController* selectVc = [CWSSelectCarAreaController new];
    selectVc.selectWhat = @"选择字母";
    selectVc.dataArray = areaArray;
    selectVc.selectedAreaOrLetter = ^(NSString* thySelectedLetter){
        self.carLetterLabel.text = thySelectedLetter;
    };
    [self.navigationController pushViewController:selectVc animated:YES];
    areaArray = nil;
}




- (IBAction)addtionalClick:(UIButton *)sender {
    _isEditing=YES;
    CWSAboutAdditionalController*addtioanlVC=[[CWSAboutAdditionalController alloc]initWithNibName:@"CWSAboutAdditionalController" bundle:nil];
    [self.navigationController pushViewController:addtioanlVC animated:YES];
}


#pragma mark - 帮助删除
- (IBAction)helpDeleteButtonClick:(UIButton *)sender {
    [helpBackView removeFromSuperview];
    [helpPhotoView removeFromSuperview];
}

@end
