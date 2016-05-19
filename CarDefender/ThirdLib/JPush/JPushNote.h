//
//  JPushNote.h
//  JPush_Test
//
//  Created by 王泰莅 on 15/11/24.
//  Copyright © 2015年 王泰莅. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JPushNote : NSObject

@property (nonatomic,copy) void(^localReceiveMsg)(NSString*);

+(JPushNote*)sharedInstance;

@end
