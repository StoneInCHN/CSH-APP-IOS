//
//  User.h
//  云车宝项目
//
//  Created by sky on 14-9-17.
//  Copyright (c) 2014年 HCYunAPP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAccount.h"
#import "UserScore.h"
#import "UserDefaultCar.h"
@interface User : NSObject

@property (strong, nonatomic) UserAccount* account;
@property (strong, nonatomic) UserDefaultCar* car;
@property (strong, nonatomic) UserScore* score;
@property (strong, nonatomic) NSString* key;
@property (strong, nonatomic) NSString* mileRanking;
@property (strong, nonatomic) NSString* nick;
@property (strong, nonatomic) NSString* no;
@property (strong, nonatomic) NSString* photo;
@property (strong, nonatomic) NSString* tel;
@property (strong, nonatomic) NSString* uid;
@property (strong, nonatomic) NSString* currentCity;
@property (strong, nonatomic) NSString* sign;
@property (assign, nonatomic) CLLocationCoordinate2D currentPt;

-(instancetype)initWithDic:(NSDictionary*)lDic;
@end
