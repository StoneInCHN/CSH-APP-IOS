//
//  ChoseDatePikerView.h
//  CarDefender
//
//  Created by DRiPhion on 16/6/7.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoseDatePikerViewDelegate <NSObject>

-(void)sureBtnCommitOrderButton:(UIButton*)button goodDic:(NSDictionary*)goodDic;

@end

@interface ChoseDatePikerView : UIView
@property(nonatomic,weak)id<ChoseDatePikerViewDelegate>delegate;
@property(nonatomic,strong)NSDictionary *goodDic;  //商品信息
@property(nonatomic,strong)NSDictionary *orderDic;  //订单信息
@end
