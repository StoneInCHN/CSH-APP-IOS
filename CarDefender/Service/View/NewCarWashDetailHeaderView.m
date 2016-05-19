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

@interface NewCarWashDetailHeaderView()<UIAlertViewDelegate>
@property (nonatomic,strong)NSString *telString;
@property (nonatomic,assign)CLLocationCoordinate2D pt;
@property (nonatomic,strong)BMNavController *controller;
@end

@implementation NewCarWashDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame Data:(NSDictionary *)dic controller:(BMNavController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"NewCarWashDetailHeaderView" owner:self options:nil] lastObject];
        
        
        [self.storeImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"baseUrl"],dic[@"image_1"]]] placeholderImage:[UIImage imageNamed:@"zhaochewei_img"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
        
        self.storeNameLabel.text = dic[@"store_name"];
        self.storeBusinessHoursLabel.text = [NSString stringWithFormat:@"营业时间:%@",dic[@"business_time"]];
        self.storeAddressLabel.text = dic[@"address"];
        
        self.telString = dic[@"tel"];
        self.pt = CLLocationCoordinate2DMake([dic[@"im_lat"] floatValue], [dic[@"im_lng"] floatValue]);
        self.controller = controller;
    }
    return self;
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
