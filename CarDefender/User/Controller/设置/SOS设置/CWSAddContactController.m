//
//  CWSAddContactController.m
//  CarDefender
//
//  Created by 李散 on 15/7/31.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSAddContactController.h"
#import "ModelTool.h"
#import "CWSSOSSettingController.h"
@interface CWSAddContactController ()<UITextFieldDelegate>
{
    UITextField *_nameText;
    UITextField *_telText;
}
@end

@implementation CWSAddContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    [self buildUI];
    if (self.dicMsg) {
        _nameText.text = self.dicMsg[@"name"];
        _telText.text = self.dicMsg[@"tel"];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ModelTool stopAllOperation];
}

-(void)buildUI
{
    if ([self.title isEqualToString:@"编辑联系人"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(editORAddContectSuccess:)];
    }else if ([self.title isEqualToString:@"新增联系人"]){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(editORAddContectSuccess:)];
    }
    self.view.backgroundColor = kCOLOR(245, 245, 245);
    
    UIView*view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kSizeOfScreen.width, 44)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    UILabel*nameLabel = [Utils labelWithFrame:CGRectMake(20, 0, 40, 44) withTitle:@"称呼" titleFontSize:kFontOfSize(16) textColor:kCOLOR(51, 51, 51) alignment:NSTextAlignmentLeft];
    [view1 addSubview:nameLabel];
    
    _nameText = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, kSizeOfScreen.width - 100, 44)];
    _nameText.placeholder = @"请输入您对TA的称呼";
    _nameText.borderStyle = UITextBorderStyleNone;
    [view1 addSubview:_nameText];
    _nameText.textColor = kCOLOR(102, 102, 102);
    _nameText.delegate = self;
    
    UIView*view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 20+45, kSizeOfScreen.width, 44)];
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];
    UILabel*telLabel = [Utils labelWithFrame:CGRectMake(20, 0, 40, 44) withTitle:@"手机" titleFontSize:kFontOfSize(16) textColor:kCOLOR(51, 51, 51) alignment:NSTextAlignmentLeft];
    [view2 addSubview:telLabel];
    _telText = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, kSizeOfScreen.width - 100, 44)];
    _telText.placeholder = @"请输入对方手机号码";
    _telText.borderStyle = UITextBorderStyleNone;
    _telText.keyboardType = UIKeyboardTypeNumberPad;
    [view2 addSubview:_telText];
    _telText.textColor = kCOLOR(102, 102, 102);
    _telText.delegate=self;
}
#pragma mark - 编辑或新增联系人完成
-(void)editORAddContectSuccess:(UIBarButtonItem*)sender
{
    if (!_nameText.text.length) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"称呼不能为空，请输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    };
    if (![Utils isValidateMobile:_telText.text]) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码有误，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    [MBProgressHUD showMessag:@"提交中..." toView:self.view];
    
    if (self.dicMsg) {
        [ModelTool httpAppEditSosWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key,@"name":[_nameText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"tel":_telText.text,@"sid":self.dicMsg[@"id"]} success:^(id object) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                    if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] isKindOfClass:[CWSSOSSettingController class]]) {
                        CWSSOSSettingController*sosVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
                        sosVC.typeBack = @"编辑回来了";
                        [self.navigationController popToViewController:sosVC animated:YES];
                    }
                }
            });
        } faile:^(NSError *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }else{
        [ModelTool httpAppUpSosWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key,@"name":[_nameText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"tel":_telText.text} success:^(id object) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                    if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] isKindOfClass:[CWSSOSSettingController class]]) {
                        CWSSOSSettingController*sosVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
                        sosVC.typeBack = @"添加联系人回来了";
                        [self.navigationController popToViewController:sosVC animated:YES];
                    }
                }
            });
        } faile:^(NSError *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
