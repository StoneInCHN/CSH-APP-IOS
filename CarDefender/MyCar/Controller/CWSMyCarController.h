//
//  CWSMyCarController.h
//  CarDefender
//
//  Created by 周子涵 on 15/3/28.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSMyCarController : UIViewController
{
    __weak IBOutlet UIImageView *arrowsImageView;
    UIControl*     _homeBackgroundControl;
    BOOL _reportTouch;
}
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (strong, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImage;

@end
