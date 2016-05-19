//
//  CWSTyreDetailController.m
//  CarDefender
//
//  Created by 李散 on 15/4/24.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSTyreDetailController.h"
#import "UIImageView+WebCache.h"
#define kDistance 10
#define kZIheight 16.3
#define kTitleHeight 21
#define kTitleToDes  5

#define kTextColor kCOLOR(104, 104, 104)
#define kLineColor kCOLOR(223, 223, 223)
@interface CWSTyreDetailController ()
{
    NSDictionary*currentDic;
    CLLocationCoordinate2D _newpoint;
}
@end

@implementation CWSTyreDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils setViewRiders:self.imageBaseView riders:30];
    [Utils changeBackBarButtonStyle:self];
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    [ModelTool httpAppGainServiceDetailWithParameter:@{@"id":self.repairDic[@"id"]} success:^(id object) {
        MyLog(@"%@",object);
        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self performSelector:@selector(dateLate) withObject:nil afterDelay:0.5];
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                [self setMsgWithDicSelfDraw:object[@"data"]];
                currentDic=object[@"data"];
            }else{
                [[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
            }
        });
        
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [ModelTool stopAllOperation];
}

-(void)setMsgWithDicSelfDraw:(NSDictionary*)dic
{
    self.companyName.text=dic[@"title"];
    //店铺简介
    UILabel*shopIntroduceLabel = [Utils labelWithOrigin:CGPointMake(kDistance, 173) withHeight:kTitleHeight withTitle:@"店面介绍" titleFontSize:kFontOfLetterBig textColor:kTextBlackColor backgroundColor:kTextClearColor alignment:NSTextAlignmentLeft hidden:NO];
    [self.scrollView addSubview:shopIntroduceLabel];
    NSString*des=dic[@"des"];
    if (!des.length) {
        des=dic[@"title"];
    }
    CGSize dessize=[Utils takeTheSizeOfString:des withFont:kFontOfLetterMedium withWeight:self.view.frame.size.width-2*kDistance];
//    UILabel*introduceLabelMsg = [Utils labelWithFrame:CGRectMake(kDistance, shopIntroduceLabel.frame.size.height+shopIntroduceLabel.frame.origin.y+kTitleToDes, self.view.frame.size.width-2*kDistance, dessize.height) withTitle:des titleFontSize:kFontOfLetterMedium textColor:kTextColor backgroundColor:kTextClearColor alignment:NSTextAlignmentLeft hidden:NO];
    UILabel*introduceLabelMsg = [Utils labelWithFrame:CGRectMake(kDistance, shopIntroduceLabel.frame.size.height+shopIntroduceLabel.frame.origin.y+kTitleToDes, self.view.frame.size.width-2*kDistance, dessize.height) withTitle:des titleFontSize:kFontOfLetterMedium textColor:kTextColor alignment:NSTextAlignmentLeft];
    introduceLabelMsg.numberOfLines=0;
    [self.scrollView addSubview:introduceLabelMsg];
    UIView*line1=[[UIView alloc]initWithFrame:CGRectMake(kDistance, introduceLabelMsg.frame.size.height+introduceLabelMsg.frame.origin.y+kTitleToDes, self.view.frame.size.width-2*kDistance, 1)];
    line1.backgroundColor=kLineColor;
    [self.scrollView addSubview:line1];
    
    //经营范围
    UILabel*serviceRangeTitle=[Utils labelWithOrigin:CGPointMake(kDistance, line1.frame.size.height+line1.frame.origin.y+kTitleToDes) withHeight:kTitleHeight withTitle:@"服务范围" titleFontSize:kFontOfLetterBig textColor:kTextBlackColor backgroundColor:kTextClearColor alignment:NSTextAlignmentLeft hidden:NO];
    [self.scrollView addSubview:serviceRangeTitle];
    NSString*tagString=dic[@"tag"];
    if (!tagString.length) {
        tagString=@"暂无";
    }
    CGSize rangeSize = [Utils takeTheSizeOfString:tagString withFont:kFontOfLetterMedium withWeight:self.view.frame.size.width-2*kDistance];
//    UILabel*serviceRangeLabel=[Utils labelWithFrame:CGRectMake(kDistance, serviceRangeTitle.frame.size.height+serviceRangeTitle.frame.origin.y+kTitleToDes, self.view.frame.size.width-2*kDistance, rangeSize.height) withTitle:tagString titleFontSize:kFontOfLetterMedium textColor:kTextColor backgroundColor:kTextClearColor alignment:NSTextAlignmentLeft hidden:NO];
    UILabel*serviceRangeLabel = [Utils labelWithFrame:CGRectMake(kDistance, serviceRangeTitle.frame.size.height+serviceRangeTitle.frame.origin.y+kTitleToDes, self.view.frame.size.width-2*kDistance, rangeSize.height) withTitle:tagString titleFontSize:kFontOfLetterMedium textColor:kTextColor alignment:NSTextAlignmentLeft];
    serviceRangeLabel.numberOfLines=0;
    [self.scrollView addSubview:serviceRangeLabel];
    UIView*line2=[[UIView alloc]initWithFrame:CGRectMake(kDistance, serviceRangeLabel.frame.size.height+serviceRangeLabel.frame.origin.y+kTitleToDes, self.view.frame.size.width-2*kDistance, 1)];
    line2.backgroundColor=kLineColor;
    [self.scrollView addSubview:line2];
    
    //店铺地址
    UIButton*addBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, line2.frame.size.height+line2.frame.origin.y, kSizeOfScreen.width, kDistance)];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"btnHight_whiteBack"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(searchAddrClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:addBtn];
    UILabel*shopAddrTitle=[Utils labelWithOrigin:CGPointMake(kDistance, line2.frame.size.height+line2.frame.origin.y+kTitleToDes) withHeight:kTitleHeight withTitle:@"店铺地址" titleFontSize:kFontOfLetterBig textColor:kTextBlackColor backgroundColor:kTextClearColor alignment:NSTextAlignmentLeft hidden:NO];
    [self.scrollView addSubview:shopAddrTitle];
    
    UIImageView*addImage=[[UIImageView alloc]initWithFrame:CGRectMake(kDistance, shopAddrTitle.frame.size.height+shopAddrTitle.frame.origin.y+kTitleToDes, 11, 16)];
    addImage.image=[UIImage imageNamed:@"weixiu_location@2x"];
    [self.scrollView addSubview:addImage];
    NSString*addrString=dic[@"addr"];
    if (!addrString.length) {
        addrString=@"暂无";
    }
    CGSize addSize=[Utils takeTheSizeOfString:addrString withFont:kFontOfLetterMedium withWeight:self.view.frame.size.width-3*kDistance-addImage.frame.size.width];
//    UILabel*shopAddLabel=[Utils labelWithFrame:CGRectMake(kDistance*2+addImage.frame.size.width, shopAddrTitle.frame.size.height+shopAddrTitle.frame.origin.y+kTitleToDes, self.view.frame.size.width-3*kDistance-addImage.frame.size.width, addSize.height) withTitle:addrString titleFontSize:kFontOfLetterMedium textColor:kTextColor backgroundColor:kTextClearColor alignment:NSTextAlignmentLeft hidden:NO];
    UILabel*shopAddLabel = [Utils labelWithFrame:CGRectMake(kDistance*2+addImage.frame.size.width, shopAddrTitle.frame.size.height+shopAddrTitle.frame.origin.y+kTitleToDes, self.view.frame.size.width-3*kDistance-addImage.frame.size.width, addSize.height) withTitle:addrString titleFontSize:kFontOfLetterMedium textColor:kTextColor alignment:NSTextAlignmentLeft];
    shopAddLabel.numberOfLines=0;
    [self.scrollView addSubview:shopAddLabel];
    UIView*line3=[[UIView alloc]initWithFrame:CGRectMake(kDistance, shopAddLabel.frame.size.height+shopAddLabel.frame.origin.y+kTitleToDes, self.view.frame.size.width-2*kDistance, 1)];
    line3.backgroundColor=kLineColor;
    [self.scrollView addSubview:line3];
    CGRect addrBtnFrame=addBtn.frame;
    addrBtnFrame.size.height=line3.frame.origin.y-shopAddrTitle.frame.origin.y;
    addBtn.frame=addrBtnFrame;
    
    //联系电话
    UIButton*telBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, line3.frame.size.height+line3.frame.origin.y, kSizeOfScreen.width, kDistance)];
    [telBtn setBackgroundImage:[UIImage imageNamed:@"btnHight_whiteBack"] forState:UIControlStateHighlighted];
    [telBtn addTarget:self action:@selector(makePhoneCallClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:telBtn];
    
    UILabel*shopTelTitle=[Utils labelWithOrigin:CGPointMake(kDistance, line3.frame.size.height+line3.frame.origin.y+kTitleToDes) withHeight:kTitleHeight withTitle:@"联系电话" titleFontSize:kFontOfLetterBig textColor:kTextBlackColor backgroundColor:kTextClearColor alignment:NSTextAlignmentLeft hidden:NO];
    [self.scrollView addSubview:shopTelTitle];
    UIImageView*telImage=[[UIImageView alloc]initWithFrame:CGRectMake(kDistance, shopTelTitle.frame.size.height+shopTelTitle.frame.origin.y+kTitleToDes, 11, 16)];
    telImage.image=[UIImage imageNamed:@"weixiu_phone@2x"];
    [self.scrollView addSubview:telImage];
    NSString*telString=dic[@"tel"];
    if (!telString.length) {
        telString=@"暂无";
    }
    CGSize telSize=[Utils takeTheSizeOfString:telString withFont:kFontOfLetterMedium withWeight:self.view.frame.size.width-3*kDistance-telImage.frame.size.width];
//    UILabel*shopTelLabel=[Utils labelWithFrame:CGRectMake(kDistance*2+telImage.frame.size.width, shopTelTitle.frame.size.height+shopTelTitle.frame.origin.y+kTitleToDes, self.view.frame.size.width-3*kDistance-telImage.frame.size.width, telSize.height) withTitle:telString titleFontSize:kFontOfLetterMedium textColor:kTextColor backgroundColor:kTextClearColor alignment:NSTextAlignmentLeft hidden:NO];
    UILabel*shopTelLabel=[Utils labelWithFrame:CGRectMake(kDistance*2+telImage.frame.size.width, shopTelTitle.frame.size.height+shopTelTitle.frame.origin.y+kTitleToDes, self.view.frame.size.width-3*kDistance-telImage.frame.size.width, telSize.height) withTitle:telString titleFontSize:kFontOfLetterMedium textColor:kTextColor alignment:NSTextAlignmentLeft];
    shopTelLabel.numberOfLines=0;
    [self.scrollView addSubview:shopTelLabel];
    UIView*line4=[[UIView alloc]initWithFrame:CGRectMake(kDistance, shopTelLabel.frame.size.height+shopTelLabel.frame.origin.y+kTitleToDes, self.view.frame.size.width-2*kDistance, 1)];
    line4.backgroundColor=kLineColor;
    [self.scrollView addSubview:line4];
    CGRect telBtnFrame=telBtn.frame;
    telBtnFrame.size.height=line4.frame.origin.y-shopTelTitle.frame.origin.y;
    telBtn.frame=telBtnFrame;
    
    
    self.scrollView.contentSize=CGSizeMake(0, line4.frame.size.height+line4.frame.origin.y);
    [self.headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://115.28.161.11:8080/XAI/appDownLoad/downLoadPhoto?path=%@",dic[@"photo"]]] placeholderImage:[UIImage imageNamed:@"fuwu_moren_img_detail.png"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
   }
-(void)searchAddrClick:(UIButton*)sender
{
    MyLog(@"地址");
    NSString*latString=currentDic[@"lat"];
    NSString*lngString=currentDic[@"lng"];
    _newpoint = CLLocationCoordinate2DMake([latString floatValue], [lngString floatValue]);
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否导航" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1000;
    [alertView show];
}
-(void)makePhoneCallClick:(UIButton*)sender
{
    if ([currentDic[@"tel"] length]>5) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",currentDic[@"tel"]]]];
    }else{
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"商家有点懒，没有提供联系方式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1&&alertView.tag==1000) {
        [self startNavi:KManager.currentPt newpoint:_newpoint];
    }
}
#pragma mark - 导航
- (void)startNavi:(CLLocationCoordinate2D)oldPoint newpoint:(CLLocationCoordinate2D)newpoint
{
    NSMutableArray *nodesArray = [[NSMutableArray alloc]initWithCapacity:2];
    //起点 传入的是原始的经纬度坐标，若使用的是百度地图坐标，可以使用BNTools类进行坐标转化
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    startNode.pos.x = oldPoint.longitude;
    startNode.pos.y = oldPoint.latitude;
    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:startNode];
    
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    endNode.pos.x = newpoint.longitude;
    endNode.pos.y = newpoint.latitude;
    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:endNode];
    
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Highway naviNodes:nodesArray time:nil delegete:self userInfo:nil];
}

#pragma mark - BNNaviRoutePlanDelegate
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    //路径规划成功，开始导航
    [BNCoreServices_UI showNaviUI:_naviType delegete:self isNeedLandscape:YES];
}

//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary *)userInfo
{
    NSLog(@"算路失败");
    if ([error code] == BNRoutePlanError_LocationFailed) {
        NSLog(@"获取地理位置失败");
    }
    else if ([error code] == BNRoutePlanError_LocationServiceClosed)
    {
        NSLog(@"定位服务未开启");
    }
}

//算路取消回调
-(void)routePlanDidUserCanceled:(NSDictionary*)userInfo {
    NSLog(@"算路取消");
}

#pragma mark - BNNaviUIManagerDelegate

//退出导航回调
-(void)onExitNaviUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出导航");
}

//退出导航声明页面回调
- (void)onExitDeclarationUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出导航声明页面");
}

-(void)onExitDigitDogUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出电子狗页面");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMask)UIInterfaceOrientationMaskPortrait;
}
@end
