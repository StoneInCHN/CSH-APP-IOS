//
//  CWSServiceUIView.m
//  carLife
//
//  Created by 王泰莅 on 15/12/2.
//  Copyright © 2015年 王泰莅. All rights reserved.
//

#import "CWSServiceUIView.h"
#import "CWSMainViewController.h"


//#import "CWSCarWashDetileController.h"
#import "CWSCarWashViewController.h"
#import "CWSOrderCarWashController.h"
#import "CWSTyreHomeController.h"
//#import "CWSRepairController.h"
#import "CWSCarMaintainViewController.h"
#import "CWSFindParkingSpaceController.h"
#import "CWSFindGasStationController.h"
#import "CWSCarTrendsController.h"
#import "CWSIllegalQueryController.h"
#import "CWSBuyCarInsuranceViewController.h"
#import "CWSCarBeautyViewController.h"
#import "CWSCarMessageViewController.h"

#import "CWSDetectionOneForAllViewController.h"
#import "CWSIllegalCheckViewController.h"
#import "CWSCarReportViewController.h"
#import "CWSAddCarController.h"

#import "CWSPayViewController.h"

#define BUTTON_NUM 4
#define TOTAL_BUTTON_NUM 12
@implementation CWSServiceUIView{
    
    NSArray* buttonImages;
    
    NSArray* buttonTitles;
    NSMutableArray *_dataArray;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
        view.alpha = 0.6;
        view.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:view];
        
        buttonImages = @[@"xian",@"xiche",@"jinjijiuyuan",@"baoyang",@"weizhang",@"carlife",@"carlife",@"meirong",@"dongtai",@"jiance",@"jiayouzhan_new",@"chewei"];
        buttonTitles = @[@"买车险",@"洗车",@"紧急救援",@"保养",@"违章查询",@"carlife",@"carlife",@"美容",@"车辆动态",@"一键检测",@"找加油站",@"找车位"];
        CGFloat eachButtonWidth = kSizeOfScreen.width / BUTTON_NUM;
        CGFloat eachButtonHeight = eachButtonWidth + 5;
        int totalRow = (int)((float)TOTAL_BUTTON_NUM/BUTTON_NUM+0.9);
        for(int i=0; i<totalRow; i++){
            for(int j=0; j<BUTTON_NUM; j++){
                if(i*BUTTON_NUM+j<TOTAL_BUTTON_NUM){
                    if(i*BUTTON_NUM+j == 5){
                        
                        UIView* centerButtonView = [[UIView alloc]initWithFrame:CGRectMake(eachButtonWidth, eachButtonHeight, 2*eachButtonWidth, eachButtonHeight)];
                        centerButtonView.alpha = 0.2f;
                        centerButtonView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                        centerButtonView.layer.borderWidth = 0.5f;
                        [self addSubview:centerButtonView];
                        
                        UIImageView* centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 25, 2*eachButtonWidth-60, eachButtonHeight-50)];
                        centerImageView.image = [UIImage imageNamed:@"logo"];
                        
                        UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
                        button.frame = CGRectMake(eachButtonWidth, eachButtonHeight, 2*eachButtonWidth, eachButtonHeight);
                        [button addTarget:self action:@selector(centerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                        [button addSubview:centerImageView];
                        [self addSubview:button];
                        j++;
                        
                    }else{
                        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake((eachButtonWidth-30)/2, 15, 30, 30)];
                        imageView.image = [UIImage imageNamed:buttonImages[i*BUTTON_NUM+j]];
                        
                        UIView* buttonView = [[UIView alloc]initWithFrame:CGRectMake(j*eachButtonWidth, i*eachButtonHeight, eachButtonWidth, eachButtonHeight)];
                        buttonView.alpha = 0.3f;
                        buttonView.layer.borderColor = [UIColor lightGrayColor].CGColor;
                        buttonView.layer.borderWidth = 0.4f;
                        [self addSubview:buttonView];
                        
                        UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
                        button.frame = CGRectMake(j*eachButtonWidth, i*eachButtonHeight, eachButtonWidth-0.5, eachButtonHeight-0.5);
                        button.titleLabel.font = [UIFont systemFontOfSize:13];
                        [button setTitle:buttonTitles[i*BUTTON_NUM+j] forState:UIControlStateNormal];
                        
                        [button setTitleColor:KBlackMainColor forState:UIControlStateNormal];
                        [button setTitleEdgeInsets:UIEdgeInsetsMake(40, 0, 0, 0)];
                        [button addTarget:self action:@selector(serviceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                        [button addSubview:imageView];
                        [self addSubview:button];
                    }
                }
            }
        }
        CGRect thyRect = self.frame;
        thyRect.size.height = eachButtonHeight * totalRow;
        self.frame = thyRect;
        
    }
    return self;
}



#pragma mark - 获取数据
-(void)getData
{
    _dataArray = [NSMutableArray array];
    [MBProgressHUD showMessag:@"正在加载..." toView:self];
    [ModelTool httpGetAppGainCarsWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key,@"page":@"1"} success:^(id object) {
        MyLog(@"%@",object);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self animated:YES];
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                _dataArray = object[@"data"][@"cars"];
                
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        });
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"获取失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}


#pragma mark -================================================服务按钮回调
-(void)serviceButtonClicked:(UIButton*)sender{
    UserInfo *userInfo = [UserInfo userDefault];
    NSString* whichService = sender.titleLabel.text;
    NSLog(@"%@",whichService);
    if([whichService isEqualToString:@"买车险"]) {
            CWSBuyCarInsuranceViewController *vc = [[CWSBuyCarInsuranceViewController alloc] init];
            [self.thyRootVc.navigationController pushViewController:vc animated:YES];
    }
    else if([whichService isEqualToString:@"洗车"]) {
            CWSCarWashViewController* lController = [[CWSCarWashViewController alloc] init];
            [self.thyRootVc.navigationController pushViewController:lController animated:YES];
    }
    else if([whichService isEqualToString:@"紧急救援"]) {
            CWSTyreHomeController* cyreVC = [[CWSTyreHomeController alloc] initWithNibName:@"CWSTyreHomeController" bundle:nil];
            cyreVC.title = @"紧急救援";
            [self.thyRootVc.navigationController pushViewController:cyreVC animated:YES];
    }
    else if([whichService isEqualToString:@"保养"]) {
            CWSCarMaintainViewController* carMaintainVc = [CWSCarMaintainViewController new];
            [self.thyRootVc.navigationController pushViewController:carMaintainVc animated:YES];
    }
    else if ([whichService isEqualToString:@"违章查询"]) {
            CWSIllegalCheckViewController *vc = [[CWSIllegalCheckViewController alloc] init];
            vc.title = @"违章查询";
            [self.thyRootVc.navigationController pushViewController:vc animated:YES];
    }
    else if ([whichService isEqualToString:@"美容"]) {
            CWSCarBeautyViewController* beautyVc = [CWSCarBeautyViewController new];
            beautyVc.title = @"汽车美容";
            [self.thyRootVc.navigationController pushViewController:beautyVc animated:YES];
    }
    else if ([whichService isEqualToString:@"车辆动态"]) {
        if ([userInfo.defaultDeviceNo isKindOfClass:[NSNull class]] ||[userInfo.defaultDeviceNo isEqualToString:@""] ) {
            [self alertShowWithMessage:@"先绑定车牌吧" ForConfirmEvent:^{
                CWSAddCarController* lController = [[CWSAddCarController alloc] init];
                lController.title = @"添加车辆";
                [self.thyRootVc.navigationController pushViewController:lController animated:YES];
            }];
        } else {
            CWSCarTrendsController*carTrend=[[CWSCarTrendsController alloc]initWithNibName:@"CWSCarTrendsController" bundle:nil];
            carTrend.title=@"车辆动态";
            [self.thyRootVc.navigationController pushViewController:carTrend animated:YES];
        }
    }
    else if ([whichService isEqualToString:@"一键检测"]) {
        if ([userInfo.defaultDeviceNo isKindOfClass:[NSNull class]] ||[userInfo.defaultDeviceNo isEqualToString:@""]) {
            [self alertShowWithMessage:@"请先绑定设备" ForConfirmEvent:^{
                [MBProgressHUD showSuccess:@"binding" toView:self];
            }];
        } else {
            CWSDetectionOneForAllViewController* carDetectionVc = [CWSDetectionOneForAllViewController new];
            carDetectionVc.title = @"一键检测";
            [self.thyRootVc.navigationController pushViewController:carDetectionVc animated:YES];
        }
    }
    else if ([whichService isEqualToString:@"找加油站"]) {
        CWSFindGasStationController* lController = [[CWSFindGasStationController alloc] initWithNibName:@"CWSFindCarLocationController" bundle:nil];
        lController.type = @"加油站";
        lController.findMapViewType = 3;
        
        [self.thyRootVc.navigationController pushViewController:lController animated:YES];
    }
    else if ([whichService isEqualToString:@"找车位"]) {
        CWSFindParkingSpaceController* lController = [[CWSFindParkingSpaceController alloc] init];
        [self.thyRootVc.navigationController pushViewController:lController animated:YES]; 
    }

}
- (void)alertShowWithMessage:(NSString *)message
             ForConfirmEvent:(void (^)())onEvent {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *bindBtn = [UIAlertAction actionWithTitle:@"前往绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        onEvent();
    }];
    UIAlertAction *cancleBtn = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:bindBtn];
    [alert addAction:cancleBtn];
    [self.thyRootVc presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 中间按钮点击事件
-(void)centerButtonClicked:(UIButton*)sender{
    NSLog(@"centerButton");
}

@end
