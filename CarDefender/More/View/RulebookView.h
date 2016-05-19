//
//  RulebookView.h
//  云车宝项目
//
//  Created by sky on 14-8-21.
//  Copyright (c) 2014年 HCYunAPP. All rights reserved.
//
@protocol RulebookViewDelegate <NSObject>

-(void)ruleBookViewRewardBtnClick;

@end
#import <UIKit/UIKit.h>

@interface RulebookView : UIView
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhongjiangLabel;

@property (assign, nonatomic) id<RulebookViewDelegate>delegate;
- (IBAction)zhongjiangjiluBtnClick:(UIButton *)sender;
@end
