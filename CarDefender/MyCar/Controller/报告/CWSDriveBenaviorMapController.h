//
//  CWSDriveBenaviorMapController.h
//  CarDefender
//
//  Created by 周子涵 on 15/5/23.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

@interface CWSDriveBenaviorMapController : UIViewController<BMKMapViewDelegate>
{
    BMKMapView* _mapView;
}
@property (strong, nonatomic) NSString* address;
@property (strong, nonatomic) NSString* lat;
@property (strong, nonatomic) NSString* lon;
@end
