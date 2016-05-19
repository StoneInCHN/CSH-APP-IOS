//
//  Manager.h
//  CarDefender
//
//  Created by 周子涵 on 15/4/16.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Manager : NSObject
@property (strong, nonatomic) NSString* lat;
@property (strong, nonatomic) NSString* lng;
@property (strong, nonatomic) NSString* currentController;
@property (strong, nonatomic) NSString* currentCity;
@property (strong, nonatomic) NSString* currentSubCity;
@property (strong,nonatomic)  NSString* currentStreetName;
@property (strong,nonatomic)  NSString* currentStreetNumber;
@property (strong, nonatomic) NSString* currentCityID;
@property (assign, nonatomic) CLLocationCoordinate2D currentPt;
@property (assign, nonatomic) CLLocationCoordinate2D mobileCurrentPt;

@property (strong, nonatomic) NSString* carLat;
@property (strong, nonatomic) NSString* carLng;

+(Manager *)shareManagerInfo;
@end
