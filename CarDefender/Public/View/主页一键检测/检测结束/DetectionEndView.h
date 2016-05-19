//
//  DetectionEndView.h
//  yijianjiance
//
//  Created by 周子涵 on 15/6/24.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Define.h"

@protocol DetectionEndDelegate <NSObject>
@optional
-(void)detectionEndBtnClick:(int)type dictionary:(NSDictionary*)dic;

@end

@interface DetectionEndView : UIView
{
    CGFloat _carStateNumber;       //车辆状态得分
    CGFloat _maintainStateNumber;  //养护状态得分
    CGFloat _carStatePercent;      //车辆状态百分比
    CGFloat _maintainStatePercent; //养护状态百分比
    BOOL    _animationStart;       //动画开始
    NSDictionary* _dataDic;        //数据
}
@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;

@property (weak, nonatomic) IBOutlet UIImageView *evaluateImageView;        //评价图片
@property (weak, nonatomic) IBOutlet UIImageView *carLogoImageView;         //车图标
@property (weak, nonatomic) IBOutlet UILabel *plateNumberLabel;             //车牌Label
@property (weak, nonatomic) IBOutlet UILabel *faultLabel;                   //故障检测Label
@property (weak, nonatomic) IBOutlet UIButton *detectionAgainBtn;           //重新检测按钮
@property (weak, nonatomic) IBOutlet UIButton *findMoreBtn;                 //查看详情按钮
@property (weak, nonatomic) IBOutlet UIView *carPlanView;                   //车辆状态View
@property (weak, nonatomic) IBOutlet UIView *maintainPlanView;              //保养状态View
@property (weak, nonatomic) IBOutlet UIImageView *planOneImageView;         //车辆状态背景图
@property (weak, nonatomic) IBOutlet UIImageView *planTwoImageView;         //养护状态背景图
@property (weak, nonatomic) IBOutlet UIImageView *carPlanImageView;         //车辆状态进度图
@property (weak, nonatomic) IBOutlet UIImageView *maintainPlanImageView;    //养护状态进度图
@property (weak, nonatomic) IBOutlet UILabel *carStateLabel;                //车辆状态得分Label
@property (weak, nonatomic) IBOutlet UILabel *maintainStateLabel;           //养护状态得分Label
@property (assign, nonatomic) id<DetectionEndDelegate> delegate;            //代理协议

- (IBAction)btnClick:(UIButton *)sender;
-(void)setDataViewHidden:(BOOL)hidden;
- (void)animationStar:(NSDictionary*)dataDic;
//- (id)initWithFrame:(CGRect)frame Dictionary:(NSDictionary*)dic;
@end
