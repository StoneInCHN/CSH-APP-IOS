//
//  TongXunObject.h
//  通讯录-获取
//
//  Created by pan on 15/3/12.
//  Copyright (c) 2015年 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TongXunObject : NSObject
{
    NSInteger sectionNumber;
    NSInteger recordID;
    NSString *name;
    NSString *email;
    NSString *tel;
}
@property NSInteger sectionNumber;
@property NSInteger recordID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *tel;
@end
