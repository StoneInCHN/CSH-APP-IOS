//
//  RepairCell.h
//  CarDefender
//
//  Created by 周子涵 on 15/4/8.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepairCell : UITableViewCell<UIAlertViewDelegate>
{
    NSDictionary*_currentDic;
    NSString*_telNub;
    BOOL repairOrOther;
}
@property(nonatomic,strong)NSDictionary*dicMsg;
@property(nonatomic,strong)NSDictionary*repairMsgDic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distabceLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
- (IBAction)makePhoneCall:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *companyImage;
- (IBAction)phoneBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *telBtn;
@end
