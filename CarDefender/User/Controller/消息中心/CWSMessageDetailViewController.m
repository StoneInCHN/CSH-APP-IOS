//
//  CWSMessageDetailViewController.m
//  CarDefender
//
//  Created by 李散 on 15/6/3.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSMessageDetailViewController.h"
#define kDistanceH 64
@interface CWSMessageDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation CWSMessageDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    NSLog(@"data :%@",self.detailDic);
    [self stepUI];
}
- (void)stepUI {
    self.dateLabel.text = [Helper convertDateViaTimeStamp:[(NSString *)self.detailDic[@"createDate"] doubleValue]];
    self.detailLabel.text = self.detailDic[@"messageContent"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
