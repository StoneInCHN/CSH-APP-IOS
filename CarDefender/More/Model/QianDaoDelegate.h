//
//  QianDaoDelegate.h
//  云车宝项目
//
//  Created by sky on 14-8-20.
//  Copyright (c) 2014年 HCYunAPP. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QianDaoDelegate <NSObject>
@optional
-(void)btnClick:(BOOL)qianDaoClick andBtn:(UIButton*)sender;
@end
