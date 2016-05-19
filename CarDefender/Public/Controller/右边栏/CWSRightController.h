//
//  CWSRightController.h
//  CarDefender
//
//  Created by 周子涵 on 15/3/24.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSRightController : UIViewController

//试图将要显示
-(void)rightViewWillAppear;
//试图显示完成
-(void)rightViewDidAppear;
//试图将要消失
-(void)rightViewWillDisappear;
//试图消失完成
-(void)rightViewDidDisappear;
@end
