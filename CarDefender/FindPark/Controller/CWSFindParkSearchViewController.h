//
//  CWSFindParkSearchViewController.h
//  CarDefender
//
//  Created by 万茜 on 15/12/12.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FindParkSearchDelegate <NSObject>
@optional

-(void)destinationClickWithPt:(CLLocationCoordinate2D)pt City:(NSString*)city;
@end

@interface CWSFindParkSearchViewController : UIViewController
@property (assign, nonatomic) id<FindParkSearchDelegate>delegate;
@end
