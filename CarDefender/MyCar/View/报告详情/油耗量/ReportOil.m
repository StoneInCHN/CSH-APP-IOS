//
//  ReportOil.m
//  报告动画
//
//  Created by 周子涵 on 15/5/13.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "ReportOil.h"

#define kImageWidth 120
#define kImageHight 122
#define kInterval 10
#define kRatio 0.62
#define kTopRatio 0.7
#define kTopHight self.frame.size.height * (1-kRatio)

@implementation ReportOil

- (id)initWithFrame:(CGRect)frame Dictionary:(NSDictionary*)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"ReportOil" owner:self options:nil][0];
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        self.testDate = @{@"surlus":@"60",
                          @"today":@"40",
                          @"total":@"200"};
        self.data = dic;
//        [self drawImage];
        [self creatTop];
        [self creatBottom];
    }
    return self;
}
-(void)reloadData:(NSDictionary*)dic{
    if ([dic[@"data"][@"status"] isEqualToString:@"0"]) {
        _noDataView.hidden = NO;
        NSDictionary* bottomDic = [self getBottomDic:nil];
        [_reportBottomView reloadData:bottomDic];return;
    }else{
        _noDataView.hidden = YES;
    }
    self.data = dic;
    _markLabel.text = dic[@"data"][@"oil"];
    NSDictionary* bottomDic = [self getBottomDic:dic[@"data"]];
    [_reportBottomView reloadData:bottomDic];
}
-(void)creatNoDataView{
    if (_noDataView == nil) {
        _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height*(1-kRatio))];
        _noDataView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_noDataView];
        UIImageView* imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, kImageWidth, kImageHight)];
        imageView1.image = [UIImage imageNamed:@"youhao_icon1-1"];
        imageView1.center = _noDataView.center;
        [_noDataView addSubview:imageView1];
        UILabel* markLabel = [Utils labelWithFrame:CGRectMake(0, 0, self.frame.size.width-40, _noDataView.frame.size.height*0.8) withTitle:@"暂无数据,请检测您的设备是否正常工作" titleFontSize:kFontOfSize(13) textColor:[UIColor grayColor] alignment:NSTextAlignmentCenter];
        markLabel.backgroundColor = kCOLOR(245, 245, 245);
        markLabel.center = _noDataView.center;
        [_noDataView addSubview:markLabel];
    }else{
        _noDataView.hidden = NO;
    }
}
-(void)creatTop{
    
    [self drawImage];
//    UILabel* lLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kTopHight, kSizeOfScreen.width, 1)];
//    lLabel.backgroundColor = [UIColor darkGrayColor];
//    [self addSubview:lLabel];
    
    UILabel* lLabel1 = [[UILabel alloc] init];
    [lLabel1 setFrame:CGRectMake(0, kTopHight * kTopRatio + 24, kSizeOfScreen.width, 20)];
    lLabel1.font = kFontOfSize(10);
    lLabel1.text = @"点击图形可以了解最高时速详情";
    lLabel1.textColor = [UIColor darkGrayColor];
    lLabel1.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lLabel1];
    
    if ([self.data[@"data"][@"status"] isEqualToString:@"0"]) {
        [self creatNoDataView];
        return;
    }
}
-(NSDictionary*)getBottomDic:(NSDictionary*)dic{
    if (dic == nil) {
        NSDictionary* bottomDic = @{@"title":@"当日油耗为",
                                    @"value":@"0",
                                    @"content":[[NSMutableAttributedString alloc] initWithString:@""],
                                    @"mark":@"",
                                    @"sharecontent":@""};
        return bottomDic;
    }
    NSString* stringDesc = [NSString stringWithFormat:@"击败了全国%@的车友",dic[@"percent"]];
    NSRange range1=[stringDesc rangeOfString:@"击败了全国"];
    NSRange range2=[stringDesc rangeOfString:@"的车友"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:stringDesc];
    [str addAttribute:NSForegroundColorAttributeName value:KBlackMainColor range:NSMakeRange(range1.location,range1.length)];
    [str addAttribute:NSForegroundColorAttributeName value:KBlackMainColor range:NSMakeRange(range2.location,range2.length)];
    
    NSString* markStr;
    if ([dic[@"oil"] floatValue] < 4) {
        markStr = @"节能减排，我做贡献";
    }else if ([dic[@"oil"] floatValue] < 16){
        markStr = @"晒晒太阳兜兜风，我的生活在路上";
    }else{
        markStr = @"两桶油算啥，我养活的";
    }
    NSDictionary* bottomDic = @{@"title":@"当日油耗为",
                                @"value":[NSString stringWithFormat:@"%@L",dic[@"oil"]],
                                @"content":str,
                                @"mark":markStr,
                                @"sharecontent":[NSString stringWithFormat:@"当日油耗为%@%@%@",[NSString stringWithFormat:@"%@L",dic[@"oil"]],stringDesc,markStr],
                                @"url":dic[@"shareUrl"],
                                @"imgUrl":dic[@"shareIcon"]};
    return bottomDic;
}
-(void)creatBottom{
    NSDictionary* dic;
    if ([self.data[@"data"][@"status"] isEqualToString:@"0"]) {
        dic = [self getBottomDic:nil];
    }else{
        dic = [self getBottomDic:self.data[@"data"]];
    }
    _reportBottomView = [[ReportContentView alloc] initWithFrame:CGRectMake(0, self.frame.size.height*(1-kRatio), self.frame.size.width, self.frame.size.height*kRatio) Dictionary:dic];
    [self addSubview:_reportBottomView];
}
-(void)drawImage{
    UIImageView* imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - kImageWidth/2 , kTopHight * kTopRatio + 26  - kImageHight, kImageWidth, kImageHight)];
    imageView1.image = [UIImage imageNamed:@"youhao_icon3-1"];
    [self addSubview:imageView1];
    
    _surplusH = [self.testDate[@"surlus"] floatValue] / [self.testDate[@"total"] floatValue] * kImageHight;
    UIImageView* imageView2 = [self creatImageView:_surplusH frame:CGRectMake(self.frame.size.width/2 - kImageWidth/2 , kTopHight * kTopRatio + 26 - kImageHight, kImageWidth, kImageHight - _surplusH) image:[UIImage imageNamed:@"youhao_icon2-1"]];
    [self addSubview:imageView2];
    
    _todayH = ([self.testDate[@"surlus"] floatValue] + [self.testDate[@"today"] floatValue])/ [self.testDate[@"total"] floatValue] * kImageHight;
    UIImageView* imageView3  = [self creatImageView:_todayH frame:CGRectMake(self.frame.size.width/2 - kImageWidth/2 , kTopHight * kTopRatio + 26 - kImageHight, kImageWidth, kImageHight - _todayH) image:[UIImage imageNamed:@"youhao_icon1-1"]];
    [self addSubview:imageView3];
    
    [self setMarkView:CGPointMake(self.frame.size.width/2 - 102/2 - 4, kTopHight * kTopRatio + 26 -  _todayH + (_todayH - _surplusH)/2) title:[NSString stringWithFormat:@"%@L",self.data[@"data"][@"oil"]]];
    [self addSubview:_markView];
    [self creatSelectedView:_todayH surplusH:_surplusH];
    [self creatBtn:CGRectMake(self.frame.size.width/2 - 102/2, kTopHight * kTopRatio + 26 - _todayH , 75, _todayH - _surplusH) tag:1 title:@"今日油量"];
    [self creatBtn:CGRectMake(self.frame.size.width/2 - 102/2, kTopHight * kTopRatio + 26 - _surplusH , 75, _surplusH) tag:2 title:@"剩余油量"];
}
#pragma mark - 创建油量按钮
-(void)creatBtn:(CGRect)frame tag:(int)tag title:(NSString*)title{
    UIButton* lBtn = [[UIButton alloc] initWithFrame:frame];
    lBtn.tag = tag;
    [lBtn setTitle:title forState:UIControlStateNormal];
    lBtn.titleLabel.font = kFontOfSize(12);
    [lBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lBtn];
}
#pragma mark - 设置切好的ImageView
-(UIImageView*)creatImageView:(CGFloat)mark frame:(CGRect)frame image:(UIImage*)image{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:frame];
    CGRect rect1 = CGRectMake(0, 0, kImageWidth*2, (kImageHight - mark)*2);
    CGImageRef imageRef=CGImageCreateWithImageInRect([image CGImage],rect1);
    UIImage *lImage=[UIImage imageWithCGImage:imageRef];
    imageView.image = lImage;
    return imageView;
}
#pragma mark - 设置选中框
-(void)creatSelectedView:(CGFloat)todayH surplusH:(CGFloat)surplusH{
    CGRect frame = CGRectMake(self.frame.size.width/2 - 102/2 - 2, kTopHight * kTopRatio + 26 - todayH - 1, 106, todayH - surplusH + 2);
//    UIView* lView = [[UIView alloc] initWithFrame:CGRectMake(1, 1, frame.size.width, frame.size.height)];
//    lView.backgroundColor = [UIColor clearColor];
//    [self setBianKuang:[UIColor whiteColor] Wide:1 view:lView];
//    [self setViewRiders:lView riders:4];
//    
////    frame.origin.x -= 1;
////    frame.origin.y -= 1;
//    frame.size.width += 2;
//    frame.size.height += 2;
    
    _selectedView = [[UIView alloc] initWithFrame:frame];
    _selectedView.backgroundColor = [UIColor clearColor];
    [Utils setBianKuang:kMainColor Wide:1 view:_selectedView];
    [Utils setViewRiders:_selectedView riders:4];
    [self addSubview:_selectedView];
}
-(void)btnClick:(UIButton*)sender{
    _markView.hidden = YES;
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _selectedView.frame;
        if (sender.tag == 1) {
            frame.origin.y = kTopHight * kTopRatio + 26 - _todayH - 1;
            frame.size.height = _todayH - _surplusH + 2;
        }else{
            frame.origin.y = kTopHight * kTopRatio + 26 - _surplusH -1;
            frame.size.height = _surplusH ;
        }
        _selectedView.frame = frame;
    } completion:^(BOOL finished) {
        
        if (sender.tag == 1) {
            [self setMarkView:CGPointMake(_selectedView.frame.origin.x - 2, kTopHight * kTopRatio + 26 -  _todayH + (_todayH - _surplusH)/2) title:self.data[@"data"][@"oil"]];
        }else{
            [self setMarkView:CGPointMake(_selectedView.frame.origin.x - 2, kTopHight * kTopRatio + 26 -  _surplusH/2) title:self.data[@"data"][@"surplus"]];
        }
        _markView.hidden = NO;
    }];
}
-(void)setMarkView:(CGPoint)point title:(NSString*)title{
    [_markView setFrame:CGRectMake(point.x - _markView.frame.size.width, point.y - _markView.frame.size.height, _markView.frame.size.width, _markView.frame.size.height)];
    _markLabel.text = title;
}

#pragma mark - 动画开始
-(void)animateStart{
    NSLog(@"油耗动画开始");
}

@end
