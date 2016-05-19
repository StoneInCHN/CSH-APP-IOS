//
//  CWSEvaluationViewController.h
//  CarDefender
//
//  Created by 万茜 on 15/12/5.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWSHistoryOrder.h"

@interface CWSEvaluationViewController : UIViewController


@property (nonatomic,strong)UIButton *addPhotoButton;//添加晒单照片
@property (nonatomic,strong)UIButton *addEvaluationButton;//发表评论
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ordeMoneyLabel;




@property (nonatomic,strong)CWSHistoryOrder *order;
@end
