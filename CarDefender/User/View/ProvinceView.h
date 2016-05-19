//
//  ProvinceView.h
//  云车宝项目
//
//  Created by renhua on 14-8-6.
//  Copyright (c) 2014年 HCYunAPP. All rights reserved.
//
@protocol ProvinceViewDelegate <NSObject>

-(void)provinceViewWithBackMsg:(NSDictionary*)secondDic;

@end
#import <UIKit/UIKit.h>

@interface ProvinceView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    NSIndexPath*_oldIndexPath;
    NSArray*_currentArray;
}
@property (strong,nonatomic) UITableView*tableview;
@property (strong,nonatomic) NSArray*provincesArray;
@property (strong,nonatomic) NSDictionary*provinceString;
@property (assign,nonatomic) int chooseNub;
@property (assign,nonatomic) int currentChooseNub;

@property (strong,nonatomic) NSArray*saveArray;

@property (strong,nonatomic) id<ProvinceViewDelegate> delegate;

//@property (strong,nonatomic) nsar*dicMsg;
@property (strong,nonatomic) NSDictionary*reloadDic;
@end
