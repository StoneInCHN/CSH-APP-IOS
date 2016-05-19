//
//  CarFriendCell.m
//  CarDefender
//
//  Created by 李散 on 15/5/12.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CarFriendCell.h"
#import "UIImageView+WebCache.h"
@implementation CarFriendCell
-(void)setDicMsg:(NSDictionary *)dicMsg
{
    [Utils setViewRiders:self.unreadNubLabel riders:7];
    [Utils setViewRiders:self.baseView riders:4];
    self.typeLabel.text=dicMsg[@"type"];
    self.contentLabel.text=dicMsg[@"content"];
    if (![dicMsg[@"firstOrNo"] intValue]) {
        self.unreadNubLabel.hidden=YES;
    }
    [self.headImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://115.28.161.11:8080/XAI/appDownLoad/downLoadPhoto?path=%@",dicMsg[@"logo"]]] placeholderImage:[UIImage imageNamed:@"servicezhanwei.png"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
    [self getTimeWithString:dicMsg[@"time"]];
}
-(void)getTimeWithString:(NSString*)timeNub
{
    //当天
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *currentfmt = [[NSDateFormatter alloc] init];
    currentfmt.dateFormat = @"yy-MM-dd"; // @"yyyy-MM-dd HH:mm:ss"
    NSString*currentTimeYear=[currentfmt stringFromDate:currentTime];
    
    long long int oldTime=[timeNub doubleValue]/1000;
    NSString * timeStampString = [NSString stringWithFormat:@"%lld",oldTime];
    NSTimeInterval _interval=[[timeStampString substringToIndex:10] doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yy-MM-dd"; // @"yyyy-MM-dd HH:mm:ss"
    NSString *timeYear = [fmt stringFromDate:date];
    
    fmt.dateFormat=@"HH:mm";
    NSString*time1=[fmt stringFromDate:date];
    if ([currentTimeYear isEqualToString:timeYear]) {
        
        self.timeLabel.text=[NSString stringWithFormat:@"今天 %@",time1];
    }else{
        oldTime +=86400;
        NSTimeInterval _interval=oldTime;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yy-MM-dd"; // @"yyyy-MM-dd HH:mm:ss"
         NSString *timeYear1 = [fmt stringFromDate:date];
        if ([timeYear1 isEqualToString:currentTimeYear]) {
            self.timeLabel.text=[NSString stringWithFormat:@"昨天 %@",time1];
        }else{
            oldTime -=86400;
            NSTimeInterval _interval=oldTime;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
            fmt.dateFormat = @"MM-dd HH:mm"; // @"yyyy-MM-dd HH:mm:ss"
            NSString *timeYear = [fmt stringFromDate:date];
            self.timeLabel.text=timeYear;
        }
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
