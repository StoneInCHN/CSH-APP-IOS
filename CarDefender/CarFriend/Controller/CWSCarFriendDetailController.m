//
//  CWSCarFriendDetailController.m
//  CarDefender
//
//  Created by 李散 on 15/5/12.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSCarFriendDetailController.h"
#import "UIImageView+WebCache.h"
@interface CWSCarFriendDetailController ()
{
    UIScrollView*_scrollView;
}
@end

@implementation CWSCarFriendDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"详情";
    
    MyLog(@"%@",self.detailDic);
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    [ModelTool httpAppGainCircleDesWithParameter:@{@"circle":self.detailDic[@"id"]} success:^(id object) {
       dispatch_async(dispatch_get_main_queue(), ^{
           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
           if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
               MyLog(@"%@",object);
               [self buildUIWith:object[@"data"][@"circle"]];
           }else{
               [[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
           }
       });
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [ModelTool stopAllOperation];
}

-(void)buildUIWith:(NSDictionary*)dic
{
     _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, kTO_TOP_DISTANCE, kSizeOfScreen.width, self.view.frame.size.height)];
    [self.view addSubview:_scrollView];
    
    CGSize contentSize= [Utils takeTheSizeOfString:dic[@"title"] withFont:kFontOfSize(17) withWeight:286];
    UILabel*label=[Utils labelWithFrame:CGRectMake(17, 10, 286, contentSize.height) withTitle:dic[@"title"] titleFontSize:kFontOfSize(17)  textColor:kTextBlackColor alignment:NSTextAlignmentCenter];
    label.numberOfLines=0;
    [_scrollView addSubview:label];
    
    UIImageView*imge=[[UIImageView alloc]initWithFrame:CGRectMake(20, 53, 280, 209)];
    [imge setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://115.28.161.11:8080/XAI/appDownLoad/downLoadPhoto?path=%@",dic[@"pic"]]] placeholderImage:[UIImage imageNamed:@"servicezhanwei"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
    [_scrollView addSubview:imge];
    
    NSString*content=dic[@"content"];
    CGSize size1=[Utils takeTheSizeOfString:content withFont:kFontOfSize(15) withWeight:280];
    UILabel*label1=[Utils labelWithFrame:CGRectMake(20, 275, 280, size1.height) withTitle:content titleFontSize:kFontOfSize(15) textColor:kTextBlackColor alignment:NSTextAlignmentLeft];
    [_scrollView addSubview:label1];
    label1.numberOfLines=0;
    
    _scrollView.contentSize=CGSizeMake(kSizeOfScreen.width, label1.frame.size.height+label1.frame.origin.y+20);
}

@end
