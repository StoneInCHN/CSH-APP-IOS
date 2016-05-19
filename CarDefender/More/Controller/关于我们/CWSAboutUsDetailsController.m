//
//  CWSAboutUsDetailsController.m
//  CarDefender
//
//  Created by 周子涵 on 15/4/29.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSAboutUsDetailsController.h"

@interface CWSAboutUsDetailsController ()
@property (strong, nonatomic) IBOutlet UIView *functionView;
@property (strong, nonatomic) IBOutlet UIView *teamView;

@end

@implementation CWSAboutUsDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    if (self.type) {
        [self.functionView setFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height)];
        [self.view addSubview:self.functionView];
        UIView* view = [self.functionView viewWithTag:1013];
        [Utils setViewRiders:view riders:view.frame.size.width/2];
    }else{
        [self.teamView setFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height)];
        [self.view addSubview:self.teamView];
        for (int i = 1010; i< 1013; i++) {
            UIView* view = [self.teamView viewWithTag:i];
            [Utils setViewRiders:view riders:view.frame.size.width/2];
        }
    }
}

@end
