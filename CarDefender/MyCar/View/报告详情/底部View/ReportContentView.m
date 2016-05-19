//
//  ReportContentView.m
//  报告动画
//
//  Created by 周子涵 on 15/5/19.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "ReportContentView.h"
#import "Define.h"
#import "ReportPublicBaskBtn.h"
#define kJiantou 5
#define kpercent 0.38
#define kJianMile 0.85
#define kDistanceCurrentView 10
#define kBaskBtnWH 80

@implementation ReportContentView

- (id)initWithFrame:(CGRect)frame Dictionary:(NSDictionary*)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataDic = dic;
        if (kSizeOfScreen.height<500) {
            _namalFont=14;
            _currentDistance=10;
        }else{
            _namalFont=16;
            _currentDistance=28;
        }
        [self buildDownView];
    }
    return self;
}
-(void)creatUI{
    
}
-(void)reloadData:(NSDictionary*)dic{
    _dataDic = dic;
    _titleLabel.text = dic[@"title"];
    _valueLabel.text= dic[@"value"];
    _contentLabel.attributedText = dic[@"content"];
    _markLabel.text = dic[@"mark"];
}
-(void)buildDownView
{
    CGFloat downOrigin=0;
    _titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, downOrigin+_currentDistance, self.frame.size.width, 20)];
    _titleLabel.text=_dataDic[@"title"];
    _titleLabel.textColor=KBlackMainColor;
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:_namalFont];
    [self addSubview:_titleLabel];
    
    _valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _titleLabel.frame.size.height+_titleLabel.frame.origin.y+_currentDistance/2, self.frame.size.width, 28)];
    _valueLabel.text=_dataDic[@"value"];
    _valueLabel.textColor = kMainColor;
    _valueLabel.textAlignment=NSTextAlignmentCenter;
    _valueLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:30];
    [self addSubview:_valueLabel];
    //
    
    _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, _valueLabel.frame.origin.y+_valueLabel.frame.size.height, self.frame.size.width-2*20, 50)];
    _contentLabel.textColor = kMainColor;

    
    _contentLabel.attributedText=_dataDic[@"content"];

    if ([_dataDic[@"content"] length]) {
        _contentLabel.attributedText=_dataDic[@"content"];
    }

    _contentLabel.textAlignment=NSTextAlignmentCenter;
    _contentLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:_namalFont];
    [self addSubview:_contentLabel];
    _contentLabel.numberOfLines=0;
    //
//    _markLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _contentLabel.frame.size.height+_contentLabel.frame.origin.y+_currentDistance/2, kSizeOfScreen.width, 15)];
//    _markLabel.text = _dataDic[@"mark"];
//    _markLabel.textColor = [UIColor blackColor];
//    _markLabel.textAlignment  = NSTextAlignmentCenter;
//    _markLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:_namalFont];
    _markLabel = [Utils labelWithFrame:CGRectMake(0, _contentLabel.frame.size.height+_contentLabel.frame.origin.y+_currentDistance/2, kSizeOfScreen.width, 15) withTitle:_dataDic[@"mark"] titleFontSize:kFontOfSize(_namalFont) textColor:KBlackMainColor alignment:NSTextAlignmentCenter];
    [self addSubview:_markLabel];
    //
    
    ReportPublicBaskBtn* baskBtn=[[ReportPublicBaskBtn alloc]initWithFrame:CGRectMake((kSizeOfScreen.width-kBaskBtnWH)/2, _markLabel.frame.origin.y+_markLabel.frame.size.height+_currentDistance/2, kBaskBtnWH, kBaskBtnWH)];
#warning 晒一晒按钮在没有数据时的点击问题
//    if([_dataDic[@"sharecontent"] isEqualToString:@""]){
//        baskBtn.selected = NO;
//    }else{
//        baskBtn.selected = YES;
//    }
    [baskBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [baskBtn setImage:[UIImage imageNamed:@"xiqngqing_shai"] forState:UIControlStateNormal];
    [baskBtn setImage:[UIImage imageNamed:@"shuai_icon1"] forState:UIControlStateHighlighted];
    [self addSubview:baskBtn];
}
-(void)btnClick{
    if ([_dataDic[@"sharecontent"] isEqualToString:@""]) {
        return;
    }
    NSDictionary* dic = @{@"content":_dataDic[@"sharecontent"],
                          @"url":_dataDic[@"url"],
                          @"imgUrl":_dataDic[@"imgUrl"]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shareContent" object:dic];
}
@end
