//
//  RebuildBtn.m
//  按钮高亮
//
//  Created by 李散 on 15/4/25.
//  Copyright (c) 2015年 Mr Li. All rights reserved.
//

#import "RebuildBtn.h"
#define kTIPercent 0.333
@implementation RebuildBtn
-(void)setTitle:(NSString*)titleString withColorNormalAndHighlight:(NSArray*)colorArray withImageNormalAndHighlight:(NSArray*)imageArray
{
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.titleLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:(14)];
    [self setTitle:titleString forState:UIControlStateNormal];
    [self setTitle:titleString forState:UIControlStateHighlighted];
    [self setTitleColor:colorArray[0] forState:UIControlStateNormal];
    [self setTitleColor:colorArray[1] forState:UIControlStateHighlighted];
    [self setImage:[UIImage imageNamed:imageArray[0]] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:imageArray[1]] forState:UIControlStateHighlighted];
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect titleRect;
    
    titleRect=CGRectMake(0, self.frame.size.height*(1-kTIPercent), self.frame.size.width, self.frame.size.height*kTIPercent);
    
    return titleRect;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect imageRect;
    
    imageRect=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*(1-kTIPercent));
    
    return imageRect;
}
@end
