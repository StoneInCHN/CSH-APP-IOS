//
//  NewReportMileage.m
//  报告动画
//
//  Created by 李散 on 15/5/27.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "NewReportMileage.h"
#import "ReportTimeCell.h"
#import "Define.h"
#define kpercent 0.416
#define kTopPercent 0.7667
#define kTabelPercent 0.2413
#define kLeftORRight 10
@implementation NewReportMileage
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        _noData=YES;
        _firstGetIn=YES;
        hisAppearOrDisapp=YES;
        [self buildUIWithDicMsg:nil];
    }
    return self;
}
-(void)loadView
{
    
}
-(void)buildUIWithDicMsg:(NSDictionary*)dicMsg
{
    if (dicMsg!=nil) {
        _noData = ![dicMsg[@"status"] intValue];
    }
    //创建柱状试图
    [self buildTopViewWithDic:dicMsg];
    //创建底部试图
    [self buildDownViewWithDic:dicMsg];
}
#pragma mark - 创建柱状图试图
-(void)buildTopViewWithDic:(NSDictionary*)dicMsg
{
    //创建顶部view
    if (_topBaseView==nil) {
        _firstGetIn=NO;
        _topBaseView = [[UIView alloc]initWithFrame:CGRectMake(kLeftORRight, self.frame.size.height*kpercent*(1-kTopPercent)/2, self.frame.size.width-2*kLeftORRight, self.frame.size.height*kpercent*kTopPercent)];
        _topBaseView.backgroundColor=kCOLOR(242, 242, 242);
        _topBaseView.layer.masksToBounds = YES;
        _topBaseView.layer.cornerRadius = 4;
    }
    [self addSubview:_topBaseView];
    
    [self buildTimeLabel];
    //当没有数据时创建无数据label
    if (_noData) {
        if (_noDataLabel==nil) {
            _noDataLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _topBaseView.frame.size.width, _topBaseView.frame.size.height)];
            _noDataLabel.text=@"暂无数据，请检查您的设备是否正常工作";
            _noDataLabel.textAlignment=NSTextAlignmentCenter;
            _noDataLabel.textColor=[UIColor grayColor];
            _noDataLabel.font=kFontOfLetterBig;
        }
        [_topBaseView addSubview:_noDataLabel];
        _timeScrollView.hidden=YES;
//#warning 视图呈现问题
//        _topView = nil;
//        [_topView removeFromSuperview];
    }else{
        _timeScrollView.hidden=NO;
        //有数据时移除无数据label 并创建列表和绘图
        if (_noDataLabel!=nil) {
            [_noDataLabel removeFromSuperview];
        }
        //tableView build 建列表
        if (_tableView==nil) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(_topBaseView.frame.size.width*(1-kTabelPercent), 0, _topBaseView.frame.size.width*kTabelPercent, _topBaseView.frame.size.height)];
            _tableView.delegate=self;
            _tableView.dataSource=self;
            _tableView.backgroundColor=kCOLOR(242, 242, 242);
            [_tableView registerNib:[UINib nibWithNibName:@"ReportTimeCell" bundle:nil] forCellReuseIdentifier:@"reportID"];
            _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            _tableView.showsHorizontalScrollIndicator=NO;
            _tableView.showsVerticalScrollIndicator=NO;
        }
        [_topBaseView addSubview:_tableView];
        //创建scrollView
        if (_scrollView==nil) {
            _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _topBaseView.frame.size.width-_tableView.frame.size.width, _topBaseView.frame.size.height)];
            _scrollView.showsVerticalScrollIndicator=NO;
            _scrollView.showsHorizontalScrollIndicator=NO;
            _scrollView.delegate=self;
            _scrollView.contentSize=_scrollView.frame.size;
            _scrollView.bounces=NO;
        }
        [_topBaseView addSubview:_scrollView];
        //创建绘图view
        if (_topView==nil) {
            _topView = [[ReportTopView alloc]initWithFrame:CGRectMake(0, -2, _topBaseView.frame.size.width-_tableView.frame.size.width, _topBaseView.frame.size.height+2)];
            _topView.pointArray=_pointArray;
        }
        _topView.backgroundColor=kCOLOR(242, 242, 242);
        [_scrollView addSubview:_topView];
    }
    if (!_noData) {
        //tableView 刷新数据
        _tableArray=dicMsg[@"list"];
        [_tableView reloadData];
        _allTimeBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 42)];
        [_allTimeBtn setTitle:@"全部" forState:UIControlStateNormal];
        [_allTimeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _allTimeBtn.backgroundColor=kCOLOR(135, 135, 135);
        _allTimeBtn.titleLabel.font=kFontOfSize(14);
        [_allTimeBtn addTarget:self action:@selector(allTimeCanSee) forControlEvents:UIControlEventTouchUpInside];
        _tableView.tableHeaderView=_allTimeBtn;
        //柱状图view刷新数据
        _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width, 0);
        _scrollView.contentOffset=CGPointMake(0, 0);
        _topView.pointArray=_pointArray;
        _topView.topDicMsg=dicMsg;
    }
}
-(void)buildTimeLabel
{
    if (_timeScrollView==nil) {
        _timeScrollView= [[UIScrollView alloc]initWithFrame:CGRectMake(kLeftORRight, _topBaseView.frame.size.height+_topBaseView.frame.origin.y, _topBaseView.frame.size.width*(1-kTabelPercent), 11)];
        _timeScrollView.contentSize=CGSizeMake(_timeScrollView.frame.size.width*2, 11);
        _timeScrollView.showsVerticalScrollIndicator=NO;
        _timeScrollView.userInteractionEnabled=NO;
        _timeScrollView.hidden=YES;
    }
    [self addSubview:_timeScrollView];
    [self buildTimeLabelWithHistoryYON:hisAppearOrDisapp];
}
-(void)buildTimeLabelWithHistoryYON:(BOOL)yon
{
    [_pointArray removeAllObjects];
    if (_timeScrollView.subviews.count) {
        for (UILabel *label in _timeScrollView.subviews) {
            [label removeFromSuperview];
        }
    }
    NSArray*array;
    if (yon) {
        array=@[@"历史驾驶",@"今天",@"6时",@"12时",@"18时",@"24时"];
    }else
        array=@[@"0时",@"6时",@"12时",@"18时",@"24时"];
    if (!_timeScrollView.subviews.count) {
        CGFloat kLabelWeiht = 30;
        CGFloat kLabelHeight = 22;
        _pointArray=[NSMutableArray array];
        //设置时间段
        CGFloat weight;
        
        for (int i=0; i<array.count; i++) {
            UILabel*label;
            if (yon) {
                //设置时间段
                weight=(_timeScrollView.frame.size.width-40-kLabelWeiht-20)/4;
                if (i==0) {
                    label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kLabelWeiht+20, kLabelHeight/2)];
                }else{
                    label=[[UILabel alloc]initWithFrame:CGRectMake(40+(i-1)*weight+kLabelWeiht/2, 0, kLabelWeiht, kLabelHeight/2)];
                }
            }else{
                weight=(_timeScrollView.frame.size.width-40)/4;
                kLabelHeight=20;
                label=[[UILabel alloc]initWithFrame:CGRectMake(20+i*weight, 0, kLabelWeiht, kLabelHeight/2)];
            }
            
            label.text=array[i];
            label.tag=i+10;
            label.textColor=[UIColor grayColor];
            label.textAlignment=NSTextAlignmentCenter;
            [_timeScrollView addSubview:label];
            if (kSizeOfScreen.height<500) {
                label.font=[UIFont fontWithName:@"Helvetica Neue" size:10];
            }else
                label.font=[UIFont fontWithName:@"Helvetica Neue" size:12];
            [_pointArray addObject:[NSString stringWithFormat:@"%f",label.center.x]];
        }
    }
}
#pragma mark - 滑动代理方法让两个scrollView 实现滑动同步
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:_scrollView]) {
        _timeScrollView.contentOffset=_scrollView.contentOffset;
    }
}
#pragma mark - 创建底部试图
-(void)buildDownViewWithDic:(NSDictionary*)dicMsg
{
     NSDictionary* dic;
    NSString*contentString;
    if (_noData) {//没有数据
        dic = @{@"title":@"您当日驾驶里程为",
                @"value":@"0",
                @"content":@"",
                @"mark":@""};
    }else{//有数据
        contentString = [NSString stringWithFormat:@"其中最长连续驾驶%@km,击败了全国%@的车友",dicMsg[@"max"],dicMsg[@"percent"]];
        NSRange range1=[contentString rangeOfString:@"其中最长连续驾驶"];
        NSRange range2=[contentString rangeOfString:@",击败了全国"];
        NSRange range3=[contentString rangeOfString:@"的车友"];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentString];
        [str addAttribute:NSForegroundColorAttributeName value:KBlackMainColor range:NSMakeRange(range1.location,range1.length)];
        [str addAttribute:NSForegroundColorAttributeName value:KBlackMainColor range:NSMakeRange(range2.location,range2.length)];
        [str addAttribute:NSForegroundColorAttributeName value:KBlackMainColor range:NSMakeRange(range3.location ,range3.length)];
        
        NSString*markString=@"";
        if (dicMsg.count) {
            if ([dicMsg[@"total"] floatValue]<10.0) {
                markString=@"环保出行，为地球减负。";
            }else{
                if ([dicMsg[@"total"] floatValue]<60.0) {
                    markString=@"开自己的车，让别人挤公交去把！";
                }else{
                    if ([dicMsg[@"total"] floatValue]<200.0) {
                        markString=@"堪称劳模司机！";
                    }else{
                        markString=@"我开过的路连起来可绕地球七圈！";
                    }
                }
            }
        }
        
        dic = @{@"title":@"您当日驾驶里程为",
                @"value":[NSString stringWithFormat:@"%@km",dicMsg[@"total"]],
                @"content":str,
                @"mark":markString};
    }

    _shareString=[NSString stringWithFormat:@"%@,%@,%@,%@",dic[@"title"],dic[@"value"],contentString,dic[@"mark"]];
    [self buildDownViewsWithDic:dic];
}
-(void)buildDownViewsWithDic:(NSDictionary*)dicMsg
{
    CGFloat kdistanceHeight=15;
    CGFloat downOriginY = self.frame.size.height*kpercent;
    CGFloat kFontSize=16;
    
    //设置iPhone4和iPhone5的数据大小
    if (kSizeOfScreen.height<600) {
        kdistanceHeight=8;
        kFontSize=14;
    }
    
    if (_currentMilLabel==nil) {
        CGSize cMSzie=[self takeTheSizeOfString:@"您当日驾驶里程为" withFont:kFontOfSize(kFontSize)];
        _currentMilLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, downOriginY+kdistanceHeight, self.frame.size.width, cMSzie.height)];
        _currentMilLabel.textColor=KBlackMainColor;
        _currentMilLabel.textAlignment=NSTextAlignmentCenter;
        _currentMilLabel.font=kFontOfSize(kFontSize);
    }
    _currentMilLabel.text=dicMsg[@"title"];
    [self addSubview:_currentMilLabel];
    
    if (_milLabel==nil) {
        CGSize mileSzie=[self takeTheSizeOfString:@"您当日驾驶里程为" withFont:kFontOfSize(kFontSize*2)];
        _milLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _currentMilLabel.frame.origin.y+_currentMilLabel.frame.size.height+kdistanceHeight, self.frame.size.width, mileSzie.height)];
        _milLabel.textColor=kMainColor;
        _milLabel.textAlignment=NSTextAlignmentCenter;
        _milLabel.font=kFontOfSize(kFontSize*2);
    }
    _milLabel.text=dicMsg[@"value"];
    [self addSubview:_milLabel];
    
    if (_contentLabel==nil) {
        CGSize mileSzie=[self takeTheSizeOfString:@"您" withFont:kFontOfSize(kFontSize)];
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _milLabel.frame.origin.y+_milLabel.frame.size.height+kdistanceHeight, self.frame.size.width, mileSzie.height)];
        _contentLabel.textColor=kMainColor;
        _contentLabel.textAlignment=NSTextAlignmentCenter;
        _contentLabel.font=kFontOfSize(kFontSize);
    }
    if (![dicMsg[@"content"] length]) {
        _contentLabel.text=dicMsg[@"content"];
    }else
        _contentLabel.attributedText=dicMsg[@"content"];
    [self addSubview:_contentLabel];
    
    if (_descriptionLabel==nil) {
        CGSize mileSzie=[self takeTheSizeOfString:@"您" withFont:kFontOfSize(kFontSize)];
        _descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _contentLabel.frame.origin.y+_contentLabel.frame.size.height+kdistanceHeight, self.frame.size.width, mileSzie.height)];
        _descriptionLabel.textColor=KBlackMainColor;
        _descriptionLabel.textAlignment=NSTextAlignmentCenter;
        _descriptionLabel.font=kFontOfSize(kFontSize);
    }
    _descriptionLabel.text=dicMsg[@"mark"];
    [self addSubview:_descriptionLabel];
    
    if (_shareBtn==nil) {
        CGFloat btnWeight = 80;
        _shareBtn=[[UIButton alloc]initWithFrame:CGRectMake((kSizeOfScreen.width-btnWeight)/2, _descriptionLabel.frame.origin.y+_descriptionLabel.frame.size.height+kdistanceHeight, btnWeight, btnWeight)];
        [_shareBtn addTarget:self action:@selector(shareMsgEvent) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    [self addSubview:_shareBtn];
    if (_noData) {//没数据
        [_shareBtn setImage:[UIImage imageNamed:@"shuai_icon1"] forState:UIControlStateNormal];
        _shareBtn.userInteractionEnabled=NO;
    }else{//有数据
        _shareBtn.userInteractionEnabled=YES;
        [_shareBtn setImage:[UIImage imageNamed:@"shuai_icon"] forState:UIControlStateNormal];
        [_shareBtn setImage:[UIImage imageNamed:@"shuai_icon1"] forState:UIControlStateHighlighted];
    }
}
#pragma mark - 分享事件
-(void)shareMsgEvent
{
    MyLog(@"分享数据");
    [self.delegate newReportMileageShareMsgDic:@{@"content":_shareString,@"url":_dicMsg[@"shareUrl"],@"imgUrl":_dicMsg[@"shareIcon"]}];

}
#pragma mark - 刷新数据
-(void)reloadDataWithDic:(NSDictionary *)dic
{
    hisAppearOrDisapp=YES;
    _selectPath=nil;
    [self buildUIWithDicMsg:dic];
    _dicMsg=dic;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _tableArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellID=@"reportID";
    ReportTimeCell*cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[ReportTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.dicMsg=_tableArray[_tableArray.count-1-indexPath.section];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectPath!=nil) {
        ReportTimeCell*cell=(ReportTimeCell*)[tableView cellForRowAtIndexPath:_selectPath];
        cell.contentView.backgroundColor=kCOLOR(185, 185, 185);
    }else
        _allTimeBtn.backgroundColor=kCOLOR(185, 185, 185);
    ReportTimeCell*currentCell=(ReportTimeCell *)[tableView cellForRowAtIndexPath:indexPath];
    currentCell.contentView.backgroundColor=kCOLOR(135, 135, 135);
    _selectPath=indexPath;

    hisAppearOrDisapp=NO;
    [self buildTimeLabelWithHistoryYON:hisAppearOrDisapp];
    
    if (_scrollView.contentSize.width<=_scrollView.frame.size.width) {
        _scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width*2, _scrollView.frame.size.height);
        [self changeTopViewFrame];
    }
    if ([_pointArray[_pointArray.count-1] floatValue]<_timeScrollView.frame.size.width) {
        for (int i=0; i<_pointArray.count; i++) {
            CGFloat weight=(_timeScrollView.frame.size.width*2-60)/4;
            CGFloat kLabelHeight=20;
            [_pointArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%f",20+i*weight]];
            
            UILabel*label=(UILabel*)[_timeScrollView viewWithTag:i+10];
            label.center=CGPointMake(20+i*weight+kLabelHeight/2, label.center.y);
        }
    }
    MyLog(@"%@\n%f",_pointArray,_timeScrollView.frame.size.width);
    [_topView timeCellSelect:_tableArray[_tableArray.count-1-indexPath.section] withPointArray:_pointArray];
    
    CGFloat weightBtn =([_pointArray[_pointArray.count-1] floatValue] - [_pointArray[0] floatValue])/24/60/60;
    
    NSArray*arrayMsg=_dicMsg[@"list"];
    CGFloat xPoint=[_pointArray[0] floatValue]+[arrayMsg[arrayMsg.count-1-indexPath.section][@"start"] floatValue]*weightBtn+([arrayMsg[arrayMsg.count-1-indexPath.section][@"end"] floatValue]-[arrayMsg[arrayMsg.count-1-indexPath.section][@"start"] floatValue])*weightBtn/2;
    int rightW=(int)_timeScrollView.contentSize.width*0.75;
    int leftW=(int)_timeScrollView.contentSize.width*0.25;
    CGFloat offSetX;
    if (xPoint>rightW) {
        offSetX=_timeScrollView.contentSize.width/2;
    }else if(xPoint<leftW){
        offSetX=0;
    }else{
        offSetX=xPoint-leftW;
    }
    //添加动画
    [UIView animateWithDuration:0.2 animations:^{
        _scrollView.contentOffset=CGPointMake(offSetX, 0);
    }];
    //延迟添加标注
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_topView timeCellAfterLoginMsg:_tableArray[_tableArray.count-1-indexPath.section]];
    });
}
-(void)allTimeCanSee
{
    hisAppearOrDisapp=YES;
    [self buildTimeLabelWithHistoryYON:hisAppearOrDisapp];
    _allTimeBtn.backgroundColor=kCOLOR(135, 135, 135);
    if (_selectPath!=nil) {
        ReportTimeCell*cell=(ReportTimeCell*)[_tableView cellForRowAtIndexPath:_selectPath];
        cell.contentView.backgroundColor=kCOLOR(185, 185, 185);
        _selectPath=nil;
    }
    if (_scrollView.contentSize.width>_scrollView.frame.size.width) {
        //添加动画
        [UIView animateWithDuration:0.2 animations:^{
            _scrollView.contentSize=_scrollView.frame.size;
        }];
        [self changeTopViewFrame];
        //延迟添加标注
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
        });
    }
    if ([_pointArray[_pointArray.count-1] floatValue]>_timeScrollView.frame.size.width) {
        for (int i=0; i<_pointArray.count; i++) {
            CGFloat centerX=[_pointArray[i] floatValue];
            centerX=centerX/2;
            [_pointArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%f",centerX]];
            UILabel*label=(UILabel*)[_timeScrollView viewWithTag:i+10];
            label.center=CGPointMake(centerX, label.center.y);
        }
    }
    [_topView allBtnTouchDownWithPointArray:_pointArray];
}
-(void)changeTopViewFrame
{
    CGRect topFrame=_topView.frame;
    topFrame.size.width=_scrollView.contentSize.width;
    _topView.frame=topFrame;
    
}
-(CGSize)takeTheSizeOfString:(NSString*)string withFont:(UIFont*)font{
    CGSize stringOfSize=[string boundingRectWithSize:CGSizeMake(275, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
    return stringOfSize;
}
@end
