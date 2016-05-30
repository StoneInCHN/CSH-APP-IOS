//
//  CWSBoundIDViewController.m
//  CarDefender
//
//  Created by 万茜 on 16/1/7.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import "CWSBoundIDViewController.h"

@interface CWSBoundIDViewController ()

@end

@implementation CWSBoundIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绑定设备";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initalizeUserInterface];
    
    self.navigationController.navigationBar.barStyle=UIStatusBarStyleDefault;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:119/255.0 green:119/255.0 blue:119/255.0 alpha:1]];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                               initWithTitle:@"返回"
                                               style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(backBarButtonItemClick)];
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: KBlackMainColor,UITextAttributeFont : [UIFont systemFontOfSize:18]};
    
    
}

- (void)backBarButtonItemClick
{
    if(self.idField.text.length >0  ){
        [[UIApplication sharedApplication].keyWindow.rootViewController.navigationController popToRootViewControllerAnimated:YES];
    }else {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入设备号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)initalizeUserInterface
{
    self.view = [[[NSBundle mainBundle] loadNibNamed:@"BoundIDView" owner:self options:nil] lastObject];
    self.idField.text = self.boundIdString;
}
-(void)boundCarDivice{
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:KUserInfo.desc forKey:@"userId"];
    [dataDic setObject:KUserInfo.token forKey:@"token"];
    [dataDic setObject:self.idString forKey:@"vehicleId"];
    [dataDic setObject:self.idField.text forKey:@"deviceNo"];
    NSLog(@"datadic%@",dataDic);
    [MBProgressHUD showMessag:@"保存中..." toView:self.view];
    [HttpHelper insertBindDeviceWithUserDic:dataDic success:^(AFHTTPRequestOperation *operation,id object){
        NSLog(@"decic=%@",object);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *objectDic = (NSDictionary*)object;
        NSLog(@"%@==%@",KUserManager.userCID,self.idString);
        if ([objectDic[@"code"] isEqualToString:SERVICE_SUCCESS]) {
            if (KUserManager.userCID == nil || [self.idString isEqualToString:[NSString stringWithFormat:@"%@",KUserManager.userCID]]) {
                NSUserDefaults* thyUserDefaults = [NSUserDefaults standardUserDefaults];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[thyUserDefaults objectForKey:@"userDefaultVehicle"]];
                [dic setValue:self.idField.text forKey:@"device"];
                [thyUserDefaults setValue:dic forKey:@"userDefaultVehicle"];
                [NSUserDefaults resetStandardUserDefaults];
                KUserManager.userDefaultVehicle = [thyUserDefaults objectForKey:@"userDefaultVehicle"];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"desc"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
            }
        }else{
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"desc"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        
        }
        
    
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络出错,请重新加载" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];

}
- (IBAction)confirmButtonClick:(UIButton *)sender {
    if (self.idField.text.length > 0) {
        [self boundCarDivice];
        /*[MBProgressHUD showMessag:@"保存中..." toView:self.view];
        [ModelTool insertBindVehicleInfoWithParameter:@{@"uid":KUserManager.uid,@"mobile":KUserManager.mobile,@"cid":KUserManager.userCID,@"device":self.idField.text} andSuccess:^(id object) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]){
                    MyLog(@"------bind----%@",object[@"message"]);
                    MyLog(@"------bind----%@",object);
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                    if (KUserManager.userCID == nil || [self.idString isEqualToString:[NSString stringWithFormat:@"%@",KUserManager.userCID]]) {
                        NSUserDefaults* thyUserDefaults = [NSUserDefaults standardUserDefaults];
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[thyUserDefaults objectForKey:@"userDefaultVehicle"]];
                        [dic setValue:self.idField.text forKey:@"device"];
                        [thyUserDefaults setValue:dic forKey:@"userDefaultVehicle"];
                        [NSUserDefaults resetStandardUserDefaults];
                        KUserManager.userDefaultVehicle = [thyUserDefaults objectForKey:@"userDefaultVehicle"];
                    }
                    
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
            });
        } andFail:^(NSError *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络出错,请重新加载" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];*/
    }
    else {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入设备号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

@end
