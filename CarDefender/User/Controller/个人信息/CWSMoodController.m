//
//  CWSMoodController.m
//  CarDefender
//
//  Created by 周子涵 on 15/6/4.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSMoodController.h"

@interface CWSMoodController ()

@end

@implementation CWSMoodController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个性签名";
    [Utils changeBackBarButtonStyle:self];
//    NSDictionary* dic = @{@"uid":KUserManager.uid,
//                          @"key":KUserManager.key,
//                          @"note":[@"大山之上" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]};
//    [ModelTool httpUploadNoteWithParameter:dic success:^(id object) {
//        NSDictionary* lDic = object;
//        MyLog(@"%@",lDic);
//    } faile:^(NSError *err) {
//        
//    }];
}

- (IBAction)submitBtnClick {
    MyLog(@"%@",self.textView.text);
}
@end
