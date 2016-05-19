//
//  LHPModelCarViewCell.h
//  云车宝选车Demo
//
//  Created by pan on 14/12/19.
//  Copyright (c) 2014年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHPModelCarViewCell : UITableViewCell
@property (strong, nonatomic) NSDictionary*modelDicMsg;
@property (weak, nonatomic) IBOutlet UIImageView *carImage;
@property (weak, nonatomic) IBOutlet UILabel *carNameLabel;

@end
