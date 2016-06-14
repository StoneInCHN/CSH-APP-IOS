
//
//  CWSMainViewController.m
//  carLife
//
//  Created by 王泰莅 on 15/12/2.
//  Copyright © 2015年 王泰莅. All rights reserved.
//

#import "CWSMainViewController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "CWSServiceUIView.h"
#import "CWSAdView.h"
#import "CWSClassicView.h"
#import "CWSPurchaseRecommendView.h"


#import "AppDelegate.h"
#import "CWSLeftController.h"
#import "CWSUserInformationController.h"
#import "CWSCarManageController.h"
#import "CWSMyMonyController.h"
#import "CWSFeedbackController.h"
#import "CWSUserMessageCenterViewController.h"
#import "CWSSettingController.h"
#import "CWSUserPersonalSignatureController.h"
#import "CWSMyWalletViewController.h"
#import "CWSMyOrderViewController.h"
#import "CWSOrderHistoryController.h"
#import "CWSQRScanViewController.h"
#import "CWSAdInfoViewController.h"

#import "MyJPushService.h"
#import "UIImageView+WebCache.h"

@interface CWSMainViewController ()<BMKLocationServiceDelegate,UINavigationControllerDelegate,IChatManagerDelegate,ICallManagerDelegate,BMKGeoCodeSearchDelegate,UIAlertViewDelegate,UIAlertViewDelegate,CWSAdViewDelegate>{
    
    NSMutableArray *_messageList;
    NSArray*   _cityArray;
    NSString* _cityString;
    int _type;
    CGFloat totalHeight;
    BOOL _navIsHidden; //判断导航条是否隐藏
    BOOL _isGeoSearch;

    BMKGeoCodeSearch*        _geocodesearch;
    BMKLocationService*      _locService;
    BMKReverseGeoCodeOption* _reverseGeocodeSearchOption;
    
    CWSAdView *AdScrollView; //广告滚动视图
    CWSPurchaseRecommendView* purchaseRecomView; //商店信息
    BOOL isLoad;
    UserInfo *userInfo;
    
}

@end

@implementation CWSMainViewController
#pragma mark UIViewController生命周期
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _navIsHidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
    [self getLocationCity];
    //存储当前界面标记
    NSUserDefaults* markController = [[NSUserDefaults alloc]init];
    [markController setObject:@"CWSMainViewController" forKey:@"currentController"];
    [NSUserDefaults resetStandardUserDefaults];
    //设置超时信息重新登陆通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnToLoginVC) name:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_navIsHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    NSUserDefaults*user=[[NSUserDefaults alloc]init];
    [user setObject:@"" forKey:@"currentController"];
    [NSUserDefaults resetStandardUserDefaults];
    [ModelTool stopAllOperation];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([LHPShaheObject checkPathIsOk:kAppToActionNotification]) {
        NSDictionary*dic=[NSDictionary dictionaryWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:kAppToActionNotification]];
        if (dic.count) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kAppToActionNotification object:nil];
            [LHPShaheObject saveAccountMsgWithName:kAppToActionNotification andWithMsg:@{}];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    //左边返回键设置
    self.navigationItem.backBarButtonItem = ({
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
        item.tintColor = [UIColor lightGrayColor];
        item;
    });
    self.automaticallyAdjustsScrollViewInsets = NO;
    userInfo = [UserInfo userDefault];
    NSLog(@"user info icon :%@",userInfo.defaultVehicleIcon);
    NSLog(@"user 经纬度 :%@, %@", userInfo.longitude, userInfo.latitude);
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    [self getLocation];
    [self getLocationCity];
    [self stepUI];
    [self initialIndexScrollView];
    [self refreshUserIcon];
    [self updateIndexPageData];
    [self buildNoti];
    [self initJpush];
    
}
#pragma mark 初始化UI和数据
- (void)stepUI {
    /**创建TitleUI*/
    UIView* titleUIView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 110)];
    totalHeight = titleUIView.frame.size.height;
    titleUIView.backgroundColor = [UIColor clearColor];
    NSArray* titleUIButton = @[@"扫一扫",@"我的钱包",@"我的订单"];
    NSArray* titleUIImages = @[@"saoyisao",@"purse",@"order"];
    CGFloat trimWidth = (kSizeOfScreen.width - 40 * titleUIButton.count) / (titleUIButton.count + 1);
    CGFloat trimLabelWidth = (kSizeOfScreen.width - 65 * titleUIButton.count) / (titleUIButton.count + 1);
    for(int i=0; i<titleUIButton.count; i++){
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(trimWidth-10 + (i*(trimWidth+40+10)), 20, 40, 40)];
        //  button.autoresizesSubviews = NO;
        imageView.image = [[UIImage imageNamed:titleUIImages[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [titleUIView addSubview:imageView];
        
        UILabel* titleUILabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 65, 22)];
        //  titleUILabel.backgroundColor = [UIColor orangeColor];
        CGPoint centerImageView = titleUILabel.center;
        centerImageView.x = imageView.center.x;
        centerImageView.y = CGRectGetMaxY(imageView.frame)+25;
        titleUILabel.center = centerImageView;
        
        titleUILabel.font = [UIFont systemFontOfSize:15];
        titleUILabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        titleUILabel.text = titleUIButton[i];
        titleUILabel.textAlignment = NSTextAlignmentCenter;
        [titleUIView addSubview:titleUILabel];
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(trimLabelWidth + (i*(trimLabelWidth+65)), 0, 100, 100);
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:titleUIButton[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        button.tag = 100+i;
        [button addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [titleUIView addSubview:button];
    }
    [self.myIndexScrollView addSubview:titleUIView];
    
    /**创建ServiceUI*/
    CWSServiceUIView* serviceUIView = [[CWSServiceUIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleUIView.frame), kSizeOfScreen.width, 50)];
    serviceUIView.backgroundColor = [UIColor clearColor];
    serviceUIView.thyRootVc = self;
    [self.myIndexScrollView addSubview:serviceUIView];
    totalHeight += serviceUIView.frame.size.height;
    
    /**创建留白View*/
    UIView* trimView1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(serviceUIView.frame), kSizeOfScreen.width, 15)];
    trimView1.backgroundColor = [UIColor grayColor];
    trimView1.alpha = 0.1f;
    [self.myIndexScrollView addSubview:trimView1];
    totalHeight += trimView1.frame.size.height;
    
    /**创建广告滚动*/
    AdScrollView = [[CWSAdView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(trimView1.frame), kSizeOfScreen.width, 90)];
    AdScrollView.backgroundColor = [UIColor clearColor];
    [self.myIndexScrollView addSubview:AdScrollView];
    totalHeight += AdScrollView.frame.size.height;
    
    /**创建活动专区*/
    CWSClassicView* classicView = [[CWSClassicView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(AdScrollView.frame), kSizeOfScreen.width, 100)];
    classicView.backgroundColor = [UIColor clearColor];
    classicView.thyRootVc = self;
    [self.myIndexScrollView addSubview:classicView];
    totalHeight += classicView.frame.size.height;
    
    /**创建留白View*/
    UIView* trimView2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(AdScrollView.frame), kSizeOfScreen.width, 15)];
    trimView2.backgroundColor = [UIColor grayColor];
    trimView2.alpha = 0.1f;
    [self.myIndexScrollView addSubview:trimView2];
    totalHeight += trimView2.frame.size.height;
    
    /**创建商店信息*/
    purchaseRecomView = [[CWSPurchaseRecommendView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(trimView2.frame), kSizeOfScreen.width, 0)];
    purchaseRecomView.rootVc = self;
    [self.myIndexScrollView addSubview:purchaseRecomView];
    self.myIndexScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updateIndexPageData)];
    self.badgeValueLabel.text = @"";//没有网络时显示
    self.badgeImage.hidden = YES;
    totalHeight -= 100;
}

//初始化极光推送
- (void)initJpush{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *regId = [userDefaults objectForKey:@"regId"];
    [HttpHelper initJpushWithUserId:userInfo.desc
                              token:userInfo.token
                        versionCode:@"11"
                              regId:regId
                        appPlatform:@"IOS"
                            success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                NSDictionary *dict = (NSDictionary *)responseObjcet;
                                NSString *code = dict[@"code"];
                                userInfo.token = dict[@"token"];
                                if ([code isEqualToString:SERVICE_SUCCESS]) {
                                    NSLog(@"init jpush success");
                                }else{
                                    NSLog(@"init jpush failure");
                                }
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                NSLog(@"init jpush failure");
                            }];
}
//获取右上角消息列表
- (void)getMessageList {
    [HttpHelper getMessageListWithUserId:userInfo.desc
                                   token:userInfo.token
                              pageNumber:@"10"
                                pageSize:@"5"
                                 success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                     [self.myIndexScrollView.mj_header endRefreshing];
                                     NSLog(@"message :%@",responseObjcet);
                                     NSDictionary *dict = (NSDictionary *)responseObjcet;
                                     NSString *code = dict[@"code"];
                                     userInfo.token = dict[@"token"];
                                     if ([code isEqualToString:SERVICE_SUCCESS]) {
                                         NSString *badgeValue = dict[@"desc"];
                                         if ([badgeValue isEqualToString:@"0"]) {
                                             [self.badgeValueLabel removeFromSuperview];
                                         } else {
                                             self.badgeImage.hidden = NO;
                                             if ([badgeValue integerValue] >= 100) {
                                                 self.badgeValueLabel.text = @"99+";
                                             } else {
                                                 self.badgeValueLabel.text = badgeValue;
                                             }
                                         }
                                         _messageList = dict[@"msg"];
                                     } else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                     } else {
                                         [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     [MBProgressHUD showError:@"请求失败，请重试" toView:self.view];
                                 }];
}
//获取租户列表
- (void)getPurchaseData {
    [HttpHelper searchRenterListWithServiceCategoryId:@"2"
                                               userId:userInfo.desc
                                                token:userInfo.token
                                             latitude:userInfo.latitude
                                            longitude:userInfo.longitude
                                             pageSize:3
                                           pageNumber:1
                                              success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                                  [self.myIndexScrollView.mj_header endRefreshing];
                                                  NSLog(@"首页租户列表 :%@",responseObjcet);
                                                  NSDictionary *dict = (NSDictionary *)responseObjcet;
                                                  NSString *code = dict[@"code"];
                                                  userInfo.token = dict[@"token"];
                                                  if ([code isEqualToString:SERVICE_SUCCESS]) {
                                                      
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          totalHeight -= purchaseRecomView.frame.size.height ;
                                                          purchaseRecomView.storeDataArray = dict[@"msg"];
                                                          totalHeight += purchaseRecomView.frame.size.height;
                                                          [self initialIndexScrollView];
                                                      });
                                                  }else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                                  } else {
                                                      [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                                  }
                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  [MBProgressHUD showError:@"请求失败，请重试" toView:self.view];
                                              }];
}
//获取广告列表
- (void)getAdvertismentImage {
    [HttpHelper getAdvertismentImageWithUserId:userInfo.desc
                                         token:userInfo.token
                                       success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                           [self.myIndexScrollView.mj_header endRefreshing];
                                           NSLog(@"广告列表 :%@",responseObjcet);
                                           NSDictionary *dict = (NSDictionary *)responseObjcet;
                                           NSString *code = dict[@"code"];
                                           userInfo.token = dict[@"token"];
                                           if ([code isEqualToString:SERVICE_SUCCESS]) {
                                               AdScrollView.adImagesDataArray = dict[@"msg"];
                                               AdScrollView.delegate = self;
                                           } else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                           } else {
                                               [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                           }
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           [MBProgressHUD showError:@"请求失败，请重试" toView:self.view];
                                       }];
}

#pragma mark - 车定位
- (void)getLocation
{
    MyLog(@"%@----%@------%@",KUserManager.uid,KUserManager.mobile,KUserManager.userCID);
    if (KUserManager.uid != nil && KUserManager.mobile != nil && KUserManager.userCID != nil && KUserManager.userDefaultVehicle[@"device"] != nil && ![KUserManager.userDefaultVehicle[@"device"] isEqualToString:@""]) {
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setValue:KUserManager.uid forKey:@"uid"];
        [dic setValue:KUserManager.mobile forKey:@"mobile"];
        [dic setValue:KUserManager.userCID forKey:@"cid"];
        [ModelTool getLocationWithParameter:dic andSuccess:^(id object) {
//            dispatch_async(dispatch_get_main_queue(), ^{
                if ([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
                    MyLog(@"---------车辆定位信息---------%@",object);
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    KManager.currentPt = CLLocationCoordinate2DMake([object[@"data"][@"lat"] floatValue], [object[@"data"][@"lon"] floatValue]);
                    
                }
                else {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[PublicUtils showServiceReturnMessage:object[@"message"]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                    [alert show];
                    
                }
//            });
            
        } andFail:^(NSError *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"系统有错误，请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
        }];
    }
//    else {
//        [WCAlertView showAlertWithTitle:@"提示" message:@"当前定位信息不足,无法进行定位" customizationBlock:nil completionBlock:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    }
    
}

-(void)buildNoti
{
    [self setRemoteNotiEvent];
    //公共push方法
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leftEventTurnNext:) name:@"LEFT_TURN_MAINVC" object:nil];
    //右滑按钮通知事件
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rightEventTurnNext:) name:@"RIGHT_TURN_TO_MAINVC" object:nil];
   // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leftVCHidden) name:@"leftVCHidden" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoLoginVC:) name:@"goToLoginVC" object:nil];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goToAddCar:) name:@"REGIST_TO_ADD_CAR" object:nil];
//    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sideShowOrHidden:) name:@"SIDER_SHOW_OR_HIDDEN" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leftShowAppear:) name:@"leftAppearVC" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isHaveUnreadMessage) name:@"SET_UNREAD_MSG" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isHaveUnreadMessage) name:@"NOTI_UNREAD_NUB" object:nil];
}

#pragma mark --================================================================ InitialUI
/**初始化首页scrollview*/
-(void)initialIndexScrollView{
    self.myIndexScrollView.contentSize = CGSizeMake(kSizeOfScreen.width, totalHeight);
    self.myIndexScrollView.showsHorizontalScrollIndicator = NO;
    self.myIndexScrollView.showsVerticalScrollIndicator = NO;
    self.myIndexScrollView.bounces = YES;
}

#pragma mark 下拉刷新
/**更新首页信息*/
-(void)updateIndexPageData{
    [self getAdvertismentImage];
    [self getMessageList];
    [self getPurchaseData];
}

#pragma mark 首页左右按钮点击事件
- (IBAction)UserIconButtonClicked:(UIButton *)sender {
    CWSLeftController* userInfoVc = [CWSLeftController new];
    [self.navigationController pushViewController:userInfoVc animated:YES];
}

- (IBAction)onMessageCenterBtn:(id)sender {
    CWSUserMessageCenterViewController *userMessageCenterVC = [CWSUserMessageCenterViewController new];
    userMessageCenterVC.messageList = _messageList;
    [self.navigationController pushViewController:userMessageCenterVC animated:YES];
}

-(void)titleButtonClicked:(UIButton*)sender{

    MyLog(@"buttonTest");
    if (![UserInfo userDefault].desc) {//未登录
        [self turnToLoginVC];
        return;
    }
    else {
        switch (sender.tag-100) {
                //扫一扫
            case 0:{
                
                CWSQRScanViewController* qrScanVc = [CWSQRScanViewController new];
                [self.navigationController pushViewController:qrScanVc animated:YES];

            }
                break;
                //我的钱包
            case 1:{
                CWSMyWalletViewController*msgeVC=[[CWSMyWalletViewController alloc]initWithNibName:@"CWSMyWalletViewController" bundle:nil];
                
                [self.navigationController pushViewController:msgeVC animated:YES];
            }
                break;
                //我的订单
            case 2:{
                CWSOrderHistoryController* lController = [[CWSOrderHistoryController alloc] init];
                lController.title = @"我的订单";
                [self.navigationController pushViewController:lController animated:YES];
            }
                break;
            default:
                break;
        }
    }
    
}


#pragma mark --================================================================ 用户信息
-(void)refreshUserIcon{
    [self.UserIconButton setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/csh-interface%@",SERVERADDRESS,userInfo.defaultVehicleIcon]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"logo"] options:SDWebImageLowPriority | SDWebImageRetryFailed | SDWebImageProgressiveDownload];
}

-(void)isHaveUnreadMessage{
    if(KUserManager.uid != nil){
        NSString* namePath=[NSString stringWithFormat:@"kMessageCenter%@",KUserManager.uid];
        if([LHPShaheObject checkPathIsOk:namePath]){
            int countNum = [[NSString stringWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:namePath] encoding:NSUTF8StringEncoding error:nil] intValue];
            if(countNum){
                
                //该用户有未读的消息
                
            
            }else{
            
                //该用户没有未读的消息
            }
        }
    
    }else{
    
        //把消息标志隐藏掉
    }
}

#pragma mark --================================================================ 检测登录状态
-(void)checkLoginMsg{
    if (KUserManager.uid!=nil) {
        [ModelTool httpAppLoginIsValidWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key} success:^(id object) {
            MyLog(@"%@",object);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([object[@"operationState"] isEqualToString:@"RELOGIN"]) {//有人登录过
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    //移除密码
                    if ([LHPShaheObject checkPathIsOk:kAccountMsg]) {
                        NSDictionary*dic=[NSDictionary dictionaryWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:kAccountMsg]];
                        NSMutableDictionary*dic1=[NSMutableDictionary dictionaryWithDictionary:dic];
                        [dic1 setObject:@"" forKey:@"psw"];
                        [LHPShaheObject saveAccountMsgWithName:kAccountMsg andWithMsg:dic1];
                    }
                    KUserManager.uid=nil;
                    _navIsHidden = NO;
                    [self viewWillAppear:YES];
                    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的账号在其他设备上登录过，请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
                    alert.tag=123;
                    [self turnToLoginVC];
                }else {//正常登录
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }
            });
        } faile:^(NSError *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}

#pragma mark --================================================================ 地理位置相关
/**获取当前城市*/
-(void)getLocationCity{
    if (_geocodesearch == nil) {
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
        _geocodesearch.delegate = self;
        _isGeoSearch = false;
        
        _reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    }
    if (KManager.currentPt.latitude>0 && KManager.currentPt.longitude>0) {
        _reverseGeocodeSearchOption.reverseGeoPoint = (CLLocationCoordinate2D){KManager.currentPt.latitude, KManager.currentPt.longitude};
    }
//    else {
//        _reverseGeocodeSearchOption.reverseGeoPoint = (CLLocationCoordinate2D){[userInfo.latitude doubleValue],
//            [userInfo.longitude doubleValue]};
//    }
    BOOL flag = [_geocodesearch reverseGeoCode:_reverseGeocodeSearchOption];
    
    if(flag){
        MyLog(@"反geo检索发送成功");
    }else{
        MyLog(@"反geo检索发送失败");
    }
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //    [_mapView updateLocationData:userLocation];
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    KManager.mobileCurrentPt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    [self getLocationCity];
    NSString *latitudeString = [NSString stringWithFormat:@"%f",KManager.mobileCurrentPt.latitude];
    NSString *longitudeeString = [NSString stringWithFormat:@"%f",KManager.mobileCurrentPt.longitude];
    if ([latitudeString integerValue] == 0 && [longitudeeString integerValue] == 0) {
        [_locService startUserLocationService];
    }
    
    //    MyLog(@"%@",userLocation.title);
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    KManager.mobileCurrentPt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    
    userInfo.latitude = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.latitude];
    userInfo.longitude = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.longitude];
    [_locService stopUserLocationService];
    if ([userInfo.latitude integerValue] == 0 && [userInfo.longitude integerValue] == 0) {
        [_locService startUserLocationService];
    }
}
- (void)didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"did fail to locate :%@",error);
}


#pragma mark --================================================================ 通知事件回调

/**检验激光推送的Alia和Tag是否设置成功*/
-(void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias{
    //tagsAliasCallback:tags:alias:
    if(!iResCode){
        if(tags == nil){
            if(KUserManager.userTags != nil){
                [MyJPushService setupWithTag:KUserManager.userTags andCallBackSelector:@selector(tagsAliasCallback:tags:alias:) andTarget:self];
            }
        }else{
            MyLog(@"设置Alia成功!");
            MyLog(@"设置Tags成功!");
        }
    }else if(iResCode == 6002){
        if(alias == nil){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MyJPushService setupWithAlias:[SvUDIDTools UDID] andCallBackSelector:@selector(tagsAliasCallback:tags:alias:) andTarget:self];
            });
        }else if(tags == nil){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MyJPushService setupWithTag:KUserManager.userTags andCallBackSelector:@selector(tagsAliasCallback:tags:alias:) andTarget:self];
            });
        }
    }else if(iResCode == 6001){
        MyLog(@"tags为空!");
    }
}

-(void)gotoLoginVC:(NSNotification*)sender{
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    LHPSideViewController *sideViewController=[delegate sideViewController];
    [sideViewController hideSideViewController:true];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sideViewController.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _navIsHidden = NO;
        [self turnToLoginVC];
    });
}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (result.addressDetail.city == nil || [result.addressDetail.city isEqualToString:@""]) {
        return;
    }
    NSString* province;
    NSString* city;
    if ([_cityArray containsObject:result.addressDetail.province]) {
        province = result.addressDetail.city;
        city = result.addressDetail.district;
    }else{
        province = result.addressDetail.province;
        city = result.addressDetail.city;
    }
    KManager.currentCity = province;
    KManager.currentSubCity = city;
    KManager.currentStreetName = result.addressDetail.streetName;
    KManager.currentStreetNumber = result.addressDetail.streetNumber;
    if (KManager.currentCity!=nil || KManager.currentCity.length) {
        NSUserDefaults*user = [[NSUserDefaults alloc]init];
        NSString*string = [user objectForKey:@"SERVICE_CITYNAME"];
        if (string) {
            if (![string isEqualToString:KManager.currentCity]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"系统定位到您在%@，需要切换至%@吗",KManager.currentCity,KManager.currentCity] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"切换", nil];
                alert.tag = 100;
                [alert show];
                _cityString=string;
            }else{
                _cityString=KManager.currentCity;
            }
        }else{
            _cityString=KManager.currentCity;
        }
        //[self setCityBtnTitle:cityString];
    }else{
        _cityString=@"定位失败";
       // [self setCityBtnTitle:cityString];
    }
    
    [ModelTool httpGetCityWithParameter:@{@"province":[province stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"district":[city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]} success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                KManager.currentCityID = object[@"data"][@"msg"];
                
            }else{
                KManager.currentCityID = @"";
            }
        });
    } faile:^(NSError *err) {
        
    }];
    [_locService stopUserLocationService];
}

#pragma mark - 左边控制器跳转监听
-(void)leftEventTurnNext:(NSNotification*)sender
{
    //    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    //    LHPSideViewController *sideViewController=[delegate sideViewController];
    //    [sideViewController hideSideViewController:true];
    NSString*vcString=(NSString*)sender.object;
    UIViewController*vc;
    if ([vcString isEqualToString:@"CWSUserInformationController"]) {//用户中心
        CWSUserInformationController* feedVC=[[CWSUserInformationController alloc]initWithNibName:@"CWSUserInformationController" bundle:nil];
        vc=feedVC;
    }else if ([vcString isEqualToString:@"CWSCarManageController"]){//车辆管理
        CWSCarManageController*feedVC=[[CWSCarManageController alloc]initWithNibName:@"CWSCarManageController" bundle:nil];
        vc=feedVC;
    }else if ([vcString isEqualToString:@"CWSMyMonyController"]){//我的财富
        CWSMyMonyController*feedVC=[[CWSMyMonyController alloc]initWithNibName:@"CWSMyMonyController" bundle:nil];
        vc=feedVC;
    }else if ([vcString isEqualToString:@"CWSPhoneController"]){//网络电话
//        CWSPhoneController*feedVC=[[CWSPhoneController alloc]initWithNibName:@"CWSPhoneController" bundle:nil];
//        vc=feedVC;
    }else if ([vcString isEqualToString:@"CWSFeedbackController"]){//意见反馈
        CWSFeedbackController*feedVC=[[CWSFeedbackController alloc]initWithNibName:@"CWSFeedbackController" bundle:nil];
        vc=feedVC;
    }else if ([vcString isEqualToString:@"CWSUserMessageCenterViewController"]){//消息中心
        CWSUserMessageCenterViewController*msgeVC=[[CWSUserMessageCenterViewController alloc]init];
        vc=msgeVC;
    }else if ([vcString isEqualToString:@"CWSSettingController"]){//设置
        
        CWSSettingController* settingVc = [[CWSSettingController alloc]initWithNibName:@"CWSSettingController" bundle:nil];
        vc=settingVc;
        
      
        
    }else if ([vcString isEqualToString:@"CWSUserPersonalSignatureController"]){//个人签名
        CWSUserPersonalSignatureController*msgeVC=[[CWSUserPersonalSignatureController alloc]initWithNibName:@"CWSUserPersonalSignatureController" bundle:nil];
        if (KUserManager.note.length) {
            msgeVC.noteString=KUserManager.note;
        }
        vc=msgeVC;
    }else if ([vcString isEqualToString:@"CWSMyWalletViewController"]){//我的钱包
        CWSMyWalletViewController*msgeVC=[[CWSMyWalletViewController alloc]initWithNibName:@"CWSMyWalletViewController" bundle:nil];
        vc=msgeVC;
    }
    else if ([vcString isEqualToString:@"CWSOrderHistoryController"]){//我的订单
        
        CWSOrderHistoryController* lController = [[CWSOrderHistoryController alloc] init];
        lController.title = @"我的订单";
        vc=lController;
    }
    
    
    
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -=================================================================更新界面信息
-(void)updateUI{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    if([user arrayForKey:@"advertisementInfo"]){
        
         NSArray* advertiseArray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"advertisementInfo"];
        [AdScrollView setAdImagesDataArray:advertiseArray];
        
    }
    if([user arrayForKey:@"defaultStores"]){
        
        totalHeight -= purchaseRecomView.frame.size.height;
        NSArray* defaultStore = [[NSUserDefaults standardUserDefaults]arrayForKey:@"defaultStores"];
        MyLog(@"----------更新defaultStore----------%@",defaultStore);
        [purchaseRecomView setStoreDataArray:defaultStore];
        totalHeight += purchaseRecomView.frame.size.height;
        self.myIndexScrollView.contentSize = CGSizeMake(kSizeOfScreen.width, totalHeight);
    }
    
    
    if (KUserManager.userDefaultVehicle != nil) {
        //更改用户头像
        [self.UserIconButton setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"baseUrl"],KUserManager.userDefaultVehicle[@"brand"][@"brandIcon"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"logo"] options:SDWebImageLowPriority | SDWebImageRetryFailed | SDWebImageProgressiveDownload];
    }else {
        [self.UserIconButton setBackgroundImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    }
}
#pragma mark CWSAdViewDelegate
- (void)clickedAdView:(NSURL *)url {
    CWSAdInfoViewController *AdInfoVC = [[CWSAdInfoViewController alloc] init];
    AdInfoVC.url = url;
    [self.navigationController pushViewController:AdInfoVC animated:YES]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateDefaultMessage
{
    NSUserDefaults* thyUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [thyUserDefaults objectForKey:@"user"];
    KUserManager.nick_name = [dic valueForKey:@"nick_name"];
    KUserManager.signature = [dic valueForKey:@"signature"];
    KUserManager.icon = [dic valueForKey:@"icon"];
    KUserManager.userDefaultVehicle = [thyUserDefaults valueForKey:@"userDefaultVehicle"];
    NSDictionary *dic2 = [NSDictionary dictionaryWithDictionary:[thyUserDefaults valueForKey:@"userDefaultVehicle"]];
    KUserManager.userCID = dic2[@"id"];
}
@end
