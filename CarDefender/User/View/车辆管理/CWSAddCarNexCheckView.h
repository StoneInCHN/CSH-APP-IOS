//
//  CWSAddCarNexCheckView.h
//  CarDefender
//
//  Created by 李散 on 15/5/8.
//  Copyright (c) 2015年 SKY. All rights reserved.
//
@protocol CWSAddCarNexCheckViewDelegate <NSObject>

-(void)addCarNexCheckViewChooseDate:(NSDate*)chooseDate;

@end
#import <UIKit/UIKit.h>

@interface CWSAddCarNexCheckView : UIView
{
    NSDate *chooseDate;
    //UIDatePicker*_datePicker;
}
@property (nonatomic,strong)UIDatePicker *datePicker;
@property (assign, nonatomic) id<CWSAddCarNexCheckViewDelegate>delegate;

-(void)loadDatePickerView;
@end
