//
//  CWSChooseCarModelView.h
//  CarDefender
//
//  Created by 李散 on 15/4/7.
//  Copyright (c) 2015年 SKY. All rights reserved.
//
@protocol CWSChooseCarModelViewDelegate <NSObject>

-(void)CWSChooseCarModelViewCellSelect:(NSDictionary*)modelCarMsg;

@end
#import <UIKit/UIKit.h>

@interface CWSChooseCarModelView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    NSArray*_currentArray;
    UITableView*_modelTabelView;
}
@property(nonatomic,strong)NSMutableArray*modelArray;
@property(nonatomic,assign)id<CWSChooseCarModelViewDelegate>delegate;
@end
