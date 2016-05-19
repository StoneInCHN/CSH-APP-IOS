//
//  YHAler.h
//  chlidfios
//
//  Created by ZG-YUH on 15/8/6.
//  Copyright (c) 2015年 yuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WQAler : NSObject
+(void)Show:(NSString *)messageStr;
//view为nil时  默认为window
+(void)Show:(NSString *)messageStr WithView:(UIView *)view;
@property(nonatomic,strong)UIAlertView *alerView;
@end
