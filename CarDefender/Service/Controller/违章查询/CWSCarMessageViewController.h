//
//  CWSCarMessageViewController.h
//  CarDefender
//
//  Created by 万茜 on 15/12/9.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSCarMessageViewController : UIViewController

@property (nonatomic,strong)UIButton *chooseBrandButton;//选择品牌
@property (nonatomic,strong)UIButton *chooseCarCityButton;//选择车城市
@property (nonatomic,strong)UIButton *chooseNumberButton;//选择字母
@property (nonatomic,strong)UIButton *checkCityButton;//查询城市
@property (nonatomic,strong)UIButton *saveButton;//保存
@property (weak, nonatomic) IBOutlet UILabel *carAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *carLetterLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkCityLabel;
@property (weak, nonatomic) IBOutlet UITextField *carBrandField;
@property (weak, nonatomic) IBOutlet UITextField *carNumberField;
@property (weak, nonatomic) IBOutlet UITextField *carFrameField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *groundView;
@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UIView *addCarHeadView;

@end
