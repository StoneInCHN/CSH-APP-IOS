//
//  CWSBuySafeView.h
//  CarDefender
//
//  Created by 李散 on 15/10/13.
//  Copyright © 2015年 SKY. All rights reserved.
//
@protocol CWSBuySafeViewDelegate <NSObject>

- (void)buySafeViewWithBtnClick:(NSInteger)tagMsg;

@end
#import <UIKit/UIKit.h>

@interface CWSBuySafeView : UIView

@property (nonatomic, assign)BOOL protBool;

@property (nonatomic, assign) id<CWSBuySafeViewDelegate>delegate;

@end
