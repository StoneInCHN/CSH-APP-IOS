//
//  CWSMessageCell.m
//  列表多选操作
//
//  Created by 李散 on 15/6/1.
//  Copyright (c) 2015年 Mr Li. All rights reserved.
//

#import "CWSMessageCell.h"

@implementation CWSMessageCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void)setCellDic:(NSDictionary *)cellDic
{
    [Utils setViewRiders:self.leftUnreadView riders:5];
    
    self.warningTitle.text=cellDic[@"title"];
    self.warningtime.text=[self setTimeWithString:cellDic[@"time"]];
    self.warningMsg.text=cellDic[@"content"];
    if ([cellDic[@"isRead"] intValue]==0) {
        self.leftUnreadView.hidden=NO;
    }else{
        self.leftUnreadView.hidden=YES;
    }
}
//-(NSString*)setTitleWithString:(NSString *)type
//{
//    NSString*title;
//    NSDictionary*typeDic=@{@"1":@"非法启动",@"2":@"非法振动",@"3":@"obd故障报警",@"4":@"水温异常报警",@"5":@"超速报警",@"6":@"碰撞告警",@"7":@"侧翻告警",@"8":@"车辆启动",@"9":@"车辆熄火",@"10":@"解绑通知",@"11":@"保养通知"};
//    title=[typeDic objectForKey:type];
//    return title;
//}
-(NSString*)setTimeWithString:(NSString *)time
{
    NSString *timeString;
    
    NSString*nowString=[NSString stringWithFormat:@"%@-%@-%@",[Utils getTime][0],[Utils getTime][1],[Utils getTime][2]];

    NSString*cellTimeString=[NSString stringWithFormat:@"%@-%@-%@",[time substringWithRange:NSMakeRange(0, 4)],[time substringWithRange:NSMakeRange(5, 2)],[time substringWithRange:NSMakeRange(8, 2)]];
    MyLog(@"\n%@\n%@",nowString,cellTimeString);
    if ([nowString isEqualToString:cellTimeString]) {
        timeString = [time substringWithRange:NSMakeRange(11, 5)];
    }else{
        timeString = [time substringWithRange:NSMakeRange(5, 5)];
    }
    return timeString;
}
@end
