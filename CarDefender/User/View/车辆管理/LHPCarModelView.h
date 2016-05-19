//
//  LHPCarModelView.h
//  云车宝选车Demo
//
//  Created by pan on 14/12/19.
//  Copyright (c) 2014年 pan. All rights reserved.
//
@protocol LHPCarModelViewDelegate <NSObject>

-(void)carModelViewCellSelect:(NSDictionary*)dic;

@end
#import <UIKit/UIKit.h>
#import "YCBJuhuaVew.h"
@interface LHPCarModelView : UIView<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView*_modelTableView;
    NSArray*_modelArray;
    YCBJuhuaVew*_juhuaView;
    NSDictionary*_dicMsg;
}
@property (strong, nonatomic) NSDictionary *modelCarDic;
@property (assign, nonatomic) id<LHPCarModelViewDelegate>delegate;
@end
