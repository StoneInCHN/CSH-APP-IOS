//
//  CWSDetectionHeaderView.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/14.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSDetectionHeaderView.h"
#import "CWSDetectionOneForAllViewController.h"
#import "CWSDetectionScanViewController.h"
#import "UIImageView+WebCache.h"
@implementation CWSDetectionHeaderView{
    UILabel* carNumberLabel ;  //车牌号
    UIImageView* carBrandImageView;   //车牌图片
    UIButton* securityScanButton; //安全扫描按钮
    UserInfo *userInfo;
}

- (instancetype)initWithFrame:(CGRect)frame Data:(NSDictionary *)data
{
    self = [super initWithFrame:frame];
    if (self) {
        self.checkData = [[NSDictionary alloc] initWithDictionary:data];
        userInfo = [UserInfo userDefault];
        [self createUI];
    }
    return self;
}

-(void)createUI{
    carNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake((kSizeOfScreen.width-120)/2, 40, 120, 18)];
    carNumberLabel.textAlignment = NSTextAlignmentCenter;
    carNumberLabel.font = [UIFont systemFontOfSize:17.0f];
    carNumberLabel.textColor = KBlackMainColor;
    carNumberLabel.text = userInfo.defaultVehiclePlate;
    [self addSubview:carNumberLabel];
    
    carBrandImageView = [[UIImageView alloc]initWithFrame:CGRectMake((kSizeOfScreen.width-64)/2, CGRectGetMaxY(carNumberLabel.frame)+18, 64, 24)];
    [carBrandImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/csh-interface%@",SERVERADDRESS,userInfo.defaultVehicleIcon]] placeholderImage:[UIImage imageNamed:@"logo"] options:SDWebImageLowPriority | SDWebImageRetryFailed | SDWebImageProgressiveDownload];
    [self addSubview:carBrandImageView];
    
    _carSimpleInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(carBrandImageView.frame)+18, kSizeOfScreen.width, 13)];
    _carSimpleInfoLabel.textAlignment = NSTextAlignmentCenter;
    _carSimpleInfoLabel.textColor = [UIColor grayColor];
    [self addSubview:_carSimpleInfoLabel];
    
    securityScanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    securityScanButton.frame = CGRectMake((kSizeOfScreen.width-134)/2, CGRectGetMaxY(_carSimpleInfoLabel.frame)+18, 134, 40);
    securityScanButton.layer.masksToBounds = YES;
    securityScanButton.layer.borderColor = kMainColor.CGColor;
    securityScanButton.layer.borderWidth = 1.0f;
    securityScanButton.layer.cornerRadius = 5.0f;
    [securityScanButton setTitle:@"安全扫描" forState:UIControlStateNormal];
    [securityScanButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [securityScanButton addTarget:self action:@selector(securityScanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:securityScanButton];
}
-(void)securityScanButtonClicked:(UIButton*)sender{
    MyLog(@"安全扫描");
    CWSDetectionScanViewController* scanVc = [CWSDetectionScanViewController new];
    scanVc.dataDic = [self.checkData mutableCopy];
    scanVc.obdDataArray = self.senderDataArray;
    [self.thyRootVc.navigationController pushViewController:scanVc animated:YES];
}



@end
