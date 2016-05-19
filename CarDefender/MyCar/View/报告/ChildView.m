//
//  ChildView.m
//  报告动画
//
//  Created by 周子涵 on 15/5/6.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "ChildView.h"
#define kLargeRadius kSizeOfScreen.width
#define KSmallRadius 50

@implementation ChildView
- (id)initWithFrame:(CGRect)frame Dictionary:(NSDictionary*)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI:CGRectMake(kInterval/2, 0, KSmallRadius, KSmallRadius) nameFrame:CGRectMake(0, KSmallRadius + 4, KSmallRadius + kInterval, 12) dataFrame:CGRectMake(0, KSmallRadius + 20, KSmallRadius + kInterval, 12) imageName:dic[@"image"] name:dic[@"name"] data:dic[@"data"]];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame cost:(NSString*)cost{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI:CGRectMake(kInterval/2 - 24, -20, 50, 50) nameFrame:CGRectMake(0, 28 + 8, kInterval, 12) dataFrame:CGRectMake(0, 28 + 20+8, kInterval + KSmallRadius, 12) imageName:@"baogao_feiyong" name:@"用车支出" data:cost];
        self.dataLabel.center = CGPointMake(kInterval/2, 54);
    }
    return self;
}
-(void)creatUI:(CGRect)imageFrame nameFrame:(CGRect)nameFrame dataFrame:(CGRect)dataFrame imageName:(NSString*)imageName name:(NSString*)name data:(NSString*)data{
    _imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    _imageView.image = [UIImage imageNamed:imageName];
    [self addSubview:_imageView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
    self.nameLabel.font = kFontOfSize(12);
    self.nameLabel.text = name;
    [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.nameLabel];
    
    self.dataLabel = [[UILabel alloc] initWithFrame:dataFrame];
    self.dataLabel.font = kFontOfSize(12);
    
    self.dataLabel.text = data;
   
    
    self.dataLabel.textColor = kMainColor;
    [self.dataLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.dataLabel];
}
-(void)reloadData:(NSDictionary*)dic{
    if ([self fisrtIsNumber:dic[@"data"]]) {
        self.dataLabel.text = dic[@"data"];
    }
    
    else {
        //用车支出判断  以￥开头
        if (![self fisrtIsNumber:dic[@"data"]] && ![self fisrtIsLetter:dic[@"data"]]) {
            if (((NSString *)dic[@"data"]).length>1) {
                char second = [dic[@"data"] characterAtIndex:1];
                if (second >= 48 && second <= 57) {
                    self.dataLabel.text = [NSString stringWithFormat:@"%@",dic[@"data"]];
                }
                else {
                    self.dataLabel.text = [NSString stringWithFormat:@"%@0",dic[@"data"]];
                }
            }
            else {
                self.dataLabel.text = [NSString stringWithFormat:@"%@0",dic[@"data"]];
            }
            
        }
        else {
            self.dataLabel.text = [NSString stringWithFormat:@"0%@",dic[@"data"]];
        }
        
    
        
    }
}


- (BOOL)fisrtIsNumber:(NSString *)string
{
    char first = [string characterAtIndex:0];
    if (first >= 48 && first <= 57) {
        return YES;
    }
    else {
        return NO;
    }
    
}

- (BOOL)fisrtIsLetter:(NSString *)string
{
    char first = [string characterAtIndex:0];
    if ((first >= 65 && first <= 90)||(first >= 97 && first <= 122)) {
        return YES;
    }
    else {
        return NO;
    }
    
}


@end
