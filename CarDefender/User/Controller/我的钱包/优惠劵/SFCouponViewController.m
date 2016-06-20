//
//  SFCouponViewController.m
//  CarDefender
//
//  Created by sicnu_ifox on 16/6/19.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "SFCouponViewController.h"
#import "CWSActivityViewController.h"
#import "SFCarWashViewController.h"

@interface SFCouponViewController () {
    SFCarWashViewController *_carWashVC;
    CWSActivityViewController *_activityVC;
}

@end

@implementation SFCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    [self onSegmentedEvent:self.segmentedControl];
}
- (IBAction)onSegmentedEvent:(id)sender {
    [self.segmentedView removeSubviews];
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    if (segment.selectedSegmentIndex == 0) {
        if (!_activityVC) {
           _activityVC = [[CWSActivityViewController alloc] initWithNibName:@"CWSActivityViewController" bundle:nil];
            [self addChildViewController:_activityVC];
        }
        [self.segmentedView addSubview:_activityVC.view];

    } else {
        if (!_carWashVC) {
            _carWashVC = [[SFCarWashViewController alloc] init];
            [self addChildViewController:_carWashVC];
        }
        [self.segmentedView addSubview:_carWashVC.view];
    }
}



@end
