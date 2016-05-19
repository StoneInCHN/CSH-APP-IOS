//
//  CWSDetectionHeaderView.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/14.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CWSDetectionOneForAllViewController;
@interface CWSDetectionHeaderView : UIView


@property (nonatomic,strong) NSDictionary* dataDict;
@property (nonatomic,strong)NSDictionary *checkData;
@property (nonatomic,strong) NSArray* senderDataArray;
@property (nonatomic,strong) CWSDetectionOneForAllViewController* thyRootVc;
@property (nonatomic,strong) UILabel *carSimpleInfoLabel; //车辆使用简易信息
-(void)setDataDict:(NSDictionary *)dataDict;
- (instancetype)initWithFrame:(CGRect)frame Data:(NSDictionary *)data;
@end
