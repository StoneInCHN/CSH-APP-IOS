//
//  CarFriendDockView.m
//  CarDefender
//
//  Created by 李散 on 15/4/1.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CarFriendDockView.h"
#define KCOLOR(a,b,c) [UIColor colorWithRed:(a)/255.0 green:(b)/255.0 blue:(c)/255.0 alpha:1]
#define kNubLabelWH 10
#define kNubLabelY 3
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
    [item setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [item setBackgroundImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
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
        dockitem.frame = CGRectMake(self.frame.size.width/2*i, 0, self.frame.size.width/2,self.frame.size.height);
        [dockitem setTitleColor:KCOLOR(253, 137, 22) forState:UIControlStateNormal];
        [dockitem setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [dockitem addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
    }
    if (itemcount == 1) {
        _selectedItem = item;
        [self itemClick:item];
    }
    if ([title isEqualToString:@"联系人"]) {
//        self.chatNubLabel=[Utils labelWithFrame:CGRectMake(self.frame.size.width/2-kNubLabelWH-kNubLabelY, kNubLabelY, kNubLabelWH, kNubLabelWH) withTitle:@"5" titleFontSize:kFontOfSize(8) textColor:[UIColor whiteColor] backgroundColor:[UIColor redColor] alignment:NSTextAlignmentCenter hidden:NO];
        self.chatNubLabel=[Utils labelWithFrame:CGRectMake(self.frame.size.width/2-kNubLabelWH-kNubLabelY, kNubLabelY, kNubLabelWH, kNubLabelWH) withTitle:@"5" titleFontSize:kFontOfSize(8) textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
        self.chatNubLabel.backgroundColor = [UIColor redColor];
        [self addSubview:self.chatNubLabel];
        
        [Utils setViewRiders:self.chatNubLabel riders:kNubLabelWH/2];
        
//        self.contactLabel=[Utils labelWithFrame:CGRectMake(self.frame.size.width-kNubLabelWH-kNubLabelY, kNubLabelY, kNubLabelWH, kNubLabelWH) withTitle:@"5" titleFontSize:kFontOfSize(8) textColor:[UIColor whiteColor] backgroundColor:[UIColor redColor] alignment:NSTextAlignmentCenter hidden:NO];
        self.contactLabel=[Utils labelWithFrame:CGRectMake(self.frame.size.width-kNubLabelWH-kNubLabelY, kNubLabelY, kNubLabelWH, kNubLabelWH) withTitle:@"5" titleFontSize:kFontOfSize(8) textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
        self.contactLabel.backgroundColor = [UIColor redColor];
        [self addSubview:self.contactLabel];
        [Utils setViewRiders:self.contactLabel riders:kNubLabelWH/2];
        self.chatNubLabel.hidden=YES;
        self.contactLabel.hidden=YES;
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
-(void)carFriendDockContactListNubChange:(NSString*)contactNub
{
    if (contactNub.length) {
        self.contactLabel.text=contactNub;
        self.contactLabel.hidden=NO;
    }else{
        self.contactLabel.hidden=YES;
        self.contactLabel.text=@"";
    }
}
-(void)carFriendDockChatListNubChange:(NSString*)contactNub
{
    if (contactNub.length) {
        self.chatNubLabel.text=contactNub;
        self.chatNubLabel.hidden=NO;
    }else{
        self.chatNubLabel.hidden=YES;
        self.chatNubLabel.text=@"";
    }
}

@end
