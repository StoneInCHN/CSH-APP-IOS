//
//  CWSUserMsgSettingController.h
//  CarDefender
//
//  Created by 李散 on 15/4/14.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CWSUserCenterObject;
@interface CWSUserMsgSettingController : UIViewController
@property (nonatomic,strong) CWSUserCenterObject*userCenter;
@property (nonatomic,strong) NSArray*cityMsgBack;
@property (nonatomic,strong) NSString*chooseMsgBack;

- (IBAction)chooseAge:(id)sender;
- (IBAction)chooseCity:(id)sender;
- (IBAction)setSingleSign:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *boyImage;
@property (weak, nonatomic) IBOutlet UIView *boyView;
@property (weak, nonatomic) IBOutlet UIView *girlView;
@property (weak, nonatomic) IBOutlet UIImageView *girlImage;
@property (weak, nonatomic) IBOutlet UITextField *ageLabel;
- (IBAction)sexBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *cityLabel;
@property (weak, nonatomic) IBOutlet UITextField *personalSignText;
@property (weak, nonatomic) IBOutlet UITextField *nickNameText;
- (IBAction)saveBtn:(id)sender;
- (IBAction)choosePicClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImage;
@property (weak, nonatomic) IBOutlet UIButton *ageBtn;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UITextField *emileTextField;
@property (weak, nonatomic) IBOutlet UIView *groundView;
@property (weak, nonatomic) IBOutlet UIControl *groundControl;
- (IBAction)groundControlTouchDown;
@property (weak, nonatomic) IBOutlet UIView *girlbackView;
@property (weak, nonatomic) IBOutlet UIView *boyBackView;
- (IBAction)nickNameChange:(UITextField *)sender;

@end
