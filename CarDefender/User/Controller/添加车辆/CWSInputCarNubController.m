//
//  CWSInputCarNubController.m
//  CarDefender
//
//  Created by 李散 on 15/4/9.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSInputCarNubController.h"
#import "TSLocateView.h"
#import "CWSAddCarController.h"
@interface CWSInputCarNubController ()<UIActionSheetDelegate,UITextFieldDelegate>
{
    BOOL upDown;
    TSLocateView*_locateView;
}
@end

@implementation CWSInputCarNubController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加车牌号";
    [Utils changeBackBarButtonStyle:self];
    self.carNubText.keyboardType=UIKeyboardTypeAlphabet;
    if (self.carNubAllString.length==7) {
        self.simpleCarNubLabel.text=[self.carNubAllString substringWithRange:NSMakeRange(0, 1)];
        self.carNubText.text=[self.carNubAllString substringWithRange:NSMakeRange(1, 6)];
    }else{
        if (self.shortString.length) {
            self.simpleCarNubLabel.text=self.shortString;
        }else{
            self.simpleCarNubLabel.text=@"选择";
        }
    }

    self.carNubText.delegate=self;
    [self.carNubText addTarget:self action:@selector(textEidtChange:) forControlEvents:UIControlEventEditingChanged];
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
    [self.view addGestureRecognizer:tapGesture];
    upDown=NO;
    UIBarButtonItem*rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(carNubMsgOk:)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    [self.carNubText becomeFirstResponder];
    
    CGRect carNubFrame = self.carNubView.frame;
    carNubFrame.origin.y+=kTO_TOP_DISTANCE;
    self.carNubView.frame = carNubFrame;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.carNubText resignFirstResponder];
    [ModelTool stopAllOperation];
}
-(void)carNubMsgOk:(UIBarButtonItem*)sender
{
    if (self.simpleCarNubLabel.text.length==2) {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择车牌的省份简称" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (self.carNubText.text.length==6) {
        if ([self isValidateEmail:[NSString stringWithFormat:@"%@%@",self.simpleCarNubLabel.text,self.carNubText.text]]) {
            if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] isKindOfClass:[CWSAddCarController class]]) {
                CWSAddCarController *addCarVC = (CWSAddCarController *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
                addCarVC.carNubString = [NSString stringWithFormat:@"%@%@",self.simpleCarNubLabel.text,self.carNubText.text];
                [self.navigationController popToViewController:addCarVC animated:YES];
            }
        }else{
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"车牌格式有误，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }else{
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"车牌号码输入有误，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"^[\u4e00-\u9fa5|WJ]{1}[A-Z0-9]{6}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
-(void)Actiondo:(UIGestureRecognizer*)sender{
//    [self.carNubText resignFirstResponder];
    [_locateView removeFromSuperview];
    _locateView=nil;
    upDown=NO;
//    self.upDownImage.image=[UIImage imageNamed:@"user_up.png"];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [_locateView removeFromSuperview];
    _locateView=nil;
    upDown=NO;
//    self.upDownImage.image=[UIImage imageNamed:@"user_up.png"];
    return YES;
}
-(void)textEidtChange:(UITextField*)sender
{
    sender.text=sender.text.uppercaseString;
    if (sender.text.length>6) {
        sender.text=[sender.text substringWithRange:NSMakeRange(0, 6)];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.carNubText resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseSimpleNub:(id)sender {
    [self.carNubText resignFirstResponder];
    if (upDown) {
//        self.upDownImage.image=[UIImage imageNamed:@"user_up.png"];
        [_locateView removeFromSuperview];
        _locateView=nil;
    }else{
//        self.upDownImage.image=[UIImage imageNamed:@"user_down.png"];
        if (_locateView==nil) {
            _locateView = [[TSLocateView alloc] initWithTitle:@"定位城市" delegate:self];
            [_locateView showInView:self.view];
        }
    }
    upDown=!upDown;
}
-(void)changeUPDOWNimage
{
    if (upDown) {
//        self.upDownImage.image=[UIImage imageNamed:@"user_up.png"];
    }else{
//        self.upDownImage.image=[UIImage imageNamed:@"user_down.png"];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    TSLocateView *locateView = (TSLocateView *)actionSheet;
    TSLocation *location = locateView.locate;
    self.simpleCarNubLabel.text=location.city;
    if(buttonIndex == 0) {
        MyLog(@"Cancel");
    }else {
        MyLog(@"Select");
    }
}

@end
