//
//  MaintainReviewTableViewCell.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/9.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "NewCarWashDetailReviewCell.h"

#import "CWSCarWashDetailReviewModel.h"

#define USERREVIEWSTARVIEW_WIDTH 102.0f
#define USERREVIEWSTARVIEW_HEIGHT 16.0f
@implementation NewCarWashDetailReviewCell{

    UIImageView* noneStarImageView;
    UIImageView* fullStarImageView;
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{

    if( self = [super initWithCoder:aDecoder]){
    
       // [self createUI];
    }

    return self;
}


-(void)createUI{
    noneStarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kSizeOfScreen.width-USERREVIEWSTARVIEW_WIDTH-10, 14, USERREVIEWSTARVIEW_WIDTH, USERREVIEWSTARVIEW_HEIGHT)];
    //noneStarImageView.image = [UIImage imageNamed:@"pingjia_lingxing"];
    noneStarImageView.image = [UIImage imageNamed:@"pingjia_xing1"];
    [self.contentView addSubview:noneStarImageView];
    [noneStarImageView sizeToFit];
    
    
    fullStarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kSizeOfScreen.width-USERREVIEWSTARVIEW_WIDTH-10, 14, USERREVIEWSTARVIEW_WIDTH, USERREVIEWSTARVIEW_HEIGHT)];
   // fullStarImageView.image = [UIImage imageNamed:@"pingjia_wuxing"];
    fullStarImageView.image = [UIImage imageNamed:@"pingjia_xing2"];
    [self.contentView addSubview:fullStarImageView];
    [fullStarImageView sizeToFit];
    
}

-(void)setThyReviewModel:(CWSCarWashDetailReviewModel *)thyReviewModel{
    _thyReviewModel = thyReviewModel;
    
    [self createUI];
    
    if(self.userReviewStarView.hidden){
        noneStarImageView.hidden = YES;
        fullStarImageView.hidden = YES;
    }
    
    self.userHeaderImageView.layer.masksToBounds = YES;
    self.userHeaderImageView.layer.cornerRadius = 12.5f;
    self.userHeaderImageView.layer.borderColor = [UIColor blueColor].CGColor;
    self.userHeaderImageView.layer.borderWidth = 1.0f;
    
    self.userNickNameLabel.text = thyReviewModel.userNickName;
    self.userReviewDateLabel.text = thyReviewModel.userReviewDate;
    self.userReviewLabel.text = thyReviewModel.userReviewContent;
    
    
    self.userReviewImagesView.hidden = !thyReviewModel.isHaveImages;
    if(self.userReviewImagesView.hidden){
        [self.userReviewImagesView removeFromSuperview];
    }else{
        self.userReviewImagesView.backgroundColor = [UIColor clearColor];
        for(int i=0; i<3; i++){
            UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(48*i, 0, 40, 40)];
            imageView.layer.borderColor = [UIColor cyanColor].CGColor;
            imageView.layer.borderWidth = 1.0f;
            [self.userReviewImagesView addSubview:imageView];
        }
    }
    
    if(thyReviewModel.isHaveStarView){
        self.userReviewDateLabel.hidden = YES;
        self.userReviewStarView.hidden = YES;
        self.userReviewStarView.backgroundColor = [UIColor whiteColor];
        
        
        float currentWidth = USERREVIEWSTARVIEW_WIDTH / 5 * thyReviewModel.userReviewStarCount;
        CGRect currentFrame = fullStarImageView.frame;
        if(!currentWidth){
            fullStarImageView.hidden = YES;
        }else{
            currentFrame.size.width = currentWidth;
            fullStarImageView.clipsToBounds = YES;
            fullStarImageView.contentMode = UIViewContentModeLeft;
            fullStarImageView.frame = currentFrame;
            
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
