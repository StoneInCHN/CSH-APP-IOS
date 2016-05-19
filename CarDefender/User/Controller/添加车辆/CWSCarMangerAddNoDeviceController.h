//
//  CWSCarMangerAddNoDeviceController.h
//  CarDefender
//
//  Created by pan on 15/6/7.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSCarMangerAddNoDeviceController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *goLookBtn;
@property (weak, nonatomic) IBOutlet UIButton *goBackBtn;

@property (strong, nonatomic) NSString*carID;//车辆id

- (IBAction)clickBtn:(UIButton *)sender;
@end
