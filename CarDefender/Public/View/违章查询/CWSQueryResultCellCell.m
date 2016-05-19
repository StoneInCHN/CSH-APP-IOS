//
//  CWSQueryResultCellCell.m
//  LHPTextDemo
//
//  Created by 李散 on 15/6/30.
//  Copyright (c) 2015年 Mr Li. All rights reserved.
//

#import "CWSQueryResultCellCell.h"
//#import "UIImageView+WebCache.h"
#define kTO_LEFT_DISTANCE 10
#define KFIRST_TO_TOP_DISTANCE 15
#define KRIGHT_LABLE_TO_LEFT 97

#define kFONT_COLOR_BLUE [UIColor colorWithRed:67.0/255.0 green:154.0/255.0 blue:244.0/255.0 alpha:1]
#define kFONT_COLOR_BLACK [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]

@implementation CWSQueryResultCellCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setTypeDic:(NSDictionary *)typeDic
{
    _typeDic=typeDic;
    //创建一个view作为实质性的contentView，这个View的frame小于self，以达到间隔的视觉效果
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,320,0}];
    view.backgroundColor = [UIColor whiteColor];
    //违章项目
    CGSize size1 = [self takeSizeOf:@"违章项目" withFont:16 withWeight:10000];
    UILabel *firstL = [[UILabel alloc]initWithFrame:CGRectMake(kTO_LEFT_DISTANCE, KFIRST_TO_TOP_DISTANCE, size1.width, size1.height)];
    firstL.text = @"违章项目";
    firstL.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    firstL.textAlignment = NSTextAlignmentLeft;
    firstL.textColor = kFONT_COLOR_BLUE;
    [view addSubview:firstL];
    
    NSString*stringR =typeDic[@"first"];
    CGSize size2 = [self takeSizeOf:stringR withFont:16 withWeight:[UIScreen mainScreen].bounds.size.width-110];
    UILabel *firstR = [[UILabel alloc]initWithFrame:CGRectMake(KRIGHT_LABLE_TO_LEFT, KFIRST_TO_TOP_DISTANCE, [UIScreen mainScreen].bounds.size.width-110, size2.height)];
    firstR.text = stringR;
    firstR.numberOfLines = 0;
    firstR.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    firstR.textAlignment = NSTextAlignmentLeft;
    firstR.textColor = kFONT_COLOR_BLACK;
    [view addSubview:firstR];
    
    
    CGFloat yFloat=[self buildWith:@"发生时间" withDetailString:@"2013-12-29 11:57:29" withY:firstR.frame.size.height+firstR.frame.origin.y+30 withView:view];
    CGFloat yFloat1=[self buildWith:@"发生地点" withDetailString:@"316省道53KM+200M" withY:yFloat withView:view];
    CGFloat yFloat2=[self buildWith:@"预计扣分" withDetailString:@"6分" withY:yFloat1 withView:view];
    CGFloat yFloat3=[self buildWith:@"预计罚款" withDetailString:@"100" withY:yFloat2 withView:view];
    
    CGRect viewFrame = view.frame;
    viewFrame.size.height = yFloat3+size1.height-KFIRST_TO_TOP_DISTANCE;
    view.frame = viewFrame;
    [self.contentView addSubview:view];
}
-(CGFloat)buildWith:(NSString*)firstName withDetailString:(NSString*)detailString withY:(CGFloat)originalY withView:(UIView*)view
{
    CGFloat Yfloat;
    CGSize size1 = [self takeSizeOf:@"违章项目" withFont:16 withWeight:275];
    UILabel *firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(kTO_LEFT_DISTANCE, originalY, size1.width, size1.height)];
    firstLabel.text = firstName;
    firstLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    firstLabel.textAlignment = NSTextAlignmentLeft;
    firstLabel.textColor = kFONT_COLOR_BLUE;
    [view addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(KRIGHT_LABLE_TO_LEFT, originalY, [UIScreen mainScreen].bounds.size.width-110, size1.height)];
    secondLabel.backgroundColor=[UIColor whiteColor];
    secondLabel.text = detailString;
    secondLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    secondLabel.textAlignment = NSTextAlignmentLeft;
    secondLabel.textColor = kFONT_COLOR_BLACK;
    [view addSubview:secondLabel];
    Yfloat = firstLabel.frame.size.height+originalY+30;
    return Yfloat;
}
-(CGSize)takeSizeOf:(NSString*)string withFont:(CGFloat)fontFloat withWeight:(CGFloat)weightFloat
{
    
    CGSize stringOfSize=[string boundingRectWithSize:CGSizeMake(weightFloat, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:fontFloat]} context:nil].size;
    return stringOfSize;
}
+ (CGFloat)heightForCellWithContentForCellDict:(NSDictionary*)typeDic
{
    CGFloat height=0;
    height=height+15;
    CGSize stringOfSize=[typeDic[@"first"] boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-110, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:16]} context:nil].size;
    height=height+stringOfSize.height+30;
    CGSize stringOfSize1=[@"发生地点" boundingRectWithSize:CGSizeMake(275, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:16]} context:nil].size;
    height=height+stringOfSize1.height*4+3*30+15;
    return height;
}

@end
