//
//  CallSessionViewController.h
//  ChatDemo-UI2.0
//
//  Created by dhcdht on 14-10-29.
//  Copyright (c) 2014年 dhcdht. All rights reserved.
//  拨打电话

#import <UIKit/UIKit.h>

typedef enum{
    CallNone = 0,//没状态-既无呼入也无呼出
    CallOut,//呼出
    CallIn,//呼入
}CallType;

@interface CallSessionViewController : UIViewController

- (instancetype)initCallOutWithSession:(EMCallSession *)callSession;//呼出事件
- (instancetype)initCallInWithSession:(EMCallSession *)callSession;//呼入事件

@end
