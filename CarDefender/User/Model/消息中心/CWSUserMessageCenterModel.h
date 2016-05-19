//
//  CWSUserMessageCenterModel.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/10.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWSUserMessageCenterModel : NSObject


/**消息类型*/
@property (nonatomic,copy) NSString *messageType;


/**消息标题*/
@property (nonatomic,copy)  NSString* messageTitle;


/**消息日期*/
@property (nonatomic,copy)  NSString* messageDate;


/**消息内容*/
@property (nonatomic,copy)  NSString* messageContent;


/**消息ID*/
@property (nonatomic,copy)  NSString* messageId;


/**是否选中*/
@property (nonatomic,assign)  BOOL isSelected;


-(instancetype)initWithDict:(NSDictionary*)dataDict;

@end
