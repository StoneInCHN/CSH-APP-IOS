//
//  ReportHundredOil.m
//  报告动画
//
//  Created by 周子涵 on 15/5/13.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "ReportHundredOil.h"

@implementation ReportHundredOil

- (id)initWithFrame:(CGRect)frame Dictionary:(NSDictionary*)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"ReportHundredOil" owner:self options:nil][0];
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        self.data = dic;
        _temp = 0;
        _topArray = [NSMutableArray array];
        [self creatTop];
        [self creatBottom];
    }
    return self;
}
-(NSDictionary*)getBottomDic:(NSDictionary*)dic{
    if (dic == nil) {
        NSDictionary* bottomDic = @{@"title":@"当日平均油耗为",
                                    @"value":@"0",
                                    @"content":[[NSMutableAttributedString alloc] initWithString:@""],
                                    @"mark":@"",
                                    @"sharecontent":@""};
        return bottomDic;
    }
    NSString* stringDesc = [NSString stringWithFormat:@"其中高耗部分占整个行程%@,击败了全国%@的车友",dic[@"highPercent"],dic[@"percent"]];
    NSRange range1=[stringDesc rangeOfString:@"其中高耗部分占整个行程"];
    NSRange range2=[stringDesc rangeOfString:@",击败了全国"];
    NSRange range3=[stringDesc rangeOfString:@"的车友"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:stringDesc];
    [str addAttribute:NSForegroundColorAttributeName value:KBlackMainColor range:NSMakeRange(range1.location,range1.length)];
    [str addAttribute:NSForegroundColorAttributeName value:KBlackMainColor range:NSMakeRange(range2.location,range2.length)];
    [str addAttribute:NSForegroundColorAttributeName value:KBlackMainColor range:NSMakeRange(range3.location,range3.length)];
    NSString* markStr;
    if ([dic[@"avgDay"] floatValue] < 8) {
        markStr = @"勤俭持家，感觉自己萌萌哒";
    }else if ([dic[@"avgDay"] floatValue] < 13){
        markStr = @"别跟我比红灯起步，你尾气都吃不到";
    }else{
        markStr = @"路虎算什么，他们都叫我油老虎";
    }
    NSDictionary* bottomDic = @{@"title":@"当日平均油耗为",
                                @"value":[NSString stringWithFormat:@"%@L/百公里",dic[@"avgDay"]],
                                @"content":str,
                                @"mark":markStr,
                                @"sharecontent":[NSString stringWithFormat:@"当日平均油耗为%@%@%@",[NSString stringWithFormat:@"%@Km/h",dic[@"avgDay"]],stringDesc,markStr],
                                @"url":dic[@"shareUrl"],
                                @"imgUrl":dic[@"shareIcon"]};
    return bottomDic;
}
-(NSDictionary*)getTopDic:(NSDictionary*)dic{
    NSMutableArray* array = [NSMutableArray array];
    for (NSDictionary* lDic in dic[@"list"]) {
        NSMutableDictionary* dataDic = [NSMutableDictionary dictionary];
        [dataDic setObject:lDic[@"maxCurrent"] forKey:@"top"];
        [dataDic setObject:lDic[@"avgCurrent"] forKey:@"bottom"];
        [dataDic setObject:lDic[@"start"] forKey:@"start"];
        [dataDic setObject:lDic[@"end"] forKey:@"end"];
        [dataDic setObject:lDic[@"startTime"] forKey:@"startTime"];
        [dataDic setObject:lDic[@"endTime"] forKey:@"endTime"];
//        NSMutableArray* mutArray = [NSMutableArray array];
//        for (NSDictionary* dic in lDic[@"list"]) {
//            NSMutableDictionary* mutDic = [NSMutableDictionary dictionary];
//            [mutDic setObject:dic[@"oil"] forKey:@"mark"];
//            [mutDic setObject:dic[@"status"] forKey:@"status"];
//            [mutDic setObject:dic[@"time"] forKey:@"time"];
//            [mutArray addObject:mutDic];
//        }
//        [dataDic setObject:mutArray forKey:@"list"];
        [array addObject:dataDic];
    }
    NSDictionary* topDic = @{@"array":array,
                             @"dic":@{@"topName":@"最高油耗",
                                      @"bottomName":@"平均油耗",
                                      @"max":@"20",
                                      @"mark":@"2"}};
    return topDic;
}
//-(void)creatMarkLabel{
//    if (_markLabel == nil) {
//        _markLabel = [Utils labelWithFrame:CGRectMake(kNormalWight , kNormalHight * 0.05, self.frame.size.width - 2*kNormalWight, kNormalHight * 0.9) withTitle:@"暂无数据,请检测您的设备是否正常工作" titleFontSize:kFontOfSize(13) textColor:[UIColor darkGrayColor] alignment:NSTextAlignmentCenter];
//        _markLabel.backgroundColor = kCOLOR(245, 245, 245);
//        [self addSubview:_markLabel];
//    }else{
//        _markLabel.hidden = NO;
//    }
//}

-(void)animateStart{
    NSLog(@"百公里油耗动画开始");
}
@end
