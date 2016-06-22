//
//  SFCouponViewController.m
//  CarDefender
//
//  Created by sicnu_ifox on 16/6/19.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "SFCouponViewController.h"
#import "CWSActivityViewController.h"
#import "SFCarWashViewController.h"

@interface SFCouponViewController () {
    SFCarWashViewController *_carWashVC;
    CWSActivityViewController *_activityVC;
}

@end

@implementation SFCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    [self loadData];
    [self onSegmentedEvent:self.segmentedControl];
}

- (IBAction)onSegmentedEvent:(id)sender {
    [self.segmentedView removeSubviews];
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    if (segment.selectedSegmentIndex == 0) {
        if (!_activityVC) {
           _activityVC = [[CWSActivityViewController alloc] initWithNibName:@"CWSActivityViewController" bundle:nil];
            _activityVC.isOnlyShow = YES;
            [self addChildViewController:_activityVC];
        }
        [self.segmentedView addSubview:_activityVC.view];

    } else {
        if (!_carWashVC) {
            _carWashVC = [[SFCarWashViewController alloc] init];
            [self addChildViewController:_carWashVC];
        }
        [self.segmentedView addSubview:_carWashVC.view];
    }
}
- (void)loadData
{
    UserInfo  *userInfo = [UserInfo userDefault];
    [HttpHelper myWashingCouponWithUserId:userInfo.desc
                                    token:userInfo.token
                                  success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                      NSDictionary *dict = (NSDictionary *)responseObjcet;
                                      NSString *code = dict[@"code"];
                                      userInfo.token = dict[@"token"];
                                      if ([code isEqualToString:SERVICE_SUCCESS]) {
                                          NSArray *coupons = dict[@"msg"];
                                          if (coupons.count == 0) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [self.segmentedControl removeFromSuperview];
                                                  self.segmentViewTopSpace.constant = 0;
                                              }); 
                                          }
                                      } else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                      } else {
                                          [MBProgressHUD showError:dict[@"desc"] toView:self.view.window];
                                      }
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [MBProgressHUD showError:@"请求失败，请重试" toView:self.view.window];
                                  }];
    
}


@end
