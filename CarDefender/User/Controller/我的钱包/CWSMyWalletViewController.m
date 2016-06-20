//
//  CWSMyWalletViewController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/16.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSMyWalletViewController.h"
#import "MyWalletTableViewCell.h"
#import "CWSRemainMoneyViewController.h"
#import "CWSRedEnvelopeViewController.h"
#import "CWSRecordViewController.h"
#import "CWSPhoneMoneyViewController.h"
#import "CWSInternetPhoneViewController.h"
#import "HttpHelper.h"
#import "SFCouponViewController.h"

@interface CWSMyWalletViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_titleArray;
    NSArray *_messageArray;
    NSArray *_headImageArray;
    NSDictionary *_dataDic;
    UserInfo *userInfo;
}
@end

@implementation CWSMyWalletViewController

- (void)viewWillAppear:(BOOL)animated
{
    userInfo = [UserInfo userDefault];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的钱包";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    
    [self initDataSource];
    
}


#pragma mark - 数据源
- (void)initDataSource
{
//    _titleArray = @[@"余额",@"红包",@"积分",@"网络电话"];
//    _messageArray = @[@"元",@"元",@"分",@""];
//    _headImageArray = @[@"qianbao_yue",@"qianbao_hogbao",@"qianbao_jifen",@"qianbao_dianhua"];
    
    _titleArray = @[@"余额",@"优惠劵",@"积分",@"网络电话"];
    _messageArray = @[@"元",@"",@"分",@""];
    _headImageArray = @[@"qianbao_yue",@"qianbao_hogbao",@"qianbao_jifen",@"qianbao_dianhua"];
    
}

- (void)getData
{
    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setValue:KUserManager.uid forKey:@"uid"];
//    [dic setValue:KUserManager.mobile forKey:@"mobile"];
//    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//    [ModelTool getWalletInfoWithParameter:dic andSuccess:^(id object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            if ([object[@"state"] integerValue] == 200000) {
//                _dataDic = [NSMutableDictionary dictionaryWithDictionary:object[@"data"]];
////                self.tableView = (UITableView *)[self.view viewWithTag:1];
//                self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-20) style:UITableViewStylePlain];
//                self.tableView.delegate = self;
//                self.tableView.dataSource = self;
//                self.tableView.tableFooterView = [[UIView alloc] init];
//                [self.view addSubview:self.tableView];
//            }else{
//                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[PublicUtils showServiceReturnMessage:object[@"message"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//        });
//    } andFail:^(NSError *err) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }];
    
    [HttpHelper viewMyWalletWithUserId:userInfo.desc
                                 token:userInfo.token
                               success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                   NSLog(@"my wallet response :%@", responseObjcet);
                                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                   NSDictionary *resultDic = (NSDictionary *)responseObjcet;
                                   _dataDic = (NSDictionary *)resultDic[@"msg"];
                                   if ([resultDic[@"code"] isEqualToString:SERVICE_SUCCESS]) {
                                       userInfo.token = resultDic[@"token"];
                                       self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-20) style:UITableViewStylePlain];
                                       self.tableView.delegate = self;
                                       self.tableView.dataSource = self;
                                       self.tableView.tableFooterView = [[UIView alloc] init];
                                       [self.view addSubview:self.tableView];
                                   }else if ([resultDic[@"code"] isEqualToString:SERVICE_TIME_OUT]) {
                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                   }else{
                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:resultDic[@"desc"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                       [alert show];
                                   }
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络请求错误,请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                   [alert show];
                               }];
    
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UINib *nib = [UINib nibWithNibName:@"MyWalletTableViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"myWalletTableViewCell"];
    MyWalletTableViewCell *cell = [[MyWalletTableViewCell alloc] init];
    cell = [tableView dequeueReusableCellWithIdentifier:@"myWalletTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.headImageView.image = [UIImage imageNamed:_headImageArray[indexPath.row]];
    cell.titleLabel.text = _titleArray[indexPath.row];
    switch (indexPath.row) {
            //余额
        case 0:{
            cell.headImageViewHeight.constant = 15;
//            cell.moneyLabel.text = KUserManager.account.cash;
            
                if([PublicUtils checkNSNullWithgetString:_dataDic[@"balanceAmount"]] != nil){
                    cell.moneyLabel.text = [NSString stringWithFormat:@"%.1f",[[PublicUtils checkNSNullWithgetString:_dataDic[@"balanceAmount"]] floatValue]];
                }else{
                    cell.moneyLabel.text = @"0";
                }
            
        }
            break;
            //红包
        case 1:{
            cell.moneyLabel.text = @"";
            
//                if([PublicUtils checkNSNullWithgetString:_dataDic[@"giftAmount"]] != nil){
//                    cell.moneyLabel.text = [NSString stringWithFormat:@"%.1f",[[PublicUtils checkNSNullWithgetString:_dataDic[@"giftAmount"]] floatValue]];
//                }else{
//                    cell.moneyLabel.text = @"0";
//                }
            
            
        }
            break;
            //积分
        case 2:{
//            cell.moneyLabel.text = KUserManager.score.now;
            if([PublicUtils checkNSNullWithgetString:_dataDic[@"score"]] != nil){
                cell.moneyLabel.text = [NSString stringWithFormat:@"%.1f",[[PublicUtils
                    checkNSNullWithgetString:_dataDic[@"score"]] floatValue]];
            }else{
                cell.moneyLabel.text = @"0";
            }
            
        }
            break;
            //网络话费
//        case 3:{
////            cell.moneyLabel.text = KUserManager.account.cash;
//            if (_dataDic[@"money"]) {
//                cell.moneyLabel.text = [NSString stringWithFormat:@"%@",_dataDic[@"money"]];
//            }
//            
//        }
//            break;
            //网络电话
        case 3:{
            
            cell.moneyLabel.hidden = YES;
        }
            break;
        default:
            break;
    }
    cell.messageLabel.text = _messageArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
            //余额
        case 0:{
            CWSRemainMoneyViewController *vc = [[CWSRemainMoneyViewController alloc] init];

//            vc.moneyLabel.text = _dataDic[@"money"];
//            [vc setMoneyString:_dataDic[@"money"]];
            if([PublicUtils checkNSNullWithgetString:_dataDic[@"balanceAmount"]] != nil){
                 vc.moneyString = [NSString stringWithFormat:@"%.1f",[[PublicUtils checkNSNullWithgetString:_dataDic[@"balanceAmount"]] floatValue]];
                
            }else{
                 vc.moneyString = @"0";
            }
            vc.walletId = _dataDic[@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            //红包
        case 1:{
//            CWSRedEnvelopeViewController *vc = [[CWSRedEnvelopeViewController alloc] init];
//            if([PublicUtils checkNSNullWithgetString:_dataDic[@"giftAmount"]] != nil){
//                vc.moneyString = [NSString stringWithFormat:@"%.1f",[[PublicUtils checkNSNullWithgetString:_dataDic[@"giftAmount"]] floatValue]];
//            }else{
//                vc.moneyString  = @"0";
//            }
//            
//            [self.navigationController pushViewController:vc animated:YES];
            SFCouponViewController *couponVC = [[SFCouponViewController alloc] init];
            [self.navigationController pushViewController:couponVC animated:YES];
        }
            break;
            //积分
        case 2:{
            
            CWSRecordViewController *vc = [[CWSRecordViewController alloc] init];
            vc.recordLabel.text = _dataDic[@"score"];
            vc.walletId = _dataDic[@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            //网络电话
        case 3:{
            
//            CWSPhoneMoneyViewController *vc = [[CWSPhoneMoneyViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            
//            CWSInternetPhoneViewController *vc = [[CWSInternetPhoneViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"敬请期待" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -设置tableView分割线
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end

