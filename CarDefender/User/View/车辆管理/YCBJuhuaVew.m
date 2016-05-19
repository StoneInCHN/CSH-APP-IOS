//
//  YCBJuhuaVew.m
//  刷新Demo
//
//  Created by wicresoft on 14-10-27.
//  Copyright (c) 2014年 wicresoft. All rights reserved.
//

#import "YCBJuhuaVew.h"

@implementation YCBJuhuaVew

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        [self buildJuhua];
    }
    return self;
}
#pragma mark - 创建菊花
-(void)buildJuhua
{
    _juhua = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];//指定进度轮的大小
    
    [_juhua setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height*0.4)];//指定进度轮中心点
    
    [_juhua setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
    [self addSubview:_juhua];
    
    [_juhua startAnimating];
}
#pragma mark - 超时创建的刷新按钮
-(void)buildRefreshBtn
{
    [_juhua stopAnimating];
    
    _refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 60)];//指定进度轮的大小
    
    [_refreshBtn setCenter:CGPointMake(self.frame.size.width/2, 110)];//指定进度轮中心点
    
    [_refreshBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    [_refreshBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [_refreshBtn addTarget:self action:@selector(refreshBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_refreshBtn];
    
    [self loadFailed];
    
}
-(void)loadFailed
{
    self.faildLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];//指定进度轮的大小
    
    [self.faildLabel setCenter:CGPointMake(self.frame.size.width/2, 80)];//指定进度轮中心点
    
    self.faildLabel.text=@"加载失败";
    
    self.faildLabel.textColor=kTextlightGrayColor;
    
    [self addSubview:self.faildLabel];

}

#pragma mark - 刷新按钮事件
-(void)refreshBtn:(UIButton*)sender
{
    [self.faildLabel removeFromSuperview];
    [_juhua startAnimating];
    [_refreshBtn removeFromSuperview];
    [self.delegate shuaxinEvent];
}
#pragma mark - 移除数据
-(void)removeKongjian
{
    [self.faildLabel removeFromSuperview];
    [_juhua stopAnimating];
    [_juhua removeFromSuperview];
    [_refreshBtn removeFromSuperview];
}
@end
