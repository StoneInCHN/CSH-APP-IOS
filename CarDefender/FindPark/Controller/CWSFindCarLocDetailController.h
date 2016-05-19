//
//  CWSFindCarLocDetailController.h
//  CarDefender
//
//  Created by 李散 on 15/7/28.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMNavController.h"
#import "Park.h"

@interface CWSFindCarLocDetailController : BMNavController
@property (strong, nonatomic) IBOutlet UIView *downView;
@property (strong, nonatomic) Park* park;
@property (assign, nonatomic) CLLocationCoordinate2D oldPt;
@end
