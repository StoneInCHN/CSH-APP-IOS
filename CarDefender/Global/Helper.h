//
//  Helper.h
//  CarDefender
//
//  Created by sicnu_ifox on 16/5/11.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

+ (BOOL)isStringEmpty:(NSString *)string;
+ (NSString *)convertDateViaTimeStamp:(double)timeStamp;
+ (NSString *)convertNULLToString:(id)data;

@end
