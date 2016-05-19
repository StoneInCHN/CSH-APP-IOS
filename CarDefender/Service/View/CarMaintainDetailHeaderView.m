//
//  CarMaintainDetailHeaderView.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/6.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CarMaintainDetailHeaderView.h"

@implementation CarMaintainDetailHeaderView



-(instancetype)init{

    if(self = [super init]){
    
        self = [[[NSBundle mainBundle]loadNibNamed:@"CarMaintainDetailHeaderView" owner:self options:nil] lastObject];
        
        _storeReviewView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}



-(void)setStoreReviewView:(UIView *)storeReviewView{

    _storeReviewView = storeReviewView;

    for(int i=0; i<3; i++){
        
        UIImageView* diamondImg = [[UIImageView alloc]initWithFrame:CGRectMake(i*16, 0, 15, 15)];
        diamondImg.image = [UIImage imageNamed:@"haoping"];
        [self.storeReviewView addSubview:diamondImg];
        if(i == 2){
            UILabel* reviewLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(diamondImg.frame)+4, 0, kSizeOfScreen.width, 13)];
            reviewLabel.text = @"100%好评";
            reviewLabel.font = [UIFont systemFontOfSize:15.0f];
            reviewLabel.textColor = kCOLOR(255, 102, 0);
            [self.storeReviewView addSubview:reviewLabel];
        }
    }
}


-(void)setTitleImageView:(UIImageView *)titleImageView{

    _titleImageView = titleImageView;
    

    self.titleImageView.layer.borderColor = [UIColor cyanColor].CGColor;
    self.titleImageView.layer.borderWidth = 1.0f;
}

-(void)setStoreImageView:(UIImageView *)storeImageView{

    _storeImageView = storeImageView;
    

    self.storeImageView.layer.borderWidth = 1.0f;
    self.storeImageView.layer.borderColor = [UIColor cyanColor].CGColor;

}


- (IBAction)makeCallButtonClicked:(UIButton *)sender {
    
    NSLog(@"打电话");
}


- (IBAction)checkLocationButtonClicked:(UIButton *)sender {
    
    NSLog(@"查地图");
}


@end
