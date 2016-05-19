//
//  CarManagerMsg.h
//  CarDefender
//
//  Created by 李散 on 15/4/7.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarManagerMsg : NSObject
{
    NSString *carMsgId;
    NSString *carMsgText;
    NSString *carMsgChecked;
    NSString *pinYin;
}
@property(strong,nonatomic)NSString*carMsgId;
@property(strong,nonatomic)NSString*carMsgText;
@property(strong,nonatomic)NSString*carMsgChecked;
@property(strong,nonatomic)NSString *pinYin;
@end
