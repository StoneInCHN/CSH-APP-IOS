//
//  ShopNameView.m
//  CarDefender
//
//  Created by 万茜 on 15/12/8.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "ShopNameView.h"
#import "UIImageView+WebCache.h"

@interface ShopNameView()<UIAlertViewDelegate>
{
    NSDictionary *dataDic;
    BMNavController *theController;
}
@end


@implementation ShopNameView

- (instancetype)initWithFrame:(CGRect)frame Data:(NSDictionary *)dic controller:(BMNavController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ShopNameView" owner:self options:nil] lastObject];
        self.frame = frame;
        dataDic = [NSDictionary dictionaryWithDictionary:dic];
        theController = controller;
        [self showUI];
    }
    return self;
    
    
}

- (void)showUI
{
    for(int i=0; i<3; i++){
        
        UIImageView* diamondImg = [[UIImageView alloc]initWithFrame:CGRectMake(i*16, 0, 15, 15)];
        diamondImg.image = [UIImage imageNamed:@"haoping"];
        [self.storeReviewView addSubview:diamondImg];
        if(i == 2){
//            UILabel* reviewLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(diamondImg.frame)+4, 0, kSizeOfScreen.width, 13)];
//            reviewLabel.text = [NSString stringWithFormat:@"%@好评",dataDic[@"reputation"]];
//            reviewLabel.font = [UIFont systemFontOfSize:15.0f];
//            reviewLabel.textColor = kCOLOR(255, 102, 0);
//            [self.storeReviewView addSubview:reviewLabel];
        }
    }
    
    
    [self.headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,dataDic[@"tenantInfo"][@"photo"]]] placeholderImage:[UIImage imageNamed:@"zhaochewei_img"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
    self.shopNameLabel.text = dataDic[@"tenantInfo"][@"tenantName"];
    self.addressLabel.text = dataDic[@"tenantInfo"][@"address"];
    [self.phoneButtton addTarget:self action:@selector(phoneButttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.locationButton addTarget:self action:@selector(locationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - phoneButttonClick
- (void)phoneButttonClick:(UIButton *)sender
{
    
    
    NSString *string = [NSString stringWithFormat:@"%@",dataDic[@"tenantInfo"][@"contactPhone"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    [alert show];
    
    
}


#pragma mark - locationButtonClick
- (void)locationButtonClick:(UIButton *)sender
{
    MyLog(@"-----------%f %f",KManager.currentPt.latitude,KManager.currentPt.longitude);
    NSString *latitude = [NSString stringWithFormat:@"%@",dataDic[@"tenantInfo"][@"latitude"]] ;
    NSString *longitude = [NSString stringWithFormat:@"%@",dataDic[@"tenantInfo"][@"longitude"]];
    if(![latitude isEqualToString:@"<null>"]&&![longitude isEqualToString:@"<null>"]){
        CLLocationCoordinate2D pt = CLLocationCoordinate2DMake([dataDic[@"tenantInfo"][@"latitude"] floatValue], [dataDic[@"tenantInfo"][@"longitude"] floatValue]);
        [theController startNaviWithNewPoint:pt OldPoint:KManager.currentPt];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",dataDic[@"tenantInfo"][@"contactPhone"]]]];
    }
}



@end
