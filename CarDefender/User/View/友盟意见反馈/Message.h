//
//  Message.h
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    MessageTypeMe = 0, // 自己发的
    MessageTypeOther = 1 //别人发得
    
} MessageType;

@interface Message : NSObject
@property (nonatomic, copy) NSString *content;//内容
@property (nonatomic, copy) NSString *time;//时间
@property (nonatomic, copy) NSString *isFailed;//是否发送失败
//@property (nonatomic, copy) NSString *icon;//头像
@property (nonatomic, copy) NSString *replyId;//唯一标示当前内容对象
@property (nonatomic, copy) NSString *userType;//标示回复类型，开发者的回复为"dev_reply"，用户的回复为"user_reply"


@property (nonatomic, assign) MessageType type;

@property (nonatomic, copy) NSDictionary *dict;

@end
