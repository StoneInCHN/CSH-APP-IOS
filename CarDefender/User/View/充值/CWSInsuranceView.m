//
//  CWSInsuranceView.m
//  CarDefender
//
//  Created by 李散 on 15/10/14.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSInsuranceView.h"
@interface CWSInsuranceView()

@property (nonatomic, strong) UIImageView *companyImgView;

@property (nonatomic, strong) UIImageView *safeImgView;

@property (nonatomic, strong) UILabel *msgLabel;

@property (nonatomic, strong) UILabel *insuranceNubLabel;

@property (nonatomic, strong) UIView *downLineView;
@end
@implementation CWSInsuranceView
-(UIImageView *)companyImgView
{
    if (_companyImgView == nil) {
        UIImageView*img = [[UIImageView alloc]init];
        img.image = [UIImage imageNamed:@"company_name"];
        [self addSubview:img];
        _companyImgView = img;
    }
    return _companyImgView;
}
-(UIImageView *)safeImgView
{
    if (_safeImgView == nil) {
        UIImageView*img = [[UIImageView alloc]init];
        img.image = [UIImage imageNamed:@"baodan_baozhang@2x"];
        [self addSubview:img];
        _safeImgView = img;
    }
    return _safeImgView;
}
-(UILabel *)msgLabel
{
    if (_msgLabel == nil) {
        UILabel *labelM = [[UILabel alloc]init];
        labelM.text = @"车生活账户安全险";
        labelM.textColor = KBlackMainColor;
        labelM.font = [UIFont systemFontOfSize:18];
        [self addSubview:labelM];
        _msgLabel = labelM;
    }
    return _msgLabel;
}
-(UIView *)downLineView
{
    if (_downLineView == nil) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = kCOLOR(251, 100, 115);
        [self addSubview:view];
        _downLineView = view;
    }
    return _downLineView;
}
-(UILabel *)insuranceNubLabel
{
    if (_insuranceNubLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kCOLOR(251, 100, 115);
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentRight;
        [self addSubview:label];
        _insuranceNubLabel = label;
    }
    return _insuranceNubLabel;
}
-(void)setStringNub:(NSString *)stringNub
{
    _stringNub = stringNub;
    
    if (stringNub.length) {
        CGSize stringOfSize1=[stringNub boundingRectWithSize:CGSizeMake(kSizeOfScreen.width-40, 1000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} context:nil].size;
        _insuranceNubLabel.frame = CGRectMake(kSizeOfScreen.width-10-stringOfSize1.width, 108, stringOfSize1.width, stringOfSize1.height);
        _insuranceNubLabel.text = stringNub;
    }
    
}
-(void)layoutSubviews
{
    self.companyImgView.frame = CGRectMake(25, 25, 88, 53);
    
    self.safeImgView.frame = CGRectMake(kSizeOfScreen.width-23-75, 19, 75, 75);
    NSString* titleString = @"车生活账户安全险";
    CGSize stringOfSize=[titleString boundingRectWithSize:CGSizeMake(kSizeOfScreen.width-40, 1000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} context:nil].size;
    self.msgLabel.frame = CGRectMake(kSizeOfScreen.width-10-stringOfSize.width, 83, stringOfSize.width, stringOfSize.height);
    
    CGSize stringOfSize1=[@"123" boundingRectWithSize:CGSizeMake(kSizeOfScreen.width-40, 1000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} context:nil].size;

    self.insuranceNubLabel.frame = CGRectMake(10, 108, kSizeOfScreen.width-20, stringOfSize1.height);
    
    self.downLineView.frame = CGRectMake(10, self.frame.size.height-2, kSizeOfScreen.width-20, 2);
    [self bringSubviewToFront:self.safeImgView];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        
    }
    return self;
}

@end
