//
//  CWSFootprintDetailsController.h
//  CarDefender
//
//  Created by 周子涵 on 15/4/21.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import "Footprint.h"

@interface CWSFootprintDetailsController : UIViewController<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate>
{
    BMKRouteSearch*    _routesearch;
    BMKGeoCodeSearch* _geocodesearch;
}
@property (strong, nonatomic) NSArray* loacationArray;
@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) Footprint* footprint;
@property (strong, nonatomic) NSString* lat;
@property (strong, nonatomic) NSString* lon;
@end
