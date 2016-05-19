//
//  UserScore.h
//  CarDefender
//
//  Created by 李散 on 15/4/10.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserScore : NSObject
@property (strong, nonatomic) NSString* cid;
//@property (strong, nonatomic) NSString* note;
@property (strong, nonatomic) NSString* now;
//@property (strong, nonatomic) NSString* time;
//@property (strong, nonatomic) NSString* total;
//@property (strong, nonatomic) NSString* uid;
//@property (strong, nonatomic) NSString* used;
-(instancetype)initWithDic:(NSDictionary*)lDic;
@end
