//
//  UserNew.m
//  CarDefender
//
//  Created by 李散 on 15/6/3.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "UserNew.h"

@implementation UserNew




//@property (strong, nonatomic) UserAccountNew* account;//账户信息
//@property (strong, nonatomic) UserScoreNew* score;//账户信息
//@property (strong, nonatomic) UserDefaultCarNew* car;//账户信息
//@property (strong, nonatomic) NSArray          *carArray;//所有车辆


-(instancetype)initWithDic:(NSDictionary*)lDic
{
    if (self = [super init]) {
#if USENEWVERSION
//        if (lDic[@"id"] != nil) {
//           self.uid = lDic[@"id"];
//        }
//        else {
            self.uid = lDic[@"uid"];
//        }
        
        self.mobile = lDic[@"mobile"];

        self.signature = lDic[@"signature"];
        self.nick_name = lDic[@"nick_name"];
        self.icon = lDic[@"icon"];
        self.email = lDic[@"email"];
        self.qq = lDic[@"qq"];
        self.sex = [NSString stringWithFormat:@"%@",lDic[@"sex"]];
        self.birth_date = lDic[@"birth_date"];
        self.identity_card = lDic[@"identity_card"];
        self.driver_license = lDic[@"driver_license"];
        self.baseUrl = lDic[@"baseUrl"];
        self.userCID = lDic[@"cid"];
        self.advertisementInfoArray = @[].mutableCopy;
        self.advertisementInfoArray = lDic[@"advertisementInfo"];
        self.defaultStoreArray = @[].copy;
        self.defaultStoreArray = lDic[@"defaultStores"];
        self.userDefaultVehicle = @{}.mutableCopy;
        self.userDefaultVehicle = lDic[@"defaultVehicle"];

        
//        self.driver_license = lDic[@"driver_license"];

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#else
        self.uid = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"uid"]];
        self.key = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"key"]];
        self.no = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"no"]];
        self.tel = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"tel"]];
        self.nick = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"nick"]];
        self.photo = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"photo"]];
        self.isPush = [[NSString stringWithFormat:@"%@",[lDic objectForKey:@"isPush"]] intValue];
        self.note = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"note"]];
        self.sign = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"sign"]];
        self.msg = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"msg"]];
        self.account = [[UserAccountNew alloc]initWithDic:[lDic objectForKey:@"account"]];
        self.score = [[UserScoreNew alloc]initWithDic:[lDic objectForKey:@"score"]];
        self.car = [[UserDefaultCarNew alloc]initWithDic:[lDic objectForKey:@"car"]];
        self.carArray = [[NSArray alloc] initWithArray:[lDic objectForKey:@"cars"]];
        NSString* type = [[NSUserDefaults standardUserDefaults] stringForKey:@"type"];
        if (type == nil) {
            type = [NSString stringWithFormat:@"%@",[lDic objectForKey:@"type"]];
            if ([type isEqualToString:@"1"]) {
                NSUserDefaults*user=[[NSUserDefaults alloc]init];
                [user setObject:[lDic objectForKey:@"type"] forKey:@"type"];
                [NSUserDefaults resetStandardUserDefaults];
            }
        }
        self.type = [type intValue];

#endif

    }
    return self;
}
@end
