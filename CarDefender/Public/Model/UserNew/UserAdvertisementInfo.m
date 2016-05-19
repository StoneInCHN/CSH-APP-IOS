//
//  UserAdvertisementInfo.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/28.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "UserAdvertisementInfo.h"

@implementation UserAdvertisementInfo

-(instancetype)initWithDict:(NSDictionary*)thyDataDict{

    if(self = [super init]){
        self.advContentLink = thyDataDict[@"advContentLink"];
        self.advImageUrl = thyDataDict[@"advImageUrl"];
        self.apId = thyDataDict[@"id"];

    }
    return self;
}
@end
