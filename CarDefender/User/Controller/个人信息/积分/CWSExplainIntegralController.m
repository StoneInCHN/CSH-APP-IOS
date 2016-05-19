//
//  CWSExplainIntegralController.m
//  CarDefender
//
//  Created by 周子涵 on 15/6/2.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSExplainIntegralController.h"

@interface CWSExplainIntegralController ()
@property (strong, nonatomic) IBOutlet UIView *huafeiView;
@property (strong, nonatomic) IBOutlet UIView *fanfeiView;
@property (strong, nonatomic) IBOutlet UIView *jifenView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;



@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end

@implementation CWSExplainIntegralController

- (void)viewDidLoad {
    [Utils changeBackBarButtonStyle:self];
    [super viewDidLoad];
    if ([self.type isEqualToString:@"fanfei"]) {
        MyLog(@"返费说明");
        [self creatUI:self.fanfeiView];
    }else if ([self.type isEqualToString:@"huafei"]){
        MyLog(@"话费说明");
        [self creatUI:self.huafeiView];
    }else if ([self.type isEqualToString:@"jifen"]){
        MyLog(@"积分说明");
        [self creatUI:self.jifenView];
        self.imageView.hidden = self.isHidden;
        self.titleLabel.hidden = self.isHidden;
        self.contentLabel.hidden = self.isHidden;
    }
}
-(void)creatUI:(UIView*)view{
    [view setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [self.scrollerView addSubview:view];
    [self.scrollerView setContentSize:CGSizeMake(0, view.frame.size.height)];
}
-(void)viewWillDisappear:(BOOL)animated
{
    if ([self.managerConmeHere isEqualToString:@"managerCome"]) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    [ModelTool stopAllOperation];
}
@end
