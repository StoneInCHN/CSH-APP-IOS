//
//  CWSForgetSetPswSuccessController.m
//  CarDefender
//
//  Created by 李散 on 15/6/5.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSForgetSetPswSuccessController.h"

@interface CWSForgetSetPswSuccessController ()
{
    NSTimer*_timer;
    int _minite;
}
@end

@implementation CWSForgetSetPswSuccessController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils setViewRiders:self.rightLine riders:2];
    [Utils setViewRiders:self.leftLine riders:2];
    _minite=3;
    
    self.turnLabel.text = @"3秒后返回操作";
    [self changeTitleText:self.turnLabel andFirstRange:1];
//添加定时器定时3秒钟自动跳转
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.0
                                            target:self selector:@selector(timerFireMethod:)
                                          userInfo:nil repeats:YES];
    [_timer fire];
}
#pragma mark - timer事件
-(void)timerFireMethod:(NSTimer*)sender
{
    self.turnLabel.text=[NSString stringWithFormat:@"%d秒后返回操作",_minite];
    [self changeTitleText:self.turnLabel andFirstRange:1];
    if (_minite<0) {
        self.turnLabel.text=[NSString stringWithFormat:@"0秒后返回操作"];
        [self changeTitleText:self.turnLabel andFirstRange:1];
        [sender invalidate];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadPsw" object:self.phoneNubString];//替换账号
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    _minite--;
}


#pragma mark - 改变label字体颜色
-(void)changeTitleText:(UILabel *)label andFirstRange:(NSInteger )first{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1] range:NSMakeRange(0,first)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(first,label.text.length-first)];
    label.attributedText = str;
}

@end
