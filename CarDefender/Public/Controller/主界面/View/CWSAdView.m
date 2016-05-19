//
//  CWSAdView.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/15.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSAdView.h"
#import "UIButton+WebCache.h"
#import "UserAdvertisementInfo.h"
@implementation CWSAdView{

    UIScrollView* _myAdScrollView;    //广告滚动视图
    
    NSMutableArray* _myAdDataArray;   //广告数组
    UIPageControl* _myPageControl;    //页面控制器
    
    NSTimer* timer;
}



-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        [self createUI:frame];
    
    }

    return self;
}

-(void)createUI:(CGRect)thyFrame{
    if(!_myAdDataArray){
        _myAdDataArray = @[].mutableCopy;
    }
    _myAdScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, thyFrame.size.height-10)];
    _myAdScrollView.backgroundColor = [UIColor clearColor];
    _myAdScrollView.bounces = NO;
    _myAdScrollView.pagingEnabled = YES;
    _myAdScrollView.delegate = self;
    _myAdScrollView.userInteractionEnabled = YES;
    _myAdScrollView.showsHorizontalScrollIndicator = NO;
    _myAdScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_myAdScrollView];
    
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, kSizeOfScreen.width, _myAdScrollView.frame.size.height);
    
    [button setBackgroundImage:[UIImage imageNamed:@"bannerhounian"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_myAdScrollView addSubview:button];
}

#pragma mark -========================InitialData
-(void)setAdImagesDataArray:(NSArray *)adImagesDataArray{
    
    _adImagesDataArray = adImagesDataArray;
    [_myAdDataArray removeAllObjects];
    [_myAdScrollView removeSubviews];
    
    for (UIView* thyView in self.subviews) {
        if([thyView isKindOfClass:[UIPageControl class]]){
            [thyView removeFromSuperview];
        }
    }
    for(int i=0; i<adImagesDataArray.count; i++){
        UserAdvertisementInfo* thyAdvertisement = [[UserAdvertisementInfo alloc]initWithDict:adImagesDataArray[i]];
        thyAdvertisement.advImageUrl = [NSString stringWithFormat:@"%@/csh-interface%@",SERVERADDRESS,thyAdvertisement.advImageUrl];
        [_myAdDataArray addObject:thyAdvertisement];
        MyLog(@"图片地址 :%@",thyAdvertisement.advImageUrl);
    }
    [_myAdDataArray addObject:[_myAdDataArray firstObject]];
    [_myAdDataArray insertObject:_myAdDataArray[_myAdDataArray.count-2] atIndex:0];
    [self initialAdScrollView];
}


#pragma mark -========================OtherCallBack
/**设置滚动scrollview*/
-(void)initialAdScrollView{
    
    [timer invalidate];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    timer.fireDate = [NSDate distantFuture];
    _myAdScrollView.contentSize = CGSizeMake(kSizeOfScreen.width * _myAdDataArray.count, _myAdScrollView.frame.size.height-10);
    _myPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_myAdScrollView.frame),kSizeOfScreen.width, 10)];
    _myPageControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
    _myPageControl.numberOfPages = _myAdDataArray.count - 2;
    _myPageControl.currentPage = _myAdDataArray.count - 2;
    [_myPageControl setCurrentPageIndicatorTintColor:kMainColor];
    [_myPageControl setPageIndicatorTintColor:[UIColor whiteColor]];
    [self addSubview:_myPageControl];
    
    if (_myAdDataArray.count > 0) {
        for(int i=0; i<_myAdDataArray.count; i++){
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.frame = CGRectMake(i*kSizeOfScreen.width, 0, kSizeOfScreen.width, _myAdScrollView.frame.size.height);
            [button setBackgroundImageWithURL:[NSURL URLWithString:[_myAdDataArray[i] advImageUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bannerhounian"]];
            [button addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_myAdScrollView addSubview:button];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             timer.fireDate = [NSDate distantPast];
        });
    }
    else {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, kSizeOfScreen.width, _myAdScrollView.frame.size.height);
        
        [button setBackgroundImage:[UIImage imageNamed:@"bannerhounian"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_myAdScrollView addSubview:button];
        
    }
}



/**下一页方法*/
-(void)nextImage{
    [UIView animateWithDuration:0.5 animations:^{
        _myAdScrollView.contentOffset = CGPointMake(_myAdScrollView.contentOffset.x + kSizeOfScreen.width, 0);
    } completion:^(BOOL finished) {
        if(_myAdScrollView.contentOffset.x == kSizeOfScreen.width * (_myAdDataArray.count - 1)){
            _myAdScrollView.contentOffset = CGPointMake(kSizeOfScreen.width, 0);
        }
    }];
}

/**滚动视图图片点击事件回调*/
-(void)imageButtonClicked:(UIButton*)sender{

    MyLog(@"图片点击---%ld",(long)sender.tag);
    NSLog(@"url :%@",self.adImagesDataArray[sender.tag - 1][@"advContentLink"]);
    NSURL *url = [NSURL URLWithString:self.adImagesDataArray[sender.tag- 1][@"advContentLink"]];
    if (self.delegate != nil) {
        [self.delegate clickedAdView:url];
    }
}


#pragma mark -========================ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _myPageControl.currentPage = _myAdScrollView.contentOffset.x / kSizeOfScreen.width - 1;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if(_myAdScrollView == scrollView){
        
        if(_myAdScrollView.contentOffset.x == kSizeOfScreen.width * (_myAdDataArray.count - 1)){
            _myAdScrollView.contentOffset = CGPointMake(kSizeOfScreen.width, 0);
        }
        if(_myAdScrollView.contentOffset.x == 0){
            _myAdScrollView.contentOffset = CGPointMake(kSizeOfScreen.width * (_myAdDataArray.count - 2), 0);
        }
    }
}


@end
