//
//  LHPTCarStyleView.h
//  云车宝选车Demo
//
//  Created by pan on 14/12/19.
//  Copyright (c) 2014年 pan. All rights reserved.
//
@protocol LHPTCarStyleViewDelegate <NSObject>

-(void)carStyleViewCellSelectDic:(NSDictionary*)dic;

@end
#import <UIKit/UIKit.h>
#import "YCBJuhuaVew.h"
@interface LHPTCarStyleView : UIView<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView*_styleTableView;
    NSArray*_styleArray;
    UILabel*_topLabel;
    UILabel*_carName;
    UIImageView*_carImg;
    NSIndexPath *_selectPath;
    YCBJuhuaVew*_juhuaView;
    NSDictionary*_dicMsg;
}
@property (strong, nonatomic) NSDictionary*carModelDicMsg;
@property (strong, nonatomic) NSString*topString;
@property (assign, nonatomic) id<LHPTCarStyleViewDelegate>delegate;
@end
