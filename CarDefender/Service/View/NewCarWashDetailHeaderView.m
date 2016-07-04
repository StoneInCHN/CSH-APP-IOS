//
//  NewCarWashDetailHeaderView.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/10.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "NewCarWashDetailHeaderView.h"
#import "UIImageView+WebCache.h"
#import "BMNavController.h"

@interface NewCarWashDetailHeaderView()<UIAlertViewDelegate,UIScrollViewDelegate> {
    UIView *backgroundView;
    UILabel *progress;
    int width;
    int startContentOffsetX;
    int willEndContentOffsetX;
    int endContentOffsetX;
    BOOL _isNext;
    BOOL _isEndScroll;
    int index;
    int kScreenWidth;
    int kScreenHeight;
}
@property (nonatomic,strong)NSString *telString;
@property (nonatomic,assign)CLLocationCoordinate2D pt;
@property (nonatomic,strong)BMNavController *controller;
@end

@implementation NewCarWashDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame Data:(NSDictionary *)dic images:(NSArray *)images controller:(BMNavController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"NewCarWashDetailHeaderView" owner:self options:nil] lastObject];
        
        NSString*url=[NSString stringWithFormat:@"%@/csh-interface%@",SERVERADDRESS, dic[@"photo"]];
        NSLog(@"租户logo地址：%@", url);
        NSURL *logoImgUrl=[NSURL URLWithString:url];
        [self.storeImageView setImageWithURL:logoImgUrl placeholderImage:[UIImage imageNamed:@"zhaochewei_img"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];

        self.storeNameLabel.text = dic[@"tenantName"];
        self.storeBusinessHoursLabel.text = [NSString stringWithFormat:@"营业时间:%@",dic[@"businessTime"]];
        self.storeAddressLabel.text = dic[@"address"];
        self.images = images;
        self.telString = dic[@"contactPhone"];
        self.pt = CLLocationCoordinate2DMake([dic[@"latitude"] floatValue], [dic[@"longitude"] floatValue]);
        self.controller = controller;
    }
    return self;
}
- (IBAction)showImageDetails:(id)sender {
    if (_images.count == 0) {
        return;
    }
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    backgroundView = [[UIView alloc] initWithFrame:window.frame];
    backgroundView.backgroundColor = [UIColor blackColor];
    [window addSubview:backgroundView];
    
    kScreenWidth = window.frame.size.width;
    kScreenHeight = window.frame.size.height;
    
    UIView *imageBackgroundView = [[UIView alloc] init];
    imageBackgroundView.center = backgroundView.center;
    imageBackgroundView.bounds = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height * 0.8);
    imageBackgroundView.backgroundColor = [UIColor clearColor];
    [backgroundView addSubview:imageBackgroundView];
    
    width = imageBackgroundView.frame.size.width;
    int hight = imageBackgroundView.frame.size.height;
    progress = [[UILabel alloc] initWithFrame:CGRectMake(imageBackgroundView.frame.origin.x, CGRectGetMaxY(imageBackgroundView.frame), width, 20)];
    progress.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)_images.count];
    progress.backgroundColor = [UIColor clearColor];
    progress.textColor = [UIColor whiteColor];
    progress.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:progress];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeImageDetailsByTap)];
    [backgroundView addGestureRecognizer:tapGesture];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, hight)];
    scrollView.contentSize = CGSizeMake(width*_images.count, hight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    for (int i = 0; i < _images.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0+width*i, 0, width, hight)];
        NSString *urlStr = [NSString stringWithFormat:@"%@/csh-interface%@",SERVERADDRESS,_images[i]];
        [imageView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"zhaochewei_img"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [scrollView addSubview:imageView];
    }
    [imageBackgroundView addSubview:scrollView];
}
- (void)removeImageDetailsByTap {
    [backgroundView removeSubviews];
    [backgroundView removeFromSuperview];
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    index = (int)scrollView.contentOffset.x / width + 1;
    progress.text = [NSString stringWithFormat:@"%d/%lu",index,(unsigned long)_images.count];
    if (!_isEndScroll) {
        return;
    }
    if (_isNext) {
        CGRect rect = CGRectMake(kScreenWidth*(index-0.5), 0, kScreenWidth, kScreenHeight);
        if (CGRectContainsPoint(rect,scrollView.contentOffset)) {
            [scrollView setContentOffset:CGPointMake(kScreenWidth*(index), 0)];
        } else {
            [scrollView setContentOffset:CGPointMake(kScreenWidth*(index-1), 0)];
        }
    } else {
        CGRect rect = CGRectMake(kScreenWidth*(index-1), 0, kScreenWidth/2, kScreenHeight);
        if (CGRectContainsPoint(rect,scrollView.contentOffset)) {
            [scrollView setContentOffset:CGPointMake(kScreenWidth*(index-1), 0)];
        } else {
            [scrollView setContentOffset:CGPointMake(kScreenWidth*(index), 0)];
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isEndScroll = NO;
    startContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    willEndContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _isEndScroll = YES;
    endContentOffsetX = scrollView.contentOffset.x;
    if (endContentOffsetX <= willEndContentOffsetX && willEndContentOffsetX < startContentOffsetX) { //画面从右往左移动，前一页
        _isNext = NO;
        CGRect rect = CGRectMake(kScreenWidth*(index-1), 0, kScreenWidth/2, kScreenHeight);
        if (CGRectContainsPoint(rect,scrollView.contentOffset)) {
            [scrollView setContentOffset:CGPointMake(kScreenWidth*(index-1), 0)];
        } else {
            [scrollView setContentOffset:CGPointMake(kScreenWidth*(index), 0)];
        }
    } else if (endContentOffsetX >= willEndContentOffsetX && willEndContentOffsetX > startContentOffsetX) {//画面从左往右移动，后一页
        _isNext = YES;
        CGRect rect = CGRectMake(kScreenWidth*(index-0.5), 0, kScreenWidth, kScreenHeight);
        if (CGRectContainsPoint(rect,scrollView.contentOffset)) {
            [scrollView setContentOffset:CGPointMake(kScreenWidth*(index), 0)];
        } else {
            [scrollView setContentOffset:CGPointMake(kScreenWidth*(index-1), 0)];
        }
    }
}


- (IBAction)buttonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    switch(sender.tag - 200){
        case 0:{
            NSLog(@"打电话！");
            if (sender.selected) {
                NSString *string = [NSString stringWithFormat:@"%@",self.telString];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
                [alert show];
                
            }
            
            ;
        };break;
        case 1:{
            NSLog(@"导航啊！");
            if (sender.selected) {
                MyLog(@"-----------%f %f",KManager.currentPt.latitude,KManager.currentPt.longitude);
                if (KManager.currentPt.latitude>0 && KManager.currentPt.longitude>0) {
                     [self.controller startNaviWithNewPoint:self.pt OldPoint:KManager.currentPt];
                }
                else {
                     [self.controller startNaviWithNewPoint:self.pt OldPoint:KManager.mobileCurrentPt];
                }
            }
            
            
        };break;
            
        default:break;
    
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.telString]]];
    }
}



@end
