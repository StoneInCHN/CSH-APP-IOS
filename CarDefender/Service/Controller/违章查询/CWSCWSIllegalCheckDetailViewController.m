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
- (instancetype)initWithDic:(NSDictionary *)dict {
    if ([super init]) {
        self.dic = dict;
        return  self;
    }
    return nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    [self updateUI];
}
- (void)updateUI {
    self.headCarImageView.image = [UIImage imageNamed:@"logo"];
    self.headCarBrandLabel.text = [Helper convertNULLToString:self.dic[@"plate"]];
    self.headCarBrandLabel.text = [PublicUtils checkNSNullWithgetString:self.dic[@"plate"]];
    if ([self.dic[@"score"] isKindOfClass:[NSNull class]]) {
        self.gradeLabel.text = @"0";
    } else {
        self.gradeLabel.text = [NSString stringWithFormat:@"%@",self.dic[@"score"]];
    }
    if ([self.dic[@"finesAmount"] isKindOfClass:[NSNull class]]) {
        self.moneyLabel.text = @"0";
    } else {
        self.moneyLabel.text = [NSString stringWithFormat:@"%@",self.dic[@"finesAmount"]];
    }
    self.illegalLabel.text = [PublicUtils checkNSNullWithgetString:self.dic[@"illegalContent"]];
    self.addressLabel.text = [PublicUtils checkNSNullWithgetString:self.dic[@"illegalAddress"]];
    self.siteLabel.text = [PublicUtils checkNSNullWithgetString:self.dic[@"processingSite"]];
    if ([self.dic[@"illegalDate"] isKindOfClass:[NSNull class]]) {
        self.timeLabel.text = @"";
    } else {
        self.timeLabel.text = [NSString stringWithFormat:@"%@",self.dic[@"illegalDate"]];
    }
}
@end
