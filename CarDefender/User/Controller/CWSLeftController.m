//
//  CWSLeftController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/2.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSLeftController.h"
#import "CWSCarManageController.h"
#import "CWSUserInformationController.h"
#import "CWSMyWealthController.h"
#import "UIImageView+WebCache.h"
#import "CWSPhoneController.h"
#import "CWSFeedbackController.h"
#import "CWSMessageViewController.h"
#import "CWSSettingController.h"
#import "CWSMoodController.h"
#import "CWSUserPersonalSignatureController.h"

#import "AppDelegate.h"
#import "LHPSideViewController.h"
#import "CWSMyMonyController.h"

#import "HeadMessageTableViewCell.h"
#import "AccountTableViewCell.h"
#import "CWSMyWalletViewController.h"
#import "CWSMyOrderViewController.h"
#import "CWSBoundIDViewController.h"

@interface CWSLeftController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSArray *           _headImageArray;//图标数组
    NSArray *           _titleArray;//标题数组
    NSArray *           _messageArray;//信息数组
    BOOL                _unreadMsgOnce;
    NSString*           _mark;
}
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation CWSLeftController



#pragma mark - 试图将要消失
-(void)leftViewWillDisappear
{
    //    MyLog(@"左侧试图将要消失");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"leftVCHidden" object:nil];
    [ModelTool stopAllOperation];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"leftAppearVC" object:nil];
//    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
//    
//    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:[user objectForKey:@"user"]];
//    MyLog(@"userDic==========%@",userDic);
    
    [self updateDefaultMessage];
    [self initalizeUserInterface];
    [self initDataSource];
    
    [_tableView reloadData];
    
}

- (void)updateDefaultMessage
{
    NSUserDefaults* thyUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [thyUserDefaults objectForKey:@"user"];
    KUserManager.nick_name = [dic valueForKey:@"nick_name"];
    KUserManager.signature = [dic valueForKey:@"signature"];
    KUserManager.icon = [dic valueForKey:@"icon"];
    KUserManager.userDefaultVehicle = [thyUserDefaults valueForKey:@"userDefaultVehicle"];
    NSDictionary *dic2 = [NSDictionary dictionaryWithDictionary:[thyUserDefaults valueForKey:@"userDefaultVehicle"]];
    KUserManager.userCID = dic2[@"id"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的账号";
    [Utils changeBackBarButtonStyle:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leftMark:) name:@"leftMark" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationStateActive:) name:kAppToActionNotification object:nil];
    _unreadMsgOnce = YES;
    
#if USENEWVERSION
    
#warning 修改查询用户数据的链接
    
//    [HttpTool postcheckAllUserMessageWithParameter:@{@"uid":KUserManager.uid} success:^(NSDictionary *data) {
//
//        NSLog(@"%@",data);
//        UserNew* lUser = [[UserNew alloc] initWithDic:data];
//        KUserManager = lUser;
//        
//        [self initalizeUserInterface];
//        [self initDataSource];
//        
//    } faile:^(NSError *err) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:err.localizedDescription delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }];
    
#else
    [self initalizeUserInterface];
    [self initDataSource];
    
#endif
}




-(void)leftMark:(NSNotification*)sender
{
    _mark = sender.object;
}

-(void)applicationStateActive:(NSNotification*)sender
{
}
#pragma mark - 初始化界面
- (void)initalizeUserInterface
{
    self.tableView = (UITableView *)[self.view viewWithTag:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - 初始化数据源
- (void)initDataSource
{
    _headImageArray = @[@"mycar",@"wallet",@"My-order",@"alertservice",@"feedback",@"set"];//,@"message"
    _titleArray = @[@"我的车辆",@"我的钱包",@"我的订单",@"联系客服",@"意见反馈",@"设置"];//@"消息中心",
    _messageArray = @[@"",@"余额、红包、积分、话费",@"",@"400-793-0888",@"",@""];//,@""
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _headImageArray.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 90;
    }
    else {
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //头像栏
    if (indexPath.row == 0) {
        
        UINib *nib = [UINib nibWithNibName:@"HeadMessageTableViewCell" bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:@"headMessageTableViewCell"];
        HeadMessageTableViewCell *cell = [[HeadMessageTableViewCell alloc] init];
        cell = [tableView dequeueReusableCellWithIdentifier:@"headMessageTableViewCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        
        UserInfo *userInfo = [UserInfo userDefault];
        MyLog(@"niceName:%@---signature:%@---photo:%@",userInfo.nickName,userInfo.signature,userInfo.photo);
        //头像
        if ([Helper isStringEmpty:userInfo.photo]) {
            cell.headImage.image=[UIImage imageNamed:@"infor_moren.png"];
        } else {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/csh-interface%@",SERVERADDRESS,userInfo.photo]];
            NSLog(@"image url :%@",url);
            [cell.headImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"infor_moren.png"] options:SDWebImageLowPriority | SDWebImageRetryFailed | SDWebImageProgressiveDownload | SDWebImageRefreshCached];
        }
        //昵称
        if ([Helper isStringEmpty:userInfo.nickName]) {
            cell.nameLabel.text = userInfo.userName;
        }else{
            cell.nameLabel.text = userInfo.nickName;
        }
        //心情
        if ([Helper isStringEmpty:userInfo.signature]) {
            cell.montionLabel.text = @"说点什么吧";  
        }else{
            cell.montionLabel.text = userInfo.signature;
        }
        //座驾
        if ([Helper isStringEmpty:userInfo.defaultVehicle]) {
            cell.carLabel.text = @"认证座驾： ";
        }else{
            cell.carLabel.text = [NSString stringWithFormat:@"认证座驾:%@",userInfo.defaultVehicle];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    //信息栏
    else {
        UINib *nib = [UINib nibWithNibName:@"AccountTableViewCell" bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:@"accountTableViewCell"];
        AccountTableViewCell *cell = [[AccountTableViewCell alloc] init];
        cell = [tableView dequeueReusableCellWithIdentifier:@"accountTableViewCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.headImage.image = [UIImage imageNamed:_headImageArray[indexPath.row-1]];
        cell.titleLabel.text = _titleArray[indexPath.row-1];
        cell.messageLabel.text = _messageArray[indexPath.row-1];
        [cell loadData:nil];
        return cell;
    }
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
            //个人资料
        case 0:{
            [self checkLogin:YES AndTurnOwnVC:@"CWSUserInformationController"];
        }
            break;
            //我的车辆
        case 1:{
            [self checkLogin:YES AndTurnOwnVC:@"CWSCarManageController"];
        }
            break;
            //我的钱包
        case 2:{
            [self checkLogin:YES AndTurnOwnVC:@"CWSMyWalletViewController"];
        }
            break;
            //我的订单
        case 3:{
            [self checkLogin:YES AndTurnOwnVC:@"CWSOrderHistoryController"];
        }
            break;
            //网络电话
//        case 5:{
//            [self checkLogin:YES AndTurnOwnVC:@"CWSPhoneController"];
//        }
//            break;
            //联系客服
        case 4:{
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:@"4007930888" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];

            [alert show];
        }
            break;
            //意见反馈
        case 5:{
            [self checkLogin:NO AndTurnOwnVC:@"CWSFeedbackController"];
        }
            break;
            //设置
        case 6:{
            [self checkLogin:NO AndTurnOwnVC:@"CWSSettingController"];
            
        }
            break;
        default:
            break;
    }
}

-(void)checkLogin:(BOOL)loginBool AndTurnOwnVC:(NSString*)vcString
{
    if (loginBool) {
        if (![UserInfo userDefault].desc) {//未登录
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goToLoginVC" object:nil];
            
            return;
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LEFT_TURN_MAINVC" object:vcString];
}

#pragma mark - <UIAlertViewDelegate>
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){//拨打
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"4007930888"]]];
        ;
    }
}

@end