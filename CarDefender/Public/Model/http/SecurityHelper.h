//
//  SecurityHelper.h
//  CarDefender
//
//  Created by sicnu_ifox on 16/5/5.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityHelper : NSObject

+ (void)getPublicKeySuccess:(void (^)(AFHTTPRequestOperation *operation, NSString *publicKey))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
