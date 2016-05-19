//
//  CWSNikenameViewController.h
//  CarDefender
//
//  Created by 万茜 on 15/12/3.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWSUserCenterObject.h"

@interface CWSNikenameViewController : UIViewController

@property (nonatomic,strong) CWSUserCenterObject*userCenter;
@property (nonatomic,strong)UITextField   *textField;
@property (nonatomic,strong) NSString *nikeNameString;
@end
