//
//  CarMaintainTableViewCell.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/6.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CarMaintainTableViewCell.h"

@implementation CarMaintainTableViewCell





//-(void)setStoreReviewView:(UIView *)storeReviewView{
//
//    _storeReviewView = storeReviewView;
//    
//    
//    
//    for(int i=0; i<3; i++){
//        
//        UIImageView* diamondImg = [[UIImageView alloc]initWithFrame:CGRectMake(i*16, 0, 15, 15)];
//        diamondImg.image = [UIImage imageNamed:@"haoping"];
//        [self.storeReviewView addSubview:diamondImg];
//        if(i == 2){
//            UILabel* reviewLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(diamondImg.frame)+4, 0, kSizeOfScreen.width, 13)];
//            reviewLabel.text = @"100%好评";
//            reviewLabel.font = [UIFont systemFontOfSize:15.0f];
//            reviewLabel.textColor = kCOLOR(255, 102, 0);
//            [self.storeReviewView addSubview:reviewLabel];
//        }
//    }
//    
//}
//
//
//-(void)setStoreImageView:(UIImageView *)storeImageView{
//
//    _storeImageView = storeImageView;
//    
//    self.storeImageView.layer.borderColor = [UIColor cyanColor].CGColor;
//    self.storeImageView.layer.borderWidth = 1.0f;
//
//}
//
//-(void)setSubscribeButton:(UIButton *)subscribeButton{
//    
//    _subscribeButton = subscribeButton;
//
//    self.subscribeButton.layer.masksToBounds = YES;
//    self.subscribeButton.layer.borderColor = [UIColor colorWithRed:0.992f green:0.698f blue:0.380f alpha:1.00f].CGColor;
//    self.subscribeButton.layer.borderWidth = 1.0f;
//    self.subscribeButton.layer.cornerRadius = 5.0f;
//    
//    [self.subscribeButton setTitleColor:[UIColor colorWithRed:0.992f green:0.698f blue:0.380f alpha:1.00f] forState:UIControlStateNormal];
//    
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Data:(NSDictionary *)dic
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CarMaintainTableViewCell" owner:self options:nil] lastObject];
        self.dataDic = [dic mutableCopy];
        [self showUI];
    }
    return self;
}

- (void)showUI
{
    
    //按钮
    self.subscribeButton.layer.masksToBounds = YES;
    self.subscribeButton.layer.borderColor = [UIColor colorWithRed:0.992f green:0.698f blue:0.380f alpha:1.00f].CGColor;
    self.subscribeButton.layer.borderWidth = 1.0f;
    self.subscribeButton.layer.cornerRadius = 5.0f;
    
    [self.subscribeButton setTitleColor:[UIColor colorWithRed:0.992f green:0.698f blue:0.380f alpha:1.00f] forState:UIControlStateNormal];
}

- (IBAction)firstButtonClicked:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(selectTableViewButtonClicked:Red:ID:andDataDict:)]){
        [self.delegate selectTableViewButtonClicked:sender Red:0 ID:[self.dataDic[@"merchantsID"] integerValue] andDataDict:self.dataDic];
    }
}


- (void)awakeFromNib {
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
