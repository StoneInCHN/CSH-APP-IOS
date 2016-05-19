//
//  TSLocation.h
//  选着城市
//
//  Created by 李散 on 15/4/9.
//  Copyright (c) 2015年 Mr Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSLocation : NSObject
@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *district;
@property (copy, nonatomic) NSString *street;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@end
