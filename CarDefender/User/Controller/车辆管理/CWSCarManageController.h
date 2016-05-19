//
//  CWSCarManageController.h
//  CarDefender
//
//  Created by 周子涵 on 15/3/28.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

@interface CWSCarManageController : UIViewController<BMKMapViewDelegate,BMKGeoCodeSearchDelegate>
{
    bool                     isGeoSearch;
    BMKGeoCodeSearch*        _geocodesearch;
}
@property (strong, nonatomic) IBOutlet UIView *headView;
- (IBAction)deleHeadView:(id)sender;
@property (strong, nonatomic)NSString*chooseCostOK;//选择完费用后

@property (strong, nonatomic) NSString *backMsg;//需要跟新数据标志位


@property (nonatomic,assign)NSInteger tag;//tag为1是买车险页面的切换车辆跳转的
@end
