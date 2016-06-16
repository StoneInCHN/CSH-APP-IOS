//
//  OrderCancleProcessView.h
//  CarDefender
//
//  Created by 万茜 on 15/12/8.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCancleProcessView : UIView

@property (weak, nonatomic) IBOutlet UILabel *firstTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTitilLabel;
@property (weak, nonatomic) IBOutlet UIImageView *payImageV;
@property (weak, nonatomic) IBOutlet UIImageView *doneImageV;
@property (weak, nonatomic) IBOutlet UIView *line;

- (instancetype)initWithFrame:(CGRect)frame Data:(NSDictionary *)dic;
@end
