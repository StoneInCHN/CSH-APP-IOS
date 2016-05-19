//
//  CWSGuideViewController.m
//  CarDefender
//
//  Created by 李散 on 15/4/28.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSGuideViewController.h"

@interface CWSGuideViewController ()<UIScrollViewDelegate>

@end

@implementation CWSGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (int i=0; i<4; i++) {
        UIImageView*imgView=[[UIImageView alloc]initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, kSizeOfScreen.height + kSTATUS_BAR)];
        imgView.image=[UIImage imageNamed:[NSString stringWithFormat:@"guide_img%d",i+1]];
        [self.scrollView addSubview:imgView];
    }
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled=YES;
    self.scrollView.bounces = NO;
    self.scrollView.contentSize=CGSizeMake(4*self.view.frame.size.width, kSizeOfScreen.height);
    self.scrollView.delegate=self;
    [Utils setViewRiders:self.experienceBtn riders:4];
    [Utils setBianKuang:[UIColor whiteColor] Wide:1 view:self.experienceBtn];
//    self.pageControl.numberOfPages=4;
//    self.pageControl.hidesForSinglePage=YES;
//    self.pageControl.currentPage=0;
    self.pageControl.hidden = YES;
    self.experienceBtn.hidden=YES;

    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [ModelTool stopAllOperation];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = fabs(scrollView.contentOffset.x)/self.view.frame.size.width;
    //    self.pageControl.currentPage = index;
    if (index==3) {
        self.experienceBtn.hidden=NO;
    }else{
        self.experienceBtn.hidden=YES;
    }
}

//- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    int index = fabs(scrollView.contentOffset.x)/self.view.frame.size.width;
////    self.pageControl.currentPage = index;
//    if (index==3) {
//        self.experienceBtn.hidden=NO;
//    }else{
//        self.experienceBtn.hidden=YES;
//    }
//}
- (IBAction)experienceClick:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"welcomeToRoot" object:nil];
}
@end
