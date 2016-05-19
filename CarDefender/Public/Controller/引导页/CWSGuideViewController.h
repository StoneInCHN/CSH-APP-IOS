//
//  CWSGuideViewController.h
//  CarDefender
//
//  Created by 李散 on 15/4/28.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSGuideViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *experienceBtn;
- (IBAction)experienceClick:(UIButton *)sender;

@end
