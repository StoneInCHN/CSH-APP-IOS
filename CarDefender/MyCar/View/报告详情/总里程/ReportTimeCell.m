//
//  ReportTimeCell.m
//  报告动画
//
//  Created by 李散 on 15/5/27.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "ReportTimeCell.h"
#import "Define.h"
@implementation ReportTimeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void)setDicMsg:(NSDictionary *)dicMsg
{
    if (kSizeOfScreen.height>600) {
        self.timeLabel.font=kFontOfSize(14);
        self.endTimeLabel.font=kFontOfSize(14);
    }else{
        self.timeLabel.font=kFontOfSize(12);
        self.endTimeLabel.font=kFontOfSize(12);
    }
    NSArray*array=[self stringWihtTime:dicMsg];
    self.timeLabel.text=array[0];
    self.endTimeLabel.text=array[1];
    self.selectionStyle = UITableViewCellSelectionStyleGray;
}
-(NSArray*)stringWihtTime:(NSDictionary*)timeDic
{
    NSString*string;
    int hourInt=(int)[timeDic[@"start"] integerValue]/3600;
    int minInt=(int)[timeDic[@"start"] integerValue]%3600/60;
    NSString*hour;
    if (hourInt<10) {
        hour=[NSString stringWithFormat:@"0%d",hourInt];
    }else
        hour=[NSString stringWithFormat:@"%d",hourInt];
    NSString*min;
    if (minInt<10) {
        min=[NSString stringWithFormat:@"0%d",minInt];
    }else
        min=[NSString stringWithFormat:@"%d",minInt];
    
    string=[NSString stringWithFormat:@"%@:%@",hour,min];
    
    NSString*endString;
    int hourInt1=(int)[timeDic[@"end"] integerValue]/3600;
    int minInt1=(int)[timeDic[@"end"] integerValue]%3600/60;
    NSString*hour1;
    if (hourInt1<10) {
        hour1=[NSString stringWithFormat:@"0%d",hourInt1];
    }else
        hour1=[NSString stringWithFormat:@"%d",hourInt1];
    NSString*min1;
    if (minInt1<10) {
        min1=[NSString stringWithFormat:@"0%d",minInt1];
    }else
        min1=[NSString stringWithFormat:@"%d",minInt1];
    
    endString=[NSString stringWithFormat:@"%@:%@",hour1,min1];
    
    
    return @[string,endString];
}
@end
