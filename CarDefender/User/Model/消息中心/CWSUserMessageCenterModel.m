//
//  CWSUserMessageCenterModel.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/10.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSUserMessageCenterModel.h"

@implementation CWSUserMessageCenterModel


-(instancetype)initWithDict:(NSDictionary*)dataDict{

    if(self = [super init]){
        self.messageType = [NSString stringWithFormat:@"%@",dataDict[@"messageType"]];
        self.messageTitle = [Helper isStringEmpty:dataDict[@"messageTitle"]] ? @"" : dataDict[@"messageTitle"];
        self.messageDate = @"";
        self.messageContent = dataDict[@"messageContent"];
        self.messageId = [NSString stringWithFormat:@"%@",dataDict[@"id"]];
        self.isSelected = ([[NSString stringWithFormat:@"%@",dataDict[@"isRead"]] isEqualToString: @"1"]) ? YES : NO;
    }
    
    return self;
}
@end
