//
//  CWSFindCarLocationController.h
//  CarDefender
//
//  Created by 周子涵 on 15/3/30.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNRoutePlanModel.h"
#import "BNCoreServices.h"
#import "CWSParkCell.h"
#import "Park.h"
#import "Interest.h"
#import "MJRefresh.h"
#import "FindMapData.h"
#import "CWSFindMapView.h"

@interface CWSFindCarLocationController : UIViewController<BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate,UITableViewDataSource,UITableViewDelegate,CWSFindMapDelegate>
{
    UITableView*             _tableView;
    UIView*                  _fenLanView;
    UIButton*                _currentBtn;
    NSMutableArray*          _dataArray;
    CLLocationCoordinate2D   _oldPt;
    CLLocationCoordinate2D   _newPt;
    BOOL                     _traffic;
    CWSFindMapView*          _findMapView;
    BOOL                     _nearbyCar;
    NSString*                _subCity;
}
//导航类型，分为模拟导航和真实导航
@property (assign, nonatomic) BN_NaviType naviType;
@property (strong, nonatomic) NSString* type;
@property (weak, nonatomic) IBOutlet UILabel *footNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *footAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *footDistanceBtn;
@property (weak, nonatomic) IBOutlet UIButton *trafficBtn;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (assign, nonatomic) int findMapViewType;



- (IBAction)qiehuanbtnClick:(UIButton *)sender;
- (IBAction)goBtnClick;
- (IBAction)addBtnClick:(UIButton *)sender;

- (void)creatTableView;
- (void)creatMapView;
- (void)startNavi;
- (void)getHttpData:(CLLocationCoordinate2D)coordinate nearbyCar:(BOOL)nearbyCar type:(int)type;
-(void)reloadFootView:(Interest*)interest;
-(void)carLocationPoint:(CLLocationCoordinate2D)point;
@end
