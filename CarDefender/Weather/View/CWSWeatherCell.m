//
//  CWSWeatherCell.m
//  weather
//
//  Created by 周子涵 on 15/7/7.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSWeatherCell.h"

@implementation CWSWeatherCell

-(void)setDataDic:(NSDictionary *)dataDic{
    self.carImageView.image = [UIImage imageNamed:dataDic[@"carImage"]];
    self.carNameLabel.text = dataDic[@"carName"];
    self.markImageView.image = [UIImage imageNamed:dataDic[@"markImage"]];
    self.markLabel.text = dataDic[@"mark"];
}

@end
