
//
//  CWSServiceItem.m
//  CarDefender
//
//  Created by 李散 on 15/4/23.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSServiceItem.h"
#define kImageHeightRate 0.5
#define kDockItemSelected @"tabbar_slider.png"
@implementation CWSServiceItem

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.titleLabel.font = [UIFont systemFontOfSize:9];
//        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [Utils setViewRiders:self.imageView riders:self.frame.size.width/2];
//    }
//    return self;
//}
//-(void)setHighlighted:(BOOL)highlighted{
//    
//}
//
//-(CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//   
//        return CGRectMake(0, contentRect.size.height*2/3, contentRect.size.width, contentRect.size.height/3);
//}
//
//-(CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    return CGRectMake(0, 5, contentRect.size.width, contentRect.size.width);
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:9];
        [self setTitleColor:KBlackMainColor forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}
-(void)setHighlighted:(BOOL)highlighted{
    
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    //    return CGRectMake(0, contentRect.size.height*kImageHeightRate+5, contentRect.size.width, contentRect.size.height*(1-kImageHeightRate)-5);
    if(self.tag==1)
    {
        return CGRectMake(0, contentRect.size.height*kImageHeightRate+5, contentRect.size.width / 1.5, contentRect.size.height*(1-kImageHeightRate)-5);
    }
    else if (self.tag == 2)
    {
        return CGRectMake(contentRect.size.width/3, contentRect.size.height*kImageHeightRate+5, contentRect.size.width / 1.5, contentRect.size.height*(1-kImageHeightRate)-5);
    }else{
        return CGRectMake(0, contentRect.size.height*kImageHeightRate+5, contentRect.size.width, contentRect.size.height*(1-kImageHeightRate)-5);
    }
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    if(self.tag==1)
    {
        return CGRectMake(0, 5, contentRect.size.width/1.5, contentRect.size.height*kImageHeightRate);
    }
    else if (self.tag == 2)
    {
        return CGRectMake(contentRect.size.width/3, 5, contentRect.size.width/1.5, contentRect.size.height*kImageHeightRate);
    }else{
        return CGRectMake(0, 5, contentRect.size.width, contentRect.size.height*kImageHeightRate);
    }
    
}

-(CGRect)middleImageRectForContentRect:(CGRect)contentRect
{
    if(self.tag==1)
    {
        return CGRectMake(0, 5, contentRect.size.width/1.5, contentRect.size.height);
    }
    else if (self.tag == 2)
    {
        return CGRectMake(contentRect.size.width/3, 5, contentRect.size.width/1.5, contentRect.size.height);
    }else{
        return CGRectMake(0, 5, contentRect.size.width, contentRect.size.height);
    }
    
}

@end
