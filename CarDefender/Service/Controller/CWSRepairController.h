//
//  CWSRepairController.h
//  CarDefender
//
//  Created by 周子涵 on 15/4/8.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
@interface CWSRepairController : UIViewController
@property(nonatomic,strong)NSString*cityString;
@property (strong, nonatomic) NSString* subTitle;
@property (strong, nonatomic) NSDictionary* dataDic;
@property (strong, nonatomic) NSString*keyWords;
@end
