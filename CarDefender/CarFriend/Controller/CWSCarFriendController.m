//
//  CWSCarFriendController.m
//  CarDefender
//
//  Created by 周子涵 on 15/3/28.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSCarFriendController.h"
#import "CWChatListController.h"
#import "CWSContactsController.h"
#import "CarFriendDockView.h"

#import "UIViewController+HUD.h"
#import "ApplyViewController.h"
#import "AddFriendViewController.h"
#import "CallSessionViewController.h"

#import "CWSLoginController.h"

#import "CarFriendCell.h"
#import "CWSCarFriendSecondController.h"
//两次提示的默认间隔
//static const CGFloat kDefaultPlaySoundInterval = 3.0;
#define kTopViewWeight 150
#define kTopViewHeight 30
@interface CWSCarFriendController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*_tableView;
    NSMutableDictionary*_msgDic;
    NSMutableArray*_carFriendArray;
}

@end

@implementation CWSCarFriendController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"车资讯";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _carFriendArray=[NSMutableArray array];
    [Utils changeBackBarButtonStyle:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(controllerBack:) name:@"leftControllerBack2" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(homeClick:) name:@"homeClick2" object:nil];

    _msgDic=[NSMutableDictionary dictionary];
}



-(void)buildTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, self.view.frame.size.height)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.backgroundColor=kCOLOR(242, 242, 242);
    [_tableView registerNib:[UINib nibWithNibName:@"CarFriendCell" bundle:nil] forCellReuseIdentifier:@"newFriend"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _carFriendArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*newID=@"newFriend";
    CarFriendCell*cell=[tableView dequeueReusableCellWithIdentifier:newID];
    if (cell==nil) {
        cell=[[CarFriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newID];
//        cell.accessoryType =UITableViewCellAccessoryNone;
    }
    NSDictionary*dic=_carFriendArray[indexPath.row];
    cell.dicMsg=dic;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [_msgDic setObject:@"0" forKey:@"firstOrNo"];
//    [LHPShaheObject saveAccountMsgWithName:@"carFriendMsg" andWithMsg:_msgDic];
    CWSCarFriendSecondController*detailVC=[[CWSCarFriendSecondController alloc]initWithNibName:@"CWSCarFriendSecondController" bundle:nil];
    detailVC.listDic=_carFriendArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)controllerBack:(NSNotification*)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"recoverNormal" object:nil];
    UIViewController* lController = sender.object;
    [self.navigationController pushViewController:lController animated:YES];
}
-(void)homeClick:(NSNotification*)sender{
    _homeBackgroundControl.hidden = !_homeBackgroundControl.hidden;
}
-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"slide" object:@"0"];
    KManager.currentController = @"CWSCarFriendController";
    [ModelTool httpAppGainCircleWithSuccess:^(id object) {
        MyLog(@"%@",object);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                _carFriendArray=[NSMutableArray arrayWithArray:object[@"data"][@"list"]];
                if (_tableView==nil) {
                    [self buildTableView];
                }else{
                    [_tableView reloadData];
                }
            }else{
                
            }
        });
    } faile:^(NSError *err) {
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [ModelTool stopAllOperation];
}
@end
