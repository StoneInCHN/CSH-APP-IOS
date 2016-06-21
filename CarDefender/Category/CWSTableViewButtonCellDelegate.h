//
//  CWSTableViewButtonCellDelegate.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/6.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CWSCarWashDiscountModel;
@class CWSCarWashNormalModel;
@class CWSHistoryOrder;
@protocol CWSTableViewButtonCellDelegate <NSObject>


@optional
-(void)selectTableViewButtonClicked:(UIButton*)sender;

@optional
-(void)selectTableViewButtonClicked:(UIButton*)sender Red:(NSInteger)red ID:(NSInteger)idNumber andDataDict:(NSDictionary*)thyDict;



@optional
-(void)selectTableViewButtonClicked:(UIButton *)sender andDiscountModel:(CWSCarWashDiscountModel*)thyModel;

@optional
-(void)selectTableViewButtonClicked:(UIButton *)sender andDiscountModel:(CWSCarWashDiscountModel*)thyModel cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
-(void)selectTableViewButtonClicked:(UIButton *)sender andNormalModel:(CWSCarWashNormalModel*)thyModel;

@optional
-(void)selectTableViewButtonClicked:(UIButton*)sender andOrderHistoryModel:(CWSHistoryOrder*)thyModel;


@end
