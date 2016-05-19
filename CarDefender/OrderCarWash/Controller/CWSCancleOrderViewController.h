//
//  CWSCancleOrderViewController.h
//  CarDefender
//
//  Created by 万茜 on 15/12/8.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSCancleOrderViewController : UIViewController
@property (nonatomic,strong)UIButton *firstClickButton;
@property (nonatomic,strong)UIButton *secondClickButton;
@property (nonatomic,strong)UIButton *thirdClickButton;
@property (nonatomic,strong)UIView   *textCustomView;
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)UIButton *submitButton;
@property (nonatomic,assign)NSInteger   orderId;

@end
