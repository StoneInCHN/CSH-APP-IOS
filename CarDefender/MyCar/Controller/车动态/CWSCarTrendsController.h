//
//  CWSCarTrendsController.h
//  CarDefender
//
//  Created by 周子涵 on 15/3/30.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSCarTrendsController : UIViewController
@property (strong, nonatomic) NSDictionary*  notiDic;
@property (weak, nonatomic) IBOutlet UIView *backgroundView1;
@property (weak, nonatomic) IBOutlet UIView *backgroundView2;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;

- (IBAction)addBtnClcik:(UIButton *)sender;
@end
