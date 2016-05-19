//
//  CWSCarManagerDeviceOkController.m
//  CarDefender
//
//  Created by 李散 on 15/6/6.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSCarManagerDeviceOkController.h"
#import "CWSCarMangerChooseOKController.h"
#import "CWSExplainIntegralController.h"
@interface CWSCarManagerDeviceOkController ()
{
    UIView *_backView;
    
    NSMutableDictionary*_bodyDic;
    
    BOOL _moneyAndCalling;
}
@end

@implementation CWSCarManagerDeviceOkController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
    _moneyAndCalling=NO;
    [Utils changeBackBarButtonStyle:self];
    _bodyDic=[NSMutableDictionary dictionary];
    [_bodyDic setObject:KUserManager.key forKey:@"key"];
    [_bodyDic setObject:KUserManager.uid forKey:@"uid"];
    if (self.carCid.length) {
        [_bodyDic setObject:self.carCid forKey:@"cid"];
    }
}
-(void)buildUI
{
    [Utils setViewRiders:self.btn1 riders:4];
    [Utils setViewRiders:self.btn2 riders:4];
    [Utils setViewRiders:self.btn5 riders:4];
    [Utils setViewRiders:self.btn6 riders:4];
    [Utils setViewRiders:self.notiview riders:4];
    [self.view bringSubviewToFront:self.label1];
    [self.view bringSubviewToFront:self.label2];
    [self.view bringSubviewToFront:self.label3];
    [self.view bringSubviewToFront:self.label4];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)buildBackView
{
    if (_backView==nil) {
        _backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height+20)];
        _backView.backgroundColor=kCOLOR(0, 0, 0);
        _backView.alpha=0.5;
    }
    [self.view addSubview:_backView];
}
- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1://300话费
        {
            [self buildBackView];
            self.notiview.frame=CGRectMake((kSizeOfScreen.width-self.notiview.frame.size.width)/2, (kSizeOfScreen.height-64-self.notiview.frame.size.height)/2, self.notiview.frame.size.width, self.notiview.frame.size.height);
            self.msgLabel.text=@"您确认选择 “300话费即时到账” ？";
            [self.view addSubview:self.notiview];
            [self.view bringSubviewToFront:self.notiview];
            [_bodyDic setObject:@"1" forKey:@"type"];
        }
            break;
        case 2://398分期
        {
            [self buildBackView];
            self.notiview.frame=CGRectMake((kSizeOfScreen.width-self.notiview.frame.size.width)/2, (kSizeOfScreen.height-64-self.notiview.frame.size.height)/2, self.notiview.frame.size.width, self.notiview.frame.size.height);
            self.msgLabel.text=@"您确认选择 “398分期返费” ？";
            [self.view addSubview:self.notiview];
            [self.view bringSubviewToFront:self.notiview];
            [_bodyDic setObject:@"2" forKey:@"type"];
        }
            break;
        case 3://关于话费
        {
            _moneyAndCalling=YES;
            CWSExplainIntegralController*explainVC=[[CWSExplainIntegralController alloc]initWithNibName:@"CWSExplainIntegralController" bundle:nil];
            explainVC.title=@"话费说明";
            explainVC.type=@"huafei";
            explainVC.managerConmeHere=@"managerCome";
            [self.navigationController pushViewController:explainVC animated:YES];
        }
            break;
        case 4://关于返费
        {
            _moneyAndCalling=YES;
            CWSExplainIntegralController*explainVC=[[CWSExplainIntegralController alloc]initWithNibName:@"CWSExplainIntegralController" bundle:nil];
            explainVC.title=@"返费说明";
            explainVC.type=@"fanfei";
            explainVC.managerConmeHere=@"managerCome";
            [self.navigationController pushViewController:explainVC animated:YES];
        }
            break;
        case 5://确定
        {
            [_backView removeFromSuperview];
            [self.notiview removeFromSuperview];
            [self showHudInView:self.view hint:@"数据保存中..."];
            [ModelTool httpAppChooseFeedWithParameter:_bodyDic success:^(id object) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    MyLog(@"%@",object);
                    [self hideHud];
                    if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                        CWSCarMangerChooseOKController*choose=[[CWSCarMangerChooseOKController alloc]initWithNibName:@"CWSCarMangerChooseOKController" bundle:nil];
                        [self.navigationController pushViewController:choose animated:YES];
                    }else{
                        [[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    }
                });
            } faile:^(NSError *err) {
                [self hideHud];
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"保存失败，请重新选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }];
        }
            break;
        case 6://取消
        {
            [_backView removeFromSuperview];
            [self.notiview removeFromSuperview];
        }
            break;
        default:
            break;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [super viewWillAppear:animated];
    _moneyAndCalling = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_moneyAndCalling) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [ModelTool stopAllOperation];
}
@end
