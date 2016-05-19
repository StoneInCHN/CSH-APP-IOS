//
//  Message.m
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "Message.h"

@implementation Message

- (void)setDict:(NSDictionary *)dict{
    
    _dict = dict;
    
//    self.icon = dict[@"icon"];
    self.time = [NSString stringWithFormat:@"%@",dict[@"created_at"]];
    self.content = [NSString stringWithFormat:@"%@",dict[@"content"]];
    self.isFailed=[NSString stringWithFormat:@"%@",dict[@"is_failed"]];
    self.replyId=[NSString stringWithFormat:@"%@",dict[@"reply_id"]];
    self.userType=[NSString stringWithFormat:@"%@",dict[@"type"]];
    if ([dict[@"type"] isEqualToString:@"dev_reply"]) {//开发者回复
        self.type=1;
    }else{
        self.type=0;
    }
}



@end
