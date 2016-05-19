//
//  CWSAccountSafeController.m
//  CarDefender
//
//  Created by 李散 on 15/10/13.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSAccountSafeController.h"
#import "CWSAccountProTableViewCell.h"
#import "CWSBuySafeView.h"
#import "CWSInsuranceView.h"
#import "ModelTool.h"
#import "CWSAccountSafePolicyController.h"

#import "CWSMyWealthDetailsController.h"
#import "CWSMyMonyController.h"
@interface CWSAccountSafeController () <UITableViewDataSource,UITableViewDelegate,CWSBuySafeViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *arrayMsg;

@property (nonatomic, strong) UIImageView*imgView;

@property (nonatomic, strong) NSDictionary*dicMsg;

@property (nonatomic, strong) CWSBuySafeView*downView;

@property (nonatomic, strong) CWSInsuranceView*safeView;
@end

@implementation CWSAccountSafeController
- (void)viewWillDisappear:(BOOL)animated
{
    [ModelTool stopAllOperation];
}

-(UIImageView*)buildTopView
{
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 105)];
    img.image = [UIImage imageNamed:@"protect_top_img"];
    
    UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(-10, 43, 130, 25)];
    label.text = @"由平安商业保险提供";
    [img addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    [Utils setViewRiders:label riders:12];
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = kCOLOR(253, 249, 231);
    label.textColor = KBlackMainColor;
    
    return img;
}
//获取参保数据
-(void)getDataWithAccountMsg
{
    NSDictionary*dicMsg1 = [NSDictionary dictionaryWithDictionary:self.insurDicMsg];
    MyLog(@"%@",dicMsg1);
    if (self.protectType) {
        self.title = @"保单详情";
        _arrayMsg = @[@"保障开始时间",@"保障结束时间",@"保障金额",@"赔付次数",@"支付金额"];
        _dicMsg = @{@"保障开始时间":dicMsg1[@"start"],@"保障结束时间":dicMsg1[@"end"],@"保障金额":dicMsg1[@"desc"],@"赔付次数":[NSString stringWithFormat:@"%@",dicMsg1[@"num"]],@"支付金额":dicMsg1[@"total"]};
    }else{
        self.title = @"账户安全险";

        _arrayMsg = @[@"保障金额",@"赔付次数",@"保障期限",@"支付金额"];
        _dicMsg = @{@"保障金额":dicMsg1[@"desc"],@"赔付次数":dicMsg1[@"num"],@"保障期限":dicMsg1[@"time"],@"支付金额":dicMsg1[@"total"]};
    }
    [self buildTabelView];
    [self hideHud];
}
-(void)buildTabelView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-44)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        [self getDataWithAccountMsg];
        if (self.protectType) {
            _safeView = [[CWSInsuranceView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 133)];
            _tableView.tableHeaderView = _safeView;
            [self performSelector:@selector(setSafeViewMsg) withObject:nil afterDelay:0.1f];
//            _safeView.stringNub = self.insurDicMsg[@"policy_no"];
        }else{
//            _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 102)];
//            _imgView.image = [UIImage imageNamed:@"protect_top_img"];
            _tableView.tableHeaderView = [self buildTopView];
        }
        
        _downView = [[CWSBuySafeView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 104)];
        _downView.delegate = self;
        _downView.protBool = self.protectType;
        _tableView.tableFooterView = self.downView;
    }
    [self.view addSubview:_tableView];
}
-(void)setSafeViewMsg
{
    _safeView.stringNub = self.insurDicMsg[@"policy_no"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    _arrayMsg = [NSArray array];
    _dicMsg = [NSDictionary dictionary];
    [self getDataWithAccountMsg];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayMsg.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellID = @"protect";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _arrayMsg[indexPath.row];
    cell.textLabel.textColor = kCOLOR(73, 73, 73);
    cell.detailTextLabel.textColor = kCOLOR(73, 73, 73);
    NSString*textString = _dicMsg[_arrayMsg[indexPath.row]];
    MyLog(@"%@",textString);
    if (self.protectType) {
        cell.detailTextLabel.text = textString;
        cell.detailTextLabel.backgroundColor = [UIColor lightGrayColor];
        cell.textLabel.textColor = kCOLOR(137, 137, 137);
    }else{
        if (indexPath.row == _arrayMsg.count-1) {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:textString];
            [str addAttribute:NSForegroundColorAttributeName value:kCOLOR(60, 152, 247) range:[textString rangeOfString:@"8.00"]];
            cell.detailTextLabel.attributedText = str;
        }else{
            cell.detailTextLabel.text = textString;
        }
    }
    return cell;
}
-(void)buySafeViewWithBtnClick:(NSInteger)tagMsg
{
    if (tagMsg == 1) {//协议
        CWSAccountSafePolicyController*aspVC = [[CWSAccountSafePolicyController alloc]initWithNibName:@"CWSAccountSafePolicyController" bundle:nil];
        [self.navigationController pushViewController:aspVC animated:YES];
    }else{//支付
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否购买账户安全险？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认购买", nil];
        alert.tag = 10;
        alert.delegate = self;
        [alert show];
        
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10) {
        if (buttonIndex == 0) {
        }else{
            [self showHudInView:self.view hint:@"购买中..."];
            [ModelTool httpAppGainBuyPolicyWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key} success:^(id object) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    MyLog(@"%@",object);
                    [self hideHud];
                    if ([object[@"operationState"] isEqualToString:@"FAIL"]) {
//                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                        [alert show];
                        [self showHint:object[@"data"][@"msg"]];
                    }else{//购买成功
                        KUserManager.account.insurance = @"1";
                        CWSMyWealthDetailsController* lController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
                        lController.buyBack = @"back";
                        CWSMyMonyController* moneyVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
                        moneyVC.backString = @"back";
                        KUserManager.account.cash = [NSString stringWithFormat:@"%.2f",[KUserManager.account.cash floatValue]-8];
                        [self.navigationController popToViewController:lController animated:YES];
                    }
                });
            } faile:^(NSError *err) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideHud];
                });
            }];
        }
    }
}
@end
