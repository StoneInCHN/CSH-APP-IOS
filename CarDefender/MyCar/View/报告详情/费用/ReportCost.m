//
//  ReportCost.m
//  报告动画
//
//  Created by 周子涵 on 15/5/13.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "ReportCost.h"
#import "ReportCostDetailBtn.h"
#import "Define.h"
#import "ReportPublicBaskBtn.h"
#define kCostViewHeight 105
#define kCostViewWeight 80
#define kDistance 10/2
#define kBaskBtnWH 80
@implementation ReportCost

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"ReportCost" owner:self options:nil][0];
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        
        _costTotalArray=[NSMutableArray array];
        _gudingArray=@[@{
                           @"type":@"cost",
                           @"value":@"0",
                           },
                       @{
                           @"type":@"add",
                           @"value":@"",
                           }
                       ];
        if (kSizeOfScreen.height<600) {
            kCostBtnHeight=90;
            _namalFont=14;
            _costDistance=5;
        }else{
            kCostBtnHeight=105;
            _namalFont=16;
            _costDistance=10;
        }
        
        [self buildScrollView];
        [self setCostDetailArray:nil];
    }
    return self;
}
-(void)buildScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, kCostBtnHeight)];
    [self addSubview:_scrollView];
    _scrollView.delegate=self;
    _scrollView.pagingEnabled=YES;
}
-(void)buildUI
{
    UILabel*labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(0, _pageController.frame.origin.y+_pageController.frame.size.height, self.frame.size.width, 15)];
    labelDetail.text=@"点击图形编辑费用详情";
    labelDetail.textColor=[UIColor grayColor];
    labelDetail.textAlignment=NSTextAlignmentCenter;
    labelDetail.font=[UIFont fontWithName:@"Helvetica Neue" size:_namalFont];
    [self addSubview:labelDetail];
    
    //虚线一下ui
    UILabel*currentCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, labelDetail.frame.size.height+labelDetail.frame.origin.y+_costDistance*2, self.frame.size.width, 15)];
    currentCostLabel.text=@"您当日费用为";
    currentCostLabel.textColor=KBlackMainColor;
    currentCostLabel.textAlignment=NSTextAlignmentCenter;
    currentCostLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:_namalFont];
    [self addSubview:currentCostLabel];
    
    _totalCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, currentCostLabel.frame.size.height+currentCostLabel.frame.origin.y+_costDistance, self.frame.size.width, 25)];
    //    _totalCostLabel.text=@"您当日费用为";
    _totalCostLabel.textColor=[UIColor colorWithRed:60/255.0 green:152/255.0 blue:247/255.0 alpha:1];
    _totalCostLabel.textAlignment=NSTextAlignmentCenter;
    _totalCostLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:30];
    [self addSubview:_totalCostLabel];
    
    
    
    _descriptionLable = [[UILabel alloc]initWithFrame:CGRectMake(20, _totalCostLabel.frame.origin.y+_totalCostLabel.frame.size.height, self.frame.size.width-2*20, 50)];
//    describeOilCostLabel.attributedText=str;
//    _descriptionLable.text=@";
    _descriptionLable.textColor=kMainColor;
    _descriptionLable.textAlignment=NSTextAlignmentCenter;
    _descriptionLable.font=[UIFont fontWithName:@"Helvetica Neue" size:_namalFont];
    [self addSubview:_descriptionLable];
    _descriptionLable.numberOfLines=0;
    
    _characterLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, _descriptionLable.frame.size.height+_descriptionLable.frame.origin.y+_costDistance, kSizeOfScreen.width, 15)];
    _characterLabel.text=@"";
    _characterLabel.textColor=KBlackMainColor;
    _characterLabel.textAlignment=NSTextAlignmentCenter;
    _characterLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:_namalFont];
    [self addSubview:_characterLabel];
    
    ReportPublicBaskBtn*baskBtn=[[ReportPublicBaskBtn alloc]initWithFrame:CGRectMake((kSizeOfScreen.width-kBaskBtnWH)/2, _characterLabel.frame.origin.y+_characterLabel.frame.size.height+_costDistance*2, kBaskBtnWH, kBaskBtnWH)];
//    [baskBtn setTitle:@"晒一晒" forState:UIControlStateNormal];
//    baskBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
//    baskBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:16];
//    [baskBtn setTitleColor:[UIColor colorWithRed:60/255.0 green:152/255.0 blue:247/255.0 alpha:1] forState:UIControlStateNormal];
//    [baskBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [baskBtn setImage:[UIImage imageNamed:@"xiqngqing_shai"] forState:UIControlStateNormal];
    [baskBtn setImage:[UIImage imageNamed:@"shuai_icon1"] forState:UIControlStateHighlighted];
    [baskBtn addTarget:self action:@selector(shareCostClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:baskBtn];
}
-(void)shareCostClick:(ReportPublicBaskBtn*)sender
{
    [self.delegate costShareMsg:@{@"content":_shareString,@"url":_costDic[@"shareUrl"],@"imgUrl":_costDic[@"shareIcon"]}];
}
-(void)setCostDetailArray:(NSArray *)costDetailArray
{
    _costTotalArray=[NSMutableArray arrayWithArray:_gudingArray];
    
    if (costDetailArray.count) {
        for (int i=0; i<costDetailArray.count; i++) {
            [_costTotalArray insertObject:costDetailArray[i] atIndex:_costTotalArray.count-1];
        }
    }
    
    if (_scrollView!=nil) {
        for (ReportCostDetailBtn*view1 in _scrollView.subviews) {
            [view1 removeFromSuperview];
        }
        if (kSizeOfScreen.height>500) {
            _scrollView.frame=CGRectMake(0, 0, self.frame.size.width, kCostBtnHeight*2+2*_costDistance);
        }else{
            _scrollView.frame=CGRectMake(0, 0, self.frame.size.width, kCostBtnHeight+_costDistance/2);
        }
        for (int i=0; i<_costTotalArray.count; i++) {
            CGFloat weightAverage;
            int lineInt =i%3;
            int rowInt  =i/3%2;
            weightAverage=(self.frame.size.width-3*kCostViewWeight)/4;
            
            CGFloat heightBtn;
            CGFloat weightBtn;
            if (kSizeOfScreen.height>500) {
                heightBtn=rowInt*10/2+rowInt*kCostBtnHeight;
                weightBtn=weightAverage+weightAverage*lineInt+kCostViewWeight*lineInt+ i/6*self.frame.size.width;
            }else{
                heightBtn = 0;
                weightBtn=weightAverage+weightAverage*lineInt+kCostViewWeight*lineInt+ i/3*self.frame.size.width;
            }
            
            ReportCostDetailBtn*view=[[ReportCostDetailBtn alloc]initWithFrame:CGRectMake(weightBtn, heightBtn, kCostViewWeight, kCostBtnHeight)];
            view.costMsg=_costTotalArray[i];
            [_scrollView addSubview:view];
            
            view.tag=i+10;
            [view addTarget:self action:@selector(editCostMsg:) forControlEvents:UIControlEventTouchUpInside];
        }
        int a=0;
        if (kSizeOfScreen.height>500) {
            if (_costTotalArray.count/6&&_costTotalArray.count%6) {
                a=(int)_costTotalArray.count/6;
            }else{
                if (_costTotalArray.count==(_costTotalArray.count/6)*6) {
                    a=(int)_costTotalArray.count/6-1;
                }
            }
        }else{
            if (_costTotalArray.count/3&&_costTotalArray.count%3) {
                a=(int)_costTotalArray.count/3;
            }else{
                if (_costTotalArray.count==(_costTotalArray.count/6)*3) {
                    a=(int)_costTotalArray.count/3-1;
                }
            }
        }
        [self buildPageController];
        
        _scrollView.contentSize=CGSizeMake(self.frame.size.width*(1+a), kCostBtnHeight*(!(_costTotalArray.count-1)+1));
        
        if (a>0) {
            _pageController.hidden=NO;
        }else{
            _pageController.hidden=YES;
        }
        _pageController.numberOfPages=1+a;
    }
}
-(void)buildPageController
{
    if (_pageController==nil) {
        _pageController=[[UIPageControl alloc]init];
        _pageController.center=CGPointMake(self.frame.size.width*0.5, _scrollView.frame.size.height+_scrollView.frame.origin.y+_costDistance/2);
        _pageController.bounds=CGRectMake(0, 0, 150, 15);
        _pageController.pageIndicatorTintColor=[UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
        _pageController.currentPageIndicatorTintColor=[UIColor colorWithRed:60/255.0 green:152/255.0 blue:247/255.0 alpha:1];
        [self addSubview:_pageController];
        _pageController.hidden=YES;
        [self buildUI];
    }
}
-(void)editCostMsg:(ReportCostDetailBtn*)sender
{
    if (sender.tag==10+_costTotalArray.count-1) {
        [self.delegate reportCostAddCarCostWithDic:_costDic];
    }else{
        [self.delegate reportCostEdit:_costTotalArray[sender.tag-10]];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 设置页码
    _pageController.currentPage = page;
}


-(void)reloadData:(NSDictionary *)dic
{
    _costDic=dic;
    MyLog(@"%@",dic);
    if ([dic[@"oil"] length]) {
        _gudingArray=@[@{
                           @"type":@"cost",
                           @"value":dic[@"oil"],
                           },
                       @{
                           @"type":@"add",
                           @"value":@"",
                           }
                       ];
    }
    
    if (_costDic.count) {
        NSString*costString;
        if ([dic[@"total"] length]) {
            costString=[dic[@"total"] stringByReplacingOccurrencesOfString: @"," withString: @""];
            _totalCostLabel.text=[NSString stringWithFormat:@"￥%.2f",[costString floatValue]];
        }
        if ([costString floatValue] <50.0) {
            _characterLabel.text=@"自己的路，自己做主";
        }else if (50.0<[costString floatValue]){
            if ([costString floatValue] <300.0) {
                _characterLabel.text=@"时间就是金钱，今天又赚了好多！";
            }else{
                _characterLabel.text=@"土豪，您缺司机么？";
            }
        }
        
        NSDictionary*dicMsg=@{@"oil":@"燃油",@"park":@"停车",@"clean":@"洗车",@"road":@"路桥",@"maintain":@"保养",@"insurance":@"保险",@"fine":@"罚款"};
        
        NSString*stringDesc;
        if (![dicMsg[_costDic[@"maxType"]] isKindOfClass:[NSNull class]] && dicMsg[_costDic[@"maxType"]] != nil) {
            stringDesc=[NSString stringWithFormat:@"其中最大费用为%@%@，击败了全国%@的车友。",dicMsg[_costDic[@"maxType"]],_costDic[@"max"],_costDic[@"percent"]];
        }
        else {
            stringDesc=[NSString stringWithFormat:@"其中最大费用为%@%@，击败了全国%@的车友。",@"0",_costDic[@"max"],_costDic[@"percent"]];
        }
//        NSString*stringDesc=[NSString stringWithFormat:@"其中最大费用为%@%@，击败了全国%@的车友。",dicMsg[_costDic[@"maxType"]],_costDic[@"max"],_costDic[@"percent"]];
        
        NSRange range1=[stringDesc rangeOfString:[NSString stringWithFormat:@"其中最大费用为%@",dicMsg[_costDic[@"maxType"]]]];
        NSRange range2=[stringDesc rangeOfString:@"，击败了全国"];
        NSRange range3=[stringDesc rangeOfString:@"的车友。"];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:stringDesc];
        [str addAttribute:NSForegroundColorAttributeName value:KBlackMainColor range:NSMakeRange(range1.location,range1.length)];
        [str addAttribute:NSForegroundColorAttributeName value:KBlackMainColor range:NSMakeRange(range2.location,range2.length)];
        [str addAttribute:NSForegroundColorAttributeName value:KBlackMainColor range:NSMakeRange(range3.location ,range3.length)];
        _descriptionLable.attributedText=str;
        
        _shareString=[NSString stringWithFormat:@"您当日费用为%@%@%@",_totalCostLabel.text,_characterLabel.text,stringDesc];
    }
    
    if ([dic[@"list"] count]) {
        [self setCostDetailArray:dic[@"list"]];
    }else{
        [self setCostDetailArray:nil];
    }
}
-(void)drawRect:(CGRect)rect
{
    //获取绘图上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //设置线宽
    CGContextSetLineWidth(ctx, 1);
    CGContextSetRGBStrokeColor(ctx, 229.0/255.0, 229.0/255.0, 229.0/255.0, 1);
    CGFloat patterns1[] = {8,2};
    //设置点线模式：实线宽6，间距宽10
    CGContextSetLineDash(ctx, 0, patterns1, 1);
    
    //定义两个点，绘制线段
    const CGPoint points4[]={CGPointMake(20, _pageController.frame.size.height+_pageController.frame.origin.y+15+_costDistance),CGPointMake(rect.size.width-20, _pageController.frame.size.height+_pageController.frame.origin.y+15+_costDistance)};
    //绘制线段
    CGContextStrokeLineSegments(ctx, points4, 2);
    
    //    self.backgroundColor=[UIColor whiteColor];
}
-(void)animateStart
{

}
@end
