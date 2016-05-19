//
//  CarFriendTypeCell.m
//  CarDefender
//
//  Created by 李散 on 15/5/13.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CarFriendTypeCell.h"
#import "UIImageView+WebCache.h"
#define kTimeDisHeight 5
#define kBaseViewDisHeight 40
@implementation CarFriendTypeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)setTypeDic:(NSDictionary *)typeDic
{
    _typeDic=typeDic;
    //创建一个view作为实质性的contentView，这个View的frame小于self，以达到间隔的视觉效果
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,320,0}];
    view.backgroundColor = kCOLOR(242, 242, 242);
    
    //创建一个label用于显示discrible----------------------------------------------------
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){111,kTimeDisHeight*2,99,20}];
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = kFontOfSize(15);
    label.textColor=KBlackMainColor;
    label.text=[self getTimeWithString:typeDic[@"time"]];
    label.backgroundColor=[UIColor colorWithRed:143/255.0 green:143/255.0 blue:143/255.0 alpha:0.6];
    [view addSubview:label];
    [Utils setViewRiders:label riders:10];
    
    UIView*baseView;
    if ([typeDic[@"h"] integerValue]) {
        CGFloat height;
        if ([typeDic[@"w"] intValue]>280) {
            height=[typeDic[@"h"] intValue]*280/[typeDic[@"w"] intValue];
        }else{
            height=[typeDic[@"h"] intValue];
        }
        baseView=[[UIView alloc]initWithFrame:CGRectMake(10, 40, 300, 125+height-40)];
    }else{
        baseView=[[UIView alloc]initWithFrame:CGRectMake(10, 40, 300, 125-10)];
    }
    baseView.backgroundColor=[UIColor whiteColor];
    UILabel*titleLabel= [Utils labelWithFrame:CGRectMake(14, 8, 276, 21) withTitle:typeDic[@"title"] titleFontSize:kFontOfSize(16) textColor:kTextBlackColor alignment:NSTextAlignmentLeft];
    [baseView addSubview:titleLabel];
    
    if ([typeDic[@"h"] intValue]) {
        CGFloat weight;
        CGFloat height;
        if ([typeDic[@"w"] intValue]>280) {
            weight=280;
            height=[typeDic[@"h"] intValue]*280/[typeDic[@"w"] intValue];
        }else{
            weight=[typeDic[@"w"] intValue];
            height=[typeDic[@"h"] intValue];
        }
        UIImageView*imgeView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 40, weight, height)];
        [imgeView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://115.28.161.11:8080/XAI/appDownLoad/downLoadPhoto?path=%@",typeDic[@"pic"]]] placeholderImage:[UIImage imageNamed:@"servicezhanwei"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
        [baseView addSubview:imgeView];
        
        UIView*lineVIew=[[UIView alloc]initWithFrame:CGRectMake(10, 10+imgeView.frame.size.height+imgeView.frame.origin.y, 300, 1)];
        lineVIew.backgroundColor=kCOLOR(242, 242, 242);
        [baseView addSubview:lineVIew];
        
        UILabel*contentLabel=[Utils labelWithFrame:CGRectMake(10, lineVIew.frame.size.height+lineVIew.frame.origin.y+10, 280, 20) withTitle:@"阅读全文" titleFontSize:kFontOfSize(16) textColor:kTextBlackColor alignment:NSTextAlignmentLeft];
        [baseView addSubview:contentLabel];
        
        UIImageView*rightImg=[Utils imageViewWithFrame:CGRectMake(282, contentLabel.frame.origin.y+4, 8, 13) withImage:[UIImage imageNamed:@"infor_jiantou.png"]];
        [baseView addSubview:rightImg];
        
        
    }else{
        UIView*lineVIew=[[UIView alloc]initWithFrame:CGRectMake(10,30, 300, 1)];
        lineVIew.backgroundColor=kCOLOR(242, 242, 242);
        [baseView addSubview:lineVIew];
        
        UILabel*contentLabel=[Utils labelWithFrame:CGRectMake(10, lineVIew.frame.size.height+lineVIew.frame.origin.y+10, 280, 20) withTitle:@"阅读全文" titleFontSize:kFontOfSize(16) textColor:kTextBlackColor alignment:NSTextAlignmentLeft];
        [baseView addSubview:contentLabel];
        
        UIImageView*rightImg=[Utils imageViewWithFrame:CGRectMake(282, contentLabel.frame.origin.y+4, 8, 13) withImage:[UIImage imageNamed:@"infor_jiantou.png"]];
        [baseView addSubview:rightImg];
    }
    CGRect viewFrame=view.frame;
    viewFrame.size.height=baseView.frame.origin.y+baseView.frame.size.height;
    view.frame=viewFrame;
    [Utils setViewRiders:baseView riders:4];
    [view addSubview:baseView];
    [self.contentView addSubview:view];
    MyLog(@"%@\n%@",baseView,view);
}
-(NSString*)getTimeWithString:(NSString*)timeNub
{
    NSString*string1;
    //当天
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *currentfmt = [[NSDateFormatter alloc] init];
    currentfmt.dateFormat = @"yy-MM-dd"; // @"yyyy-MM-dd HH:mm:ss"
    NSString*currentTimeYear=[currentfmt stringFromDate:currentTime];
    
    
    long long int oldTime=[timeNub doubleValue];
    NSString * timeStampString = [NSString stringWithFormat:@"%lld",oldTime];
    NSTimeInterval _interval=[[timeStampString substringToIndex:10] doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yy-MM-dd"; // @"yyyy-MM-dd HH:mm:ss"
    NSString *timeYear = [fmt stringFromDate:date];
    
    fmt.dateFormat=@"HH:mm";
    NSString*time1=[fmt stringFromDate:date];
    if ([currentTimeYear isEqualToString:timeYear]) {
        
        string1=[NSString stringWithFormat:@"今天 %@",time1];
    }else{
        oldTime +=86400;
        NSTimeInterval _interval=oldTime;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yy-MM-dd"; // @"yyyy-MM-dd HH:mm:ss"
        NSString *timeYear1 = [fmt stringFromDate:date];
        if ([timeYear1 isEqualToString:currentTimeYear]) {
            string1=[NSString stringWithFormat:@"昨天 %@",time1];
        }else{
            fmt.dateFormat = @"MM-dd HH:mm"; // @"yyyy-MM-dd HH:mm:ss"
            NSString *timeYear = [fmt stringFromDate:date];
            string1=timeYear;
        }
    }
    
    return string1;
}
+ (CGFloat)heightForCellWithContentForCellDict:(NSDictionary*)typeDic
{
    CGFloat height=0;
    
    height=height+kBaseViewDisHeight*2;

    CGFloat imgHeight;
    if ([typeDic[@"h"] integerValue]) {
    if ([typeDic[@"w"] intValue]>280) {
        imgHeight=[typeDic[@"h"] intValue]*280/[typeDic[@"w"] intValue];
    }else{
        imgHeight=[typeDic[@"h"] intValue];
    }
    }else{
        imgHeight=-10;
    }
    
    height=height+imgHeight;
    
    height+=10;
    
    height+=40;
    
    return height;
}
@end
