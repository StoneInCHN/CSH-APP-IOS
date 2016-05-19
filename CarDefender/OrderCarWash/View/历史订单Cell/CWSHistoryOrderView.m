//
//  CWSHistoryOrderView.m
//  CarDefender
//
//  Created by 周子涵 on 15/10/12.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSHistoryOrderView.h"
#import "CWSHistoryOrder.h"
#import "UILabel+Kun.h"
#import "UIView+MJExtension.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

CGFloat CELL_SPACE = 10;
CGFloat IMAGE_SIZE = 60;

@implementation CWSHistoryOrderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    //1.logo图片
//    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CELL_SPACE, CELL_SPACE, 45, 45)];
//    [Utils setViewRiders:_imageView riders:4];
//    [self addSubview:_imageView];
    //2.标题
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, CELL_SPACE, self.mj_w - 65 - CELL_SPACE, 17) Text:@"" Font:kFontOfSize(17) Color:KBlackMainColor TextAlignment:NSTextAlignmentLeft];
    [self addSubview:_nameLabel];
    //3.订单号
    _orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 43, _nameLabel.mj_w, 12) Text:@"" Font:kFontOfSize(12) Color:[UIColor darkGrayColor] TextAlignment:NSTextAlignmentLeft];
    [self addSubview:_orderLabel];
    //4.分割线
    UIView* spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, self.mj_w, 1)];
    spaceView.backgroundColor = kCOLOR(233, 233, 233);
    [self addSubview:spaceView];
    //5.预约订单信息
    UILabel* massageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 76, self.mj_w - 2*CELL_SPACE, 17) Text:@"预约订单信息" Font:kFontOfSize(17) Color:KBlackMainColor TextAlignment:NSTextAlignmentLeft];
    [self addSubview:massageLabel];
    //6.具体信息数据
    NSArray* nameArray = @[@"车牌号:",@"预约时间:",@"失效时间:"];
    for (int i = 0; i < nameArray.count; i++) {
        UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 103 + 22*i, 57, 12) Text:nameArray[i] Font:kFontOfSize(12) Color:[UIColor darkGrayColor] TextAlignment:NSTextAlignmentLeft];
        [self addSubview:nameLabel];
        UILabel* dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, nameLabel.y, _nameLabel.mj_w, 12) Text:@"" Font:kFontOfSize(12) Color:[UIColor lightGrayColor] TextAlignment:NSTextAlignmentLeft];
        dataLabel.tag = 10+i;
        [self addSubview:dataLabel];
    }
    //订单图片
    _stateImageView= [[UIImageView alloc] initWithFrame:CGRectMake(self.mj_w - CELL_SPACE - IMAGE_SIZE, self.mj_h - 21 - IMAGE_SIZE, IMAGE_SIZE, IMAGE_SIZE)];
    [self addSubview:_stateImageView];
    
    //订单确认按钮
    self.confimButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confimButton.alpha = 0;
    self.confimButton.frame = CGRectMake(self.mj_w - CELL_SPACE - 86, self.mj_h - 10 - 38, 86, 38);
    [self.confimButton setTitle:@"订单确认" forState:UIControlStateNormal];
    [self.confimButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confimButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.confimButton.layer.cornerRadius = 5;
    [self.confimButton setBackgroundColor:[UIColor colorWithRed:60/255.0 green:152/255.0 blue:247/255.0 alpha:1]];
    
    [self addSubview:self.confimButton];
    
    //争议订单
    self.argueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.mj_w - CELL_SPACE - 66, self.mj_h - 10 - 38, 86, 38)];
    self.argueLabel.text = @"争议订单";
    self.argueLabel.font = [UIFont systemFontOfSize:15];
    self.argueLabel.textColor = [UIColor redColor];
    self.argueLabel.alpha = 0;
    [self addSubview:self.argueLabel];
}
-(void)reloadData:(CWSHistoryOrder*)historyOrder{
//    [_imageView setImageWithURL:[NSURL URLWithString:historyOrder.img] placeholderImage:[UIImage imageNamed:@"home_baoma.png"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
//    _nameLabel.text = historyOrder.name;
//    _orderLabel.text = [NSString stringWithFormat:@"订单号: %@",historyOrder.uno];
//    UILabel* carNumberLabel = (UILabel*)[self viewWithTag:10];
//    if (![historyOrder.plate isKindOfClass:[NSNull class]]) {
//        carNumberLabel.text = historyOrder.plate;
//    }
//    
//    UILabel* starTimeLabel = (UILabel*)[self viewWithTag:11];
//    starTimeLabel.text = historyOrder.date;
//    UILabel* endTimeLabel = (UILabel*)[self viewWithTag:12];
//    endTimeLabel.text = historyOrder.deal;
    
    
    //已用
    if ([historyOrder.status isEqualToString:@"2"]) {
        _stateImageView.image = [UIImage imageNamed:@"dingdan_yiyong"];

    }
    //预约中
    else if ([historyOrder.status isEqualToString:@"1"])
    {
        _stateImageView.image = [UIImage imageNamed:@"yuyuezhong"];
//        endTimeLabel.text = @"--";
    }
    //未确认订单的
    else if ([historyOrder.status isEqualToString:@"3"])
    {
        _stateImageView.alpha = 0;
        _confimButton.alpha = 1;
        
    }
    //争议订单
    else if ([historyOrder.status isEqualToString:@"4"])
    {
        _stateImageView.alpha = 0;
        _argueLabel.alpha = 1;
    }
    //过期
    else{
        _stateImageView.image = [UIImage imageNamed:@"dingdan_guoqi"];
    }
    
}



@end
