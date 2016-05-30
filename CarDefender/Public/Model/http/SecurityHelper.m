//
//  SecurityHelper.m
//  CarDefender
//
//  Created by sicnu_ifox on 16/5/5.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "SecurityHelper.h"
#import "AFHTTPRequestOperationManager.h"

@implementation SecurityHelper

+ (void)getPublicKeySuccess:(void (^)(AFHTTPRequestOperation *, NSString *publicKey))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *url = @"http://120.27.92.247:10001/csh-interface/endUser/rsa.jhtml";
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject :%@",responseObject);
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([[dict objectForKey:@"code"] isEqualToString:SERVICE_SUCCESS]) {
            success(operation,[dict objectForKey:@"desc"]);
        } else {
            failure(operation,[dict objectForKey:@"desc"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
}
@end
