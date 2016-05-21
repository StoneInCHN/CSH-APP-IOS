//
//  CWSCWSIllegalCheckDetailViewController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/9.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSCWSIllegalCheckDetailViewController.h"
#import "IllegalCheckDetailTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface CWSCWSIllegalCheckDetailViewController ()
@end

@implementation CWSCWSIllegalCheckDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
}
- (void)setDic:(NSDictionary *)dic {
    self.headCarImageView.image = [UIImage imageNamed:@"logo"];
    self.headCarBrandLabel.text = [PublicUtils checkNSNullWithgetString:dic[@"plate"]];
    if ([dic[@"score"] isKindOfClass:[NSNull class]]) {
        self.gradeLabel.text = @"0";
    } else {
        self.gradeLabel.text = dic[@"score"];
    }
    if ([dic[@"finesAmount"] isKindOfClass:[NSNull class]]) {
        self.moneyLabel.text = @"0";
    } else {
        self.moneyLabel.text = dic[@"finesAmount"];
    }
    self.illegalLabel.text = [PublicUtils checkNSNullWithgetString:dic[@"illegalContent"]];
    self.addressLabel.text = [PublicUtils checkNSNullWithgetString:dic[@"illegalAddress"]];
    self.siteLabel.text = [PublicUtils checkNSNullWithgetString:dic[@"processingSite"]];
    self.timeLabel.text = [PublicUtils checkNSNullWithgetString:dic[@"illegalDate"]];
}
@end
