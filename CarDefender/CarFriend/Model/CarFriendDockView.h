//
//  CarFriendDockView.h
//  CarDefender
//
//  Created by 李散 on 15/4/1.
//  Copyright (c) 2015年 SKY. All rights reserved.
//
@class CarFriendDockView;
@protocol CarFriendDockViewDelegate <NSObject>
@optional
-(void)dock:(CarFriendDockView *)dock selectItemFrom:(int)from to:(int)to;

@end
#import <UIKit/UIKit.h>

@interface CarFriendDockView : UIView
@property (nonatomic,strong) UILabel*chatNubLabel;
@property (nonatomic,strong) UILabel*contactLabel;
@property (nonatomic,weak)id<CarFriendDockViewDelegate> delegate;
@property (nonatomic,assign) int selectedIndex;
-(void)addItemWithTitle:(NSString *)title image:(NSString *)image selected:(NSString *)selected;
-(void)carFriendDockContactListNubChange:(NSString*)contactNub;
-(void)carFriendDockChatListNubChange:(NSString*)contactNub;
@end
