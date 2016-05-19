//
//  CWSNikenameViewController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/3.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSNikenameViewController.h"


@interface CWSNikenameViewController ()

@end

@implementation CWSNikenameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"昵称";
    [Utils changeBackBarButtonStyle:self];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.textField = (UITextField *)[self.view viewWithTag:1];
    self.textField.placeholder = @"请输入您的昵称";
    UIBarButtonItem*rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(inputComplate:)];
    rightBtn.tintColor = [UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1];
    self.navigationItem.rightBarButtonItem=rightBtn;
}

-(void)inputComplate:(UIBarButtonItem*)sender
{
    UserInfo *userInfo = [UserInfo userDefault];
    [MBProgressHUD showMessag:@"保存中..." toView:self.view];
    [HttpHelper changeUserInfoWithUserId:userInfo.desc
                                   token:userInfo.token
                                nickName:self.textField.text
                                    sign:userInfo.signature
                                 success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                        NSDictionary *dict = (NSDictionary *)responseObjcet;
                                        if ([dict[@"code"] isEqualToString:SERVICE_SUCCESS]) {
                                            [self.navigationController popViewControllerAnimated:YES];
                                            userInfo.nickName = dict[@"msg"][@"nickName"];
                                        } else {
                                            [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                        }
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求有问题,请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                        [alert show];
                                    }];
}
@end
