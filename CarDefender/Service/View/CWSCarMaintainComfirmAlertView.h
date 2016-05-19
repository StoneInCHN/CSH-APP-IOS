//
//  CWSCarMaintainComfirmAlertView.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/7.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CWSTableViewButtonCellDelegate.h"
@interface CWSCarMaintainComfirmAlertView : UIView


@property (strong, nonatomic) IBOutlet UILabel *AlertMessageLabel;


@property (nonatomic,assign)id <CWSTableViewButtonCellDelegate> delegate;

@end
