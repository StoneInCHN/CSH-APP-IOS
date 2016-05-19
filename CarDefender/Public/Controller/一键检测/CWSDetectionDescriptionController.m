//
//  CWSDetectionDescriptionController.m
//  CarDefender
//  检测项说明
//  Created by 李散 on 15/6/29.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSDetectionDescriptionController.h"

@interface CWSDetectionDescriptionController ()
@property (strong, nonatomic) IBOutlet UIView *baseVeiw;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end

@implementation CWSDetectionDescriptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"检测项说明";
    [Utils changeBackBarButtonStyle:self];
    CGRect baseFrame=self.baseVeiw.frame;
    baseFrame = CGRectMake(10, 0, self.baseVeiw.frame.size.width, self.baseVeiw.frame.size.height);
    self.baseVeiw.frame = baseFrame;
    
    [self.scrollview addSubview:self.baseVeiw];
    self.scrollview.contentSize = CGSizeMake(0, self.baseVeiw.frame.size.height);
}



@end
