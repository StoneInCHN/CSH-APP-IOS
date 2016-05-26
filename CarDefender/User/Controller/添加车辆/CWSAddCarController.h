//
//  CWSAddCarController.h
//  CarDefender
//
//  Created by 周子涵 on 15/3/28.
//  Copyright (c) 2015年 SKY. All rights reserved.
//
@protocol CWSAddCarControllerDelegate <NSObject>



@end
#import <UIKit/UIKit.h>

@interface CWSAddCarController : UIViewController
@property(nonatomic,assign)NSString*rightAddCar;
@property(nonatomic,strong)NSDictionary*editDic;
@property (nonatomic, strong) NSString*carNubString;//车牌号

@property (nonatomic, strong) NSString *noDeviceComeBackEdit;//没有设备返回编辑界面

@property (strong, nonatomic) IBOutlet UITextField *carNumberTextField;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (strong, nonatomic) IBOutlet UIView *groundView;
//@property (weak, nonatomic) IBOutlet UITextField *carIDText;
//@property (weak, nonatomic) IBOutlet UITextField *carJiaNubText;
@property (weak, nonatomic) IBOutlet UITextField *carCheXinLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseCarBtn;
@property (weak, nonatomic) IBOutlet UITextField *currentKiloText;//行驶里程
//@property (weak, nonatomic) IBOutlet UITextField *hibitOilText;
@property (weak, nonatomic) IBOutlet UITextField *nextCheckText;//下次年检
@property (weak, nonatomic) IBOutlet UITextField *nextNianJian;//下次年检
@property (weak, nonatomic) IBOutlet UITextField *jiaoqiangxian;//交强险
@property (weak, nonatomic) IBOutlet UITextField *shangyexian;//商业险

@property (weak, nonatomic) IBOutlet UITextField *lastKilomText;//上次保养
//@property (weak, nonatomic) IBOutlet UIButton *carNubBtn;
@property (weak, nonatomic) IBOutlet UIImageView *carImage;
//@property (weak, nonatomic) IBOutlet UITextField *carNubLabel;
//@property (weak, nonatomic) IBOutlet UIButton *carColorBtn;
@property (weak, nonatomic) IBOutlet UIView *addCarHeadView;
//@property (weak, nonatomic) IBOutlet UITextField *shopID;
//- (IBAction)addtionalClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
//- (IBAction)shopIDTextChange:(UITextField *)sender;
- (IBAction)btnClick:(UIButton *)sender;


@property (strong, nonatomic) IBOutlet UILabel *carAreaLabel; //车牌省

@property (strong, nonatomic) IBOutlet UILabel *carLetterLabel;//车牌市

@property (strong, nonatomic) IBOutlet UITextField *carBoundIdTextFiled;//设备id

@property (weak, nonatomic) IBOutlet UITextField *carFrameField;//车架号

@property (weak, nonatomic) IBOutlet UIView *bindIDView;

@end
