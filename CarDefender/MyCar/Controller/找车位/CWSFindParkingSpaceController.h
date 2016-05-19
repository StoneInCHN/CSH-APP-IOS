//
//  CWSFindParkingSpaceController.h
//  FindCarLocation
//
//  Created by 周子涵 on 15/7/14.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSFindParkingSpaceController : UIViewController<UITextFieldDelegate>
{
    CLLocationCoordinate2D   _oldPt;
    CLLocationCoordinate2D   _newPt;
    BOOL                     _nearbyCar;
    NSArray*                 _markArray;
    int                      _levelNumber;
}
@property (weak, nonatomic) IBOutlet UIView *searchGroundView;       //顶部搜索框View
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;            //顶部右边按钮
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;    //顶部右边标志图片
@property (weak, nonatomic) IBOutlet UIView *searchViewGroundView;   //搜索栏的搜索背景VIEW
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;   //搜索TextField
@property (strong, nonatomic) IBOutlet UIView *searchView;           //搜索状态

- (IBAction)addBtnClick:(UIButton *)sender;
- (IBAction)btnClick:(UIButton *)sender;
- (IBAction)btnTouchDown:(UIButton *)sender;
@end
