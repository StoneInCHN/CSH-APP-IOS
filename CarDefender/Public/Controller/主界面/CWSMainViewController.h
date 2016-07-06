//
//  CWSMainViewController.h
//  carLife
//
//  Created by 王泰莅 on 15/12/2.
//  Copyright © 2015年 王泰莅. All rights reserved.
//

#import "CWSBasicViewController.h"

@interface CWSMainViewController : CWSBasicViewController

@property (weak, nonatomic) IBOutlet UILabel *badgeValueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImage;

@property (weak, nonatomic) IBOutlet UIImageView *UserIcon;
@property (weak, nonatomic) IBOutlet UIScrollView *myIndexScrollView;

@end
