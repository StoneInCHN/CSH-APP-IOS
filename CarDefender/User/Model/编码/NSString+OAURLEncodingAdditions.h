//
//  NSString+OAURLEncodingAdditions.h
//  HEICHE
//
//  Created by mac on 14-6-30.
//  Copyright (c) 2014年 farawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (OAURLEncodingAdditions)

- (NSString *)qudiaodianN;

- (NSString *)URLEncodedString;

- (NSString *)URLDecodedString;

- (NSString *)replaceUnicode;

@end
