//
//  DailyCalendarView.m
//  Deputy
//
//  Created by Caesar on 30/10/2014.
//  Copyright (c) 2014 Caesar Li
//
#import "DailyCalendarView.h"
#import "NSDate+CL.h"
#import "UIColor+CL.h"
#define kCOLOR(a,b,c) [UIColor colorWithRed:(a)/255.0 green:(b)/255.0 blue:(c)/255.0 alpha:1]
@interface DailyCalendarView()
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *dateLabelContainer;
@end


#define DATE_LABEL_SIZE 28
#define DATE_LABEL_FONT_SIZE 13

@implementation DailyCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:self.dateLabelContainer];
        
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dailyViewDidClick:)];
        [self addGestureRecognizer:singleFingerTap];
    }
    return self;
}
-(UIView *)dateLabelContainer
{
    if(!_dateLabelContainer){
        float x = (self.bounds.size.width - DATE_LABEL_SIZE)/2;
        _dateLabelContainer = [[UIView alloc] initWithFrame:CGRectMake(x, 0, DATE_LABEL_SIZE, DATE_LABEL_SIZE)];
        _dateLabelContainer.backgroundColor = [UIColor clearColor];
        _dateLabelContainer.layer.cornerRadius = DATE_LABEL_SIZE/2;
        _dateLabelContainer.clipsToBounds = YES;
        [_dateLabelContainer addSubview:self.dateLabel];
    }
    return _dateLabelContainer;
}
-(UILabel *)dateLabel
{
    if(!_dateLabel){
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DATE_LABEL_SIZE, DATE_LABEL_SIZE)];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textColor = kCOLOR(253, 127, 22);
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = [UIFont systemFontOfSize:DATE_LABEL_FONT_SIZE];
    }
    return _dateLabel;
}

-(void)setDate:(NSDate *)date
{
    _date = date;
    
    [self setNeedsDisplay];
}
-(void)setBlnSelected: (BOOL)blnSelected
{
    _blnSelected = blnSelected;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    self.dateLabel.text = [self.date getDateOfMonth];
}

-(void)markSelected:(BOOL)blnSelected
{
    //    DLog(@"mark date selected %@ -- %d",self.date, blnSelected);
    if([self.date isDateToday]){
        self.dateLabelContainer.backgroundColor = (blnSelected)?kMainColor: [UIColor clearColor];
        
        self.dateLabel.textColor = (blnSelected)?[UIColor whiteColor]:kMainColor;
    }else{
        self.dateLabelContainer.backgroundColor = (blnSelected)?kMainColor: [UIColor clearColor];

        self.dateLabel.textColor = (blnSelected)?[UIColor whiteColor]:[UIColor lightGrayColor];//(blnSelected)?[UIColor whiteColor]:[self colorByDate];
    }//kCOLOR(253, 127, 22)
    
}
-(UIColor *)colorByDate
{
    return [self.date isPastDate]?[UIColor whiteColor]:[UIColor colorWithHex:0x7BD1FF];
}

-(void)dailyViewDidClick: (UIGestureRecognizer *)tap
{
    [self.delegate dailyCalendarViewDidSelect: self.date];
    MyLog(@"%@",self.date);
}
@end
