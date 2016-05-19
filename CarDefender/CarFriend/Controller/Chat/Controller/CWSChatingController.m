//
//  CWSChatingController.m
//  CarDefender
//
//  Created by 李散 on 15/4/1.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSChatingController.h"

@interface CWSChatingController ()

@end

@implementation CWSChatingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
