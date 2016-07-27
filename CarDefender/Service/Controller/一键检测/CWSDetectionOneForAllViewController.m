//
//  CWSDetectionOneForAllViewController.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/14.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSDetectionOneForAllViewController.h"
#import "CWSCarManageController.h"

#import "CWSDetectionHeaderView.h"
#import "CWSDetectionDistanceRecentlyView.h"

@interface CWSDetectionOneForAllViewController (){

    CWSDetectionHeaderView* detectionHeaderView;
    
    CWSDetectionDistanceRecentlyView* detectionDistanceView;
    UserInfo *userInfo;
}

@property (nonatomic,strong) NSArray* senderDataArray;
@end

@implementation CWSDetectionOneForAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"一键检测";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    self.view.backgroundColor = KGrayColor3;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"车辆列表" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClicked:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : kMainColor} forState:UIControlStateNormal];
    userInfo = [UserInfo userDefault];
    [self updateLoginCacheInfo];
}
#pragma mark -========================InitialData

- (void)saveUserInfo:(NSDictionary *)info {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    for (NSString *key in [info allKeys]) {
        if ([key isEqualToString:@"id"]) {
            continue;
        }
        [userDefaults setObject:[PublicUtils checkNSNullWithgetString:[info objectForKey:key]] forKey:key];
    }
}
- (void)updateUserInfo {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userInfo.desc = [userDefaults objectForKey:@"desc"];
    userInfo.nickName = [userDefaults objectForKey:@"nickName"];
    userInfo.signature = [userDefaults objectForKey:@"signature"];
    userInfo.userName = [userDefaults objectForKey:@"userName"];
    userInfo.photo = [userDefaults objectForKey:@"photo"];
    userInfo.defaultVehicle = [userDefaults objectForKey:@"defaultVehicle"];
    userInfo.defaultVehiclePlate = [userDefaults objectForKey:@"defaultVehiclePlate"];
    userInfo.defaultDeviceNo = [userDefaults objectForKey:@"defaultDeviceNo"];
    userInfo.defaultVehicleIcon = [userDefaults objectForKey:@"defaultVehicleIcon"];
}
- (void)updateLoginCacheInfo {
    [HttpHelper updateLoginCacheInfoWithUserId:userInfo.desc
                                         token:userInfo.token
                                       success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                           NSLog(@"update login cache :%@",responseObjcet);
                                           NSDictionary *dict = (NSDictionary *)responseObjcet;
                                           userInfo.token = dict[@"token"];
                                           userInfo.desc = dict[@"desc"];
                                           NSString *code = dict[@"code"];
                                           if ([code isEqualToString:SERVICE_SUCCESS]) {
                                               NSDictionary *data = dict[@"msg"];
                                               [self saveUserInfo:data];
                                               [self updateUserInfo];
                                               [self oneKeyDetection];
                                           } else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                           } else {
                                               [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                           }
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           NSLog(@"update login cache :%@",error);
                                           [MBProgressHUD showError:@"请求失败，请重试" toView:self.view];
                                       }];
}
- (void)oneKeyDetection {
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    NSString *searchDate = [Helper yesterdayDateStr];
    [HttpHelper oneKeyDetectionWithUserId:userInfo.desc
                                    token:userInfo.token
                                 deviceNo:userInfo.defaultDeviceNo
                               searchDate:searchDate
                                  success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                      NSLog(@"one key detection :%@",responseObjcet);
                                      
                                      NSDictionary *dict = (NSDictionary *)responseObjcet;
                                      userInfo.token = dict[@"token"];
                                      NSString *code = dict[@"code"];
                                      if ([code isEqualToString:SERVICE_SUCCESS]) {
                                          if ([dict[@"msg"] isKindOfClass:[NSNull class]]) {
                                              return ;
                                          }
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              NSDictionary *data = dict[@"msg"];
                                              detectionHeaderView = [[CWSDetectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 206) Data:nil];
                                              detectionHeaderView.thyRootVc = self;
                                              detectionHeaderView.senderDataArray = self.senderDataArray;
                                              detectionHeaderView.backgroundColor = [UIColor whiteColor];
                                              detectionHeaderView.carSimpleInfoLabel.text = [NSString stringWithFormat:@"总里程%@km",data[@"totalMileAge"]];
                                              [self.view addSubview:detectionHeaderView];
                                              
                                              detectionDistanceView = [[CWSDetectionDistanceRecentlyView alloc] initWithFrame:CGRectMake(0, detectionHeaderView.endY, kSizeOfScreen.width, 251) controller:self data:data];
                                              [self.view addSubview:detectionDistanceView];
                                          });
                                      } else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                      } else {
                                          [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                      }
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"one key error :%@",error);
                                      [MBProgressHUD showError:@"请求失败，请重试" toView:self.view];
                                  }];
}
#pragma mark -========================OtherCallBack
-(void)rightBarButtonClicked:(UIBarButtonItem*)sender{
    CWSCarManageController* carManagerVc = [CWSCarManageController new];
    [self.navigationController pushViewController:carManagerVc animated:YES];
}
@end
