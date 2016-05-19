//
//  CWSActivityDetailViewController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/17.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSActivityDetailViewController.h"

@interface CWSActivityDetailViewController ()

@end

@implementation CWSActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动专区详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = kCOLOR(245, 245, 245);
    [Utils changeBackBarButtonStyle:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
