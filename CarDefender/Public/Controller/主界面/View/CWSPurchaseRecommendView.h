//
//  CWSPurchaseRecommendView.h
//  carLife
//
//  Created by MichaelFlynn on 12/2/15.
//  Copyright © 2015 王泰莅. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CWSTableViewButtonCellDelegate.h"

@class CWSMainViewController;
@interface CWSPurchaseRecommendView : UIView<UITableViewDataSource,UITableViewDelegate,CWSTableViewButtonCellDelegate>

@property (nonatomic,strong) UITableView* myTableView;
@property (nonatomic,strong) NSArray* storeDataArray;

@property (nonatomic,strong) CWSMainViewController* rootVc;

@end
