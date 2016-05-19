//
//  CWSProtectView.h
//  CarDefender
//
//  Created by 李散 on 15/10/13.
//  Copyright © 2015年 SKY. All rights reserved.
//
@protocol CWSProtectViewDelegate <NSObject>

- (void)protectViewWitchClick:(BOOL)proBool;

@end
#import <UIKit/UIKit.h>

@interface CWSProtectView : UIView

@property (nonatomic, assign) BOOL protectType;

@property (nonatomic, strong) NSString *timeString;
@property (nonatomic, assign) id<CWSProtectViewDelegate>delegate;

@end
