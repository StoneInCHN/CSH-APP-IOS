//
//  ReportCostDetailBtn.m
//  报告动画
//
//  Created by 李散 on 15/5/18.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "ReportCostDetailBtn.h"
#import "Define.h"
#define kDistanceWeight 10
#define kDistanceHeight 10/2
#define kImageWH 60
#define kLabelHeight 15
@implementation ReportCostDetailBtn

-(void)setCostMsg:(NSDictionary *)costMsg
{
    MyLog(@"%@",costMsg);
    CGFloat imageHeight;
    if (kSizeOfScreen.height<600) {
        imageHeight=48;
    }else{
        imageHeight=60;
    }//@[@"feiyong_tingche@2x",@"feiyong_xiche@2x"],@[@"feiyong_luqiao@2x",@"feiyong_baoyang@2x",@"feiyong_baoxian@2x"],@[@"feiyong_fakuan@2x"]
    NSDictionary*dic=@{@"cost":@[@"feiyong_jiayou@2x",@"燃油"],@"park":@[@"feiyong_tingche@2x",@"停车"],@"clean":@[@"feiyong_xiche@2x",@"洗车"],@"road":@[@"feiyong_luqiao@2x",@"路桥"],@"maintain":@[@"feiyong_baoyang@2x",@"保养"],@"insurance":@[@"feiyong_baoxian@2x",@"保险"],@"fine":@[@"feiyong_fakuan@2x",@"罚款"],@"add":@[@"feiyong_tianjia@2x",@"其他费用"]};
    self.backgroundColor=[UIColor clearColor];
    NSString*typeName=costMsg[@"type"];
    UIImageView*imgView=[[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-imageHeight)/2, kDistanceHeight, imageHeight, imageHeight)];
    imgView.image=[UIImage imageNamed:dic[typeName][0]];
    [self addSubview:imgView];
    
    UILabel*costMenu=[[UILabel alloc]initWithFrame:CGRectMake(0, imgView.frame.size.height+imgView.frame.origin.y+kDistanceHeight+3, self.frame.size.width, kLabelHeight)];
    costMenu.textColor=KBlackMainColor;
    costMenu.text=dic[typeName][1];
    
    costMenu.textAlignment=NSTextAlignmentCenter;
    costMenu.font=[UIFont fontWithName:@"Helvetica Neue" size:14];
    [self addSubview:costMenu];
    
    UILabel*costPrice=[[UILabel alloc]initWithFrame:CGRectMake(0, costMenu.frame.size.height+costMenu.frame.origin.y+kDistanceHeight-3, self.frame.size.width, kLabelHeight)];
    costPrice.textColor=kMainColor;
    if ([typeName isEqualToString:@"add"]) {
        costPrice.text=costMsg[@""];
    }else{
        costPrice.text=[NSString stringWithFormat:@"￥%@",costMsg[@"value"]];
    }
    costPrice.textAlignment=NSTextAlignmentCenter;
    costPrice.font=[UIFont fontWithName:@"Helvetica Neue" size:14];
    [self addSubview:costPrice];
}


@end
