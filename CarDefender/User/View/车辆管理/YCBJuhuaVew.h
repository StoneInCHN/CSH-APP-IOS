//
//  YCBJuhuaVew.h
//  刷新Demo
//
//  Created by wicresoft on 14-10-27.
//  Copyright (c) 2014年 wicresoft. All rights reserved.
//
@protocol YCBJuhuaVewDelegate <NSObject>

-(void)shuaxinEvent;

@end
#import <UIKit/UIKit.h>

@interface YCBJuhuaVew : UIView
{
    UIActivityIndicatorView*_juhua; //创建菊花
    UIButton*_refreshBtn;  //重新加载按钮
}
//@property (strong,nonatomic)UIActivityIndicatorView*juhua; //创建菊花
//@property (strong,nonatomic)UIButton*refreshBtn;  //重新加载按钮
@property(strong,nonatomic)UILabel*faildLabel;
@property(assign,nonatomic)id<YCBJuhuaVewDelegate>delegate;
-(void)buildRefreshBtn;
-(void)removeKongjian;
-(void)loadFailed;
@end
