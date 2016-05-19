//
//  UserManager.h
//  云车宝项目
//
//  Created by sky on 14-9-17.
//  Copyright (c) 2014年 HCYunAPP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserNew.h"

@interface UserManager : NSObject
@property (strong, nonatomic) UserNew *user;

+(UserManager *)shareUserManagerInfo;
@end
