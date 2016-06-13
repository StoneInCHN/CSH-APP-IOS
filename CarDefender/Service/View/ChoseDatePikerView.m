//
//  ChoseDatePikerView.m
//  CarDefender
//
//  Created by DRiPhion on 16/6/7.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "ChoseDatePikerView.h"


@implementation ChoseDatePikerView{
    UIDatePicker *datePicker;
    UILabel * dateLabel;
    UILabel * timeLabel;
    NSInteger timeInterval; //时间差
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self createUI];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
    
}
-(void)createUI{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    headerView.backgroundColor = KGrayColor2;
    headerView.clipsToBounds = NO;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:headerView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = headerView.bounds;
    maskLayer.path = maskPath.CGPath;
    headerView.layer.mask = maskLayer;
    [self addSubview:headerView];
    
    //选择日期
    UILabel *chooseTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, self.frame.size.width-80, 20)];
    chooseTimeLable.text = @"选择日期";
    chooseTimeLable.textColor = [UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1.0];
    chooseTimeLable.textAlignment = NSTextAlignmentCenter;
    
    [headerView addSubview:chooseTimeLable];
    
    UIButton * cancel = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 50, 30)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    //cancel.layer.borderWidth = 1;
    cancel.layer.borderColor = kMainColor.CGColor;
    [cancel addTarget:self action:@selector(doPickerUpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cancel.tag=101;
    cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancel setTitleColor:kMainColor forState:UIControlStateNormal];
    cancel.layer.cornerRadius = 3;
    [headerView addSubview:cancel];
    
    UIButton * sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-60, 5, 50, 30)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    //sureBtn.layer.borderWidth = 1;
    sureBtn.layer.borderColor = kMainColor.CGColor;
    [sureBtn addTarget:self action:@selector(doPickerUpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.tag =102;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    sureBtn.layer.cornerRadius = 3;
    [sureBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    sureBtn.titleLabel.textColor = kMainColor;
    [headerView addSubview:sureBtn];
    
    //创建date label
    
    UILabel * dateLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(20, headerView.frame.size.height+10, 40, 20)];
    dateLabel1.text = @"日期";
    [self addSubview:dateLabel1];
    
    dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, headerView.frame.size.height+10, self.frame.size.width-60, 20)];
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.textColor = kMainColor;
    [self addSubview:dateLabel];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, dateLabel.frame.origin.y+dateLabel.frame.size.height+10, self.frame.size.width, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line1];
    
    UIButton *chooseDa = [[UIButton alloc]initWithFrame:CGRectMake(60, headerView.frame.size.height+5, self.frame.size.width-50, 30)];
    [chooseDa addTarget:self action:@selector(chooseDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    chooseDa.tag = 110;
    [self addSubview:chooseDa];
    
    //创建 time label
    
    UILabel * timeLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(20, line1.frame.origin.y+11, 40, 20)];
    timeLabel1.text = @"时间";
    [self addSubview:timeLabel1];
    
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, line1.frame.origin.y+11, self.frame.size.width-60, 20)];
    timeLabel.textColor = kMainColor;
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:timeLabel];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, timeLabel.frame.origin.y+timeLabel.frame.size.height+10, self.frame.size.width, 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line2];
    
    UIButton *chooseTi = [[UIButton alloc]initWithFrame:CGRectMake(60, line1.frame.origin.y+5, self.frame.size.width-50, 30)];
    [chooseTi addTarget:self action:@selector(chooseDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    
    chooseTi.tag = 120;
    [self addSubview:chooseTi];
    
    //创建  datepicker
    
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, line2.frame.origin.y+5, self.frame.size.width-10, 160)];
    [self addSubview:datePicker];
    datePicker.datePickerMode=UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    //默认日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *now = [NSDate date];
    dateLabel.text = [formatter stringFromDate:now];
    
    
    
    //默认时间
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"HH:mm"];
    
    timeLabel.text = [formatter1 stringFromDate:now];
    
}
-(void)doPickerUpBtnClick:(UIButton*)sender{
    
    [self removeFromSuperview];
    if (sender.tag == 102) {
        [self.delegate sureBtnCommitOrderButton:sender goodDic:self.goodDic ];
    }
    
}

-(void)chooseDatePicker:(UIButton*)sender{
    
}

-(void)dateChanged:(UIDatePicker*)sender
{
    NSDate*date1=(NSDate*)sender.date;
    
    
    NSDate *now = [NSDate date];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"YYYYMMddHHmm"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"HH:mm"];
    NSString *timechoose = [formatter1 stringFromDate:date1];
    NSString *timenow1 = [formatter1 stringFromDate:now];
    NSInteger i = [timechoose integerValue];
    NSInteger j = [timenow1 integerValue];
    
    
    timeInterval = i-j;
    NSString *dateStr = [NSString string];
    NSString *timeStr = [NSString string];
    if (timeInterval<0) {
        //        age=-1;
        [datePicker setDate:now animated:YES];
        dateStr = [formatter stringFromDate:now];
        timeStr = [formatter2 stringFromDate:now];
        
    }else{
        dateStr = [formatter stringFromDate:date1];
        timeStr = [formatter2 stringFromDate:date1];
        
    }
   
   
    if (timeInterval<0) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"选择日期不规范，请重新选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
    dateLabel.text=[NSString stringWithFormat:@"%@",dateStr];
    timeLabel.text = [NSString stringWithFormat:@"%@",timeStr];
}

@end
