//
//  CWSClassicView.m
//  carLife
//
//  Created by 王泰莅 on 15/12/2.
//  Copyright © 2015年 王泰莅. All rights reserved.
//

#import "CWSClassicView.h"
#import "CWSActivityViewController.h"
#import "CWSRecordShopViewController.h"
#import "CreditWebViewController.h"

@implementation CWSClassicView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
    
        UIView* barrierLine = [[UIView alloc]initWithFrame:CGRectMake(kSizeOfScreen.width/2-0.5, 0, 0.5, frame.size.height)];
        barrierLine.alpha = 0.2f;
        barrierLine.backgroundColor = [UIColor grayColor];
        [self addSubview:barrierLine];
        
        
        UIView* view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 5, kSizeOfScreen.width/2-0.5, frame.size.height-5)];
        UIView* view2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(barrierLine.frame), 5, kSizeOfScreen.width/2-0.5, frame.size.height-5)];
        [self addSubview:view1];
        [self addSubview:view2];
        
        //左边
        UIImageView* leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 40, 40)];
        leftImage.image = [UIImage imageNamed:@"huodongqu"];
        [view1 addSubview:leftImage];
        
        UILabel* leftLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftImage.frame)+10, 25, kSizeOfScreen.width/2, 20)];
        leftLabel1.text = @"活动专区";
        leftLabel1.textColor = KBlackMainColor;
        leftLabel1.font = [UIFont boldSystemFontOfSize:15];
        [view1 addSubview:leftLabel1];
        [leftLabel1 sizeToFit];
        
        UILabel* leftLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftImage.frame)+10, CGRectGetMaxY(leftLabel1.frame)+5, kSizeOfScreen.width/2, 20)];
        leftLabel2.text = @"0元免费洗车";
        leftLabel2.font = [UIFont systemFontOfSize:13];
        leftLabel2.textColor = [UIColor lightGrayColor];
        [view1 addSubview:leftLabel2];
        [leftLabel2 sizeToFit];
        
        UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = view1.frame;
        [self addSubview:leftButton];
        [leftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //右边
        UIImageView* rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 40, 40)];
        rightImage.image = [UIImage imageNamed:@"jifenshangcheng"];
        [view2 addSubview:rightImage];
        
        UILabel* rightLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rightImage.frame)+10, 25, kSizeOfScreen.width/2, 20)];
        rightLabel1.text = @"积分商城";
        rightLabel1.font = [UIFont boldSystemFontOfSize:15];
        rightLabel1.textColor = KBlackMainColor;
        [view2 addSubview:rightLabel1];
        [rightLabel1 sizeToFit];
        
        UILabel* rightLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rightImage.frame)+10, CGRectGetMaxY(rightLabel1.frame)+5, kSizeOfScreen.width/2, 20)];
        rightLabel2.text = @"IPAD免费抽";
        rightLabel2.font = [UIFont systemFontOfSize:13];
        rightLabel2.textColor = [UIColor lightGrayColor];
        [view2 addSubview:rightLabel2];
        [rightLabel2 sizeToFit];
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = view2.frame;
        [self addSubview:rightButton];
        [rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


#pragma mark -============================回调方法
-(void)leftButtonClicked:(UIButton*)sender{
    CWSActivityViewController *vc = [[CWSActivityViewController alloc] init];
    vc.isOnlyShow = NO;
    [self.thyRootVc.navigationController pushViewController:vc animated:YES];
}

-(void)rightButtonClicked:(UIButton*)sender{
    //积分商城
//    CWSRecordShopViewController *vc = [[CWSRecordShopViewController alloc] init];
    //兑吧商城
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *duiBaUrl = [userDefaults objectForKey:@"duiBaUrl"];
    CreditWebViewController *web=[[CreditWebViewController alloc]initWithUrl:duiBaUrl];
    [self.thyRootVc.navigationController pushViewController:web animated:YES];
}


@end
