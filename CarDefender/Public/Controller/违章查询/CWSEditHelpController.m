//
//  CWSEditHelpController.m
//  CarDefender
//
//  Created by 李散 on 15/7/16.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSEditHelpController.h"

@interface CWSEditHelpController ()

@end

@implementation CWSEditHelpController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写帮助";
    [Utils changeBackBarButtonStyle:self];
    [self buildUI];
    
}

-(void)buildUI

{
    
    UIImageView*imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kSizeOfScreen.width-20, 186*(kSizeOfScreen.width-20)/298)];
    
    [self.view addSubview:imageView];
    
    imageView.image = [UIImage imageNamed:@"weizhang_bangzhu.png"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
