//
//  RepairCell.m
//  CarDefender
//
//  Created by 周子涵 on 15/4/8.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "RepairCell.h"
#import "UIImageView+WebCache.h"
@implementation RepairCell
-(void)setDicMsg:(NSDictionary *)dicMsg
{
    _currentDic=dicMsg;
    self.nameLabel.text=dicMsg[@"title"];
    self.addressLabel.text=dicMsg[@"addr"];
    NSString*url=[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"baseUrl"],dicMsg[@"photo"]];
    NSURL*logoImgUrl=[NSURL URLWithString:url];
    [self.companyImage setImageWithURL:logoImgUrl placeholderImage:[UIImage imageNamed:@"servicezhanwei"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
    //计算距离
    CLLocation * location1 = [[CLLocation alloc] initWithLatitude:KManager.currentPt.latitude longitude:KManager.currentPt.longitude];
    CLLocation * location2 = [[CLLocation alloc] initWithLatitude:[dicMsg[@"lat"] floatValue] longitude:[dicMsg[@"lng"] floatValue]];
    double length = [Utils getMetersBefore:location2 Current:location1];
    if (length>1000) {
        length = length/1000;
        self.distabceLabel.text=[NSString stringWithFormat:@"%.1fkm",length];
    }else{
        self.distabceLabel.text=[NSString stringWithFormat:@"%dm",(int)length];
    }
    _telNub=dicMsg[@"tel"];
    if (_telNub.length) {
        self.phoneBtn.hidden=NO;
        self.telBtn.userInteractionEnabled=YES;
    }
    repairOrOther=NO;
}
-(void)setRepairMsgDic:(NSDictionary *)repairMsgDic
{
    repairOrOther=YES;
    _currentDic=repairMsgDic;
    self.nameLabel.text=repairMsgDic[@"name"];
    self.addressLabel.text=repairMsgDic[@"address"];
    NSString*url=[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"baseUrl"],repairMsgDic[@"photo"]];
    NSURL*logoImgUrl=[NSURL URLWithString:url];
    [self.companyImage setImageWithURL:logoImgUrl placeholderImage:[UIImage imageNamed:@"servicezhanwei"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
    //计算距离
    CLLocation * location1 = [[CLLocation alloc] initWithLatitude:KManager.currentPt.latitude longitude:KManager.currentPt.longitude];
    CLLocation * location2 = [[CLLocation alloc] initWithLatitude:[repairMsgDic[@"location"][@"lat"] floatValue] longitude:[repairMsgDic[@"location"][@"lng"] floatValue]];
    double length = [Utils getMetersBefore:location2 Current:location1];
    if (length>1000) {
        length = length/1000;
        self.distabceLabel.text=[NSString stringWithFormat:@"%.1fkm",length];
    }else{
        self.distabceLabel.text=[NSString stringWithFormat:@"%dm",(int)length];
    }
    
    NSArray*allKey=[repairMsgDic allKeys];
    if ([allKey containsObject:@"additionalInformation"]) {
        _telNub=repairMsgDic[@"additionalInformation"][@"telephone"];
        if (_telNub.length==0) {//电话为空
            self.phoneBtn.hidden=YES;
            self.telBtn.userInteractionEnabled=NO;
        }
    }else{
        self.phoneBtn.hidden=YES;
        self.telBtn.userInteractionEnabled=NO;
    }
}
- (IBAction)phoneBtnClick:(UIButton *)sender {
    MyLog(@"%@",sender.titleLabel.text);
}
- (IBAction)makePhoneCall:(id)sender {
    
    MyLog(@"%@",_currentDic[@"tel"]);
    
    
    if (repairOrOther) {//维修保养数据
        NSArray*allKey=[_currentDic allKeys];
        if ([allKey containsObject:@"additionalInformation"]) {
            _telNub=_currentDic[@"additionalInformation"][@"telephone"];
            if (_telNub.length==0) {//电话为空
                
            }else if (_telNub.length>15){//有多个电话
                NSString * fruits = _telNub;
                NSArray  * array= [fruits componentsSeparatedByString:@","];
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:_currentDic[@"name"] message:@"选择拨打的号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                for (NSString*telNubString in array) {
                    [alert addButtonWithTitle:telNubString];
                }
                [alert show];
            }else{//只有一个电话
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_currentDic[@"additionalInformation"][@"telephone"]]]];
            }
        }
        
    }else{//其他的数据
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_currentDic[@"tel"]]]];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString*title=[alertView buttonTitleAtIndex:buttonIndex];
    if (![title isEqualToString:@"取消"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",title]]];
    }
}
@end
