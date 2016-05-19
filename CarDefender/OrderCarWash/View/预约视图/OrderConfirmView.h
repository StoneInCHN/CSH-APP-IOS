//
//  OrderConfirmView.h
//  CarDefender
//
//  Created by 万茜 on 15/11/25.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderConfirmDelegate <NSObject>

- (void)alreadyWash:(NSDictionary *)dic;

@end

@interface OrderConfirmView : UIView
@property (assign,nonatomic)id<OrderConfirmDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame controller:(UIViewController *)controller data:(NSDictionary *)dic;

@end
