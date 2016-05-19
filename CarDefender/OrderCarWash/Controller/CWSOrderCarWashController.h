//
//  CWSOrderCarWashController.h
//  CarDefender
//
//  Created by 周子涵 on 15/8/19.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMNavController.h"

@interface CWSOrderCarWashController : BMNavController<UITextFieldDelegate>
{
    CLLocationCoordinate2D   _oldPt;
    CLLocationCoordinate2D   _newPt;
    BOOL                     _nearbyCar;
    NSArray*                 _markArray;
    int                      _levelNumber;
}
@end
