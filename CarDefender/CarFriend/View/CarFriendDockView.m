//
//  CarFriendDockView.m
//  CarDefender
//
//  Created by 李散 on 15/4/1.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CarFriendDockView.h"
#define KCOLOR(a,b,c) [UIColor colorWithRed:(a)/255.0 green:(b)/255.0 blue:(c)/255.0 alpha:1]
@implementation CarFriendDockView
{
    UIButton *_selectedItem;
}
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0];
    }
    return self;
}
//-(void)drawRect:(CGRect)rect{
//    CGContextRef ref = UIGraphicsGetCurrentContext();
//    CGContextBeginPath(ref);
//    CGContextMoveToPoint(ref, 0, 0);
//    CGContextAddLineToPoint(ref, self.frame.size.width, 0);
//    CGContextSetStrokeColorWithColor(ref, [UIColor blackColor].CGColor);
//    CGContextSetLineWidth(ref, 0.5);
//    CGContextStrokePath(ref);
//}
//添加dockitem
-(void)addItemWithTitle:(NSString *)title image:(NSString *)image selected:(NSString *)selected
{
    UIButton *item = [[UIButton alloc]init];
    [item setTitle:title forState:UIControlStateNormal];
    item.titleLabel.font=kFontOfLetterMedium;
    [self addSubview:item];
    int itemcount = (int)self.subviews.count;
    CGFloat dockWidth = self.frame.size.width/(itemcount+1);
    
    int wight = 0;
    for (int i = 0; i<itemcount; i++)
    {
        if (i == 2 || i == 3)
        {
            wight += dockWidth;
        }else if (i != 0){
            wight += dockWidth;
        }
        UIButton *dockitem = self.subviews[i];
        dockitem.tag = i;
        dockitem.frame = CGRectMake(wight, 6, dockWidth,self.frame.size.height-6);
        dockitem.backgroundColor = KCOLOR(244, 244, 244);
        [dockitem setTitleColor:KCOLOR(247, 105, 2) forState:UIControlStateSelected];
        if (i == 1 || i == 2)
        {
            dockitem.frame = CGRectMake(wight, 6, dockWidth*1.5,self.frame.size.height-6);
            //            dockitem.backgroundColor = [UIColor greenColor];
        }
        
        [dockitem addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
    }
    if (itemcount == 1) {
        _selectedItem = item;
        [self itemClick:item];
    }
}

//dockitem被点击
-(void)itemClick:(UIButton *)item{
    if ([_delegate respondsToSelector:@selector(dock:selectItemFrom:to:)]) {
        [_delegate dock:self selectItemFrom:(int)_selectedItem.tag to:(int)item.tag];
    }
    _selectedItem.selected = NO;
    item.selected = YES;
    _selectedItem = item;
    _selectedIndex = (int)_selectedItem.tag;
    
}


@end
