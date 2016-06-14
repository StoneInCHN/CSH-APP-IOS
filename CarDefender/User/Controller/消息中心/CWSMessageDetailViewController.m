//
//  CWSMessageDetailViewController.m
//  CarDefender
//
//  Created by 李散 on 15/6/3.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSMessageDetailViewController.h"
#define kDistanceH 64
@interface CWSMessageDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation CWSMessageDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.detailDic[@"isRead"]) {
        NSString *itemId = [NSString stringWithFormat:@"%@",self.detailDic[@"id"]];
        UserInfo *userInfo = [UserInfo userDefault];
        [HttpHelper changeMessageStateWithUserId:userInfo.desc
                                           token:userInfo.token
                                          msgId:itemId
                                         success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                             NSLog(@"change message status :%@",responseObjcet);
                                             NSDictionary *dict = (NSDictionary *)responseObjcet;
                                             NSString *code = dict[@"code"];
                                             if ([code isEqualToString:SERVICE_SUCCESS]) {
                                                 userInfo.token = dict[@"token"];
                                             } else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                             } else {
                                             }
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    NSLog(@"data :%@",self.detailDic);
    [self stepUI];
}
- (void)stepUI {
    self.dateLabel.text = [Helper convertDateViaTimeStamp:[(NSString *)self.detailDic[@"createDate"] doubleValue]];
    self.detailLabel.text = self.detailDic[@"messageContent"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
