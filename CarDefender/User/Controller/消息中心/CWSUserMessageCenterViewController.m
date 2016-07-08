//
//  CWSUserMessageCenterViewController.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/9.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSUserMessageCenterViewController.h"
#import "CWSCheckMessageCenterDetailViewController.h"

#import "CWSUserMessageCenterModel.h"
#import "CWSUserMessageInfoCell.h"
#import "CWSNoDataView.h"
#import "CWSMessageDetailViewController.h"

@interface CWSUserMessageCenterViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView* myTableView;
    NSMutableArray* dataArray;
    int _page;
    CWSNoDataView* _noCarView;
    UserInfo *userInfo;
}

@end

@implementation CWSUserMessageCenterViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    userInfo = [UserInfo userDefault];
    dataArray = [NSMutableArray arrayWithCapacity:5];
    [self getMessageList:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"message_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllMessage)];
    _page = 1;
}

#pragma mark 删除所有信息
- (void)deleteAllMessage {
    if ([dataArray isKindOfClass:[NSNull class]] || dataArray.count == 0) {
        [MBProgressHUD showError:@"当前没有可以删除的消息" toView:self.view];
        return;
    }
    NSMutableArray *deleteMessages = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in dataArray) {
        [deleteMessages addObject:[NSString stringWithFormat:@"%@",dict[@"id"]]];
    }
    NSLog(@"delete messages :%@",deleteMessages);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要将所有信息清空吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showMessag:@"正在删除..." toView:self.view];
        
        [HttpHelper deleteMessageWithUserId:userInfo.desc
                                      token:userInfo.token
                                     msgIds:deleteMessages
                                    success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                        NSLog(@"delte message responseObject :%@",responseObjcet);
                                        NSDictionary *dict = (NSDictionary *)responseObjcet;
                                        NSString *code = dict[@"code"];
                                        if ([code isEqualToString:SERVICE_SUCCESS]) {
                                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                            [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
                                            [dataArray removeAllObjects];
                                            [myTableView reloadData];
                                            [myTableView removeFromSuperview];
                                            [self createNoDataView];
                                            if (self.delegate) {
                                                [self.delegate badgeDidEmpty];
                                            }
                                        } else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                        } else {
                                            [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                        }
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"delete message error :%@",error);
                                         [MBProgressHUD showError:@"请求错误，请重试" toView:self.view];
                                     }];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}
- (void)getMessageList:(int)page {
    if (page >= 10) {
        _page = 1;
        page = 1;
    }
    NSString *pageNumber = [NSString stringWithFormat:@"%d",page];
    [HttpHelper getMessageListWithUserId:userInfo.desc
                                   token:userInfo.token
                              pageNumber:pageNumber
                                pageSize:@"10"
                                 success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                     NSLog(@"message :%@",responseObjcet);
                                     NSDictionary *dict = (NSDictionary *)responseObjcet;
                                     NSString *code = dict[@"code"];
                                     userInfo.token = dict[@"token"];
                                     if ([code isEqualToString:SERVICE_SUCCESS]) {
                                         NSArray *messages = dict[@"msg"];
                                         NSInteger total = [dict[@"page"][@"total"] integerValue];
                                         if (dataArray.count < total) {
                                             [dataArray addObjectsFromArray:messages];
                                         }
                                         dataArray = [dataArray mutableCopy];
                                         if (messages.count == 0) {
                                             [MBProgressHUD showError:@"没有更多数据了哦" toView:self.view.window];
                                         }
                                         if (dataArray.count == 0) {
                                             [self createNoDataView];
                                         } else {
                                             [self createTableView];
                                         }
                                     } else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                     } else {
                                         [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     [MBProgressHUD showError:@"请求失败，请重试" toView:self.view];
                                 }];
}
#pragma mark 下拉刷新
- (void)headerRefreshing {
    [self getMessageList:1];
    [myTableView.mj_header endRefreshing];
}
#pragma mark 上拉加载更多
- (void)footerRefreshing {
    _page++;
    [self getMessageList:_page];
    [myTableView.mj_footer endRefreshing];
}
#pragma mark -CreateUI

-(void)createNoDataView{
    _noCarView = [[CWSNoDataView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-kSTATUS_BAR)];
    _noCarView.noDataImageView.frame = CGRectMake((kSizeOfScreen.width-75)/2, 100, 75, 55);
    _noCarView.noDataImageView.image = [UIImage imageNamed:@"message_message"];
    
    _noCarView.noDataTitleLabel.text = @"您还没有相关消息";
    _noCarView.noDataTitleLabel.frame = CGRectMake((kSizeOfScreen.width-150)/2, CGRectGetMaxY(_noCarView.noDataImageView.frame)+30, 150, 20);
    _noCarView.noDataTitleLabel.textColor = [UIColor colorWithRed:0.733f green:0.733f blue:0.733f alpha:1.00f];
    _noCarView.backgroundColor = [UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1.00f];
    [self.view addSubview:_noCarView];
}

-(void)createTableView{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-kDockHeight) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.bounces = YES;
    myTableView.showsHorizontalScrollIndicator = NO;

    myTableView.tableFooterView = [[UIView alloc] init];

    [myTableView registerNib:[UINib nibWithNibName:@"CWSUserMessageInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MessageInfoCell"];
    myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    [self.view addSubview:myTableView];
}

#pragma mark -TableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CWSUserMessageInfoCell* cell = [[CWSUserMessageInfoCell alloc] init];
    cell = [tableView dequeueReusableCellWithIdentifier:@"MessageInfoCell"];
    CWSUserMessageCenterModel *model =  [[CWSUserMessageCenterModel alloc] initWithDict:dataArray[indexPath.row]];
    [cell setUserMessageModel:model];
    if(myTableView.editing){
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)readMessage:(NSDictionary *)detailDic withCell:(CWSUserMessageInfoCell *)cell{
    BOOL isRead = [[NSString stringWithFormat:@"%@",detailDic[@"isRead"]] isEqualToString:@"0"] ? NO : YES;
    if (!isRead) {
        NSString *itemId = [NSString stringWithFormat:@"%@",detailDic[@"id"]];
        [HttpHelper changeMessageStateWithUserId:userInfo.desc
                                           token:userInfo.token
                                           msgId:itemId
                                         success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                             NSLog(@"change message status :%@",responseObjcet);
                                             NSDictionary *dict = (NSDictionary *)responseObjcet;
                                             userInfo.token = dict[@"token"];
                                             NSString *code = dict[@"code"];
                                             if ([code isEqualToString:SERVICE_SUCCESS]) {
                                                 [cell.readFlagView removeFromSuperview];
                                                 if (self.delegate) {
                                                     [self.delegate badgeValueChanged];
                                                 }
                                             } else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                             } else {
                                             }
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         }];
    }
}
#pragma mark -================================TableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self readMessage:dataArray[indexPath.row] withCell:[tableView cellForRowAtIndexPath:indexPath]];
    
    CWSMessageDetailViewController *messageDetailVC = [[CWSMessageDetailViewController alloc] init];
    messageDetailVC.detailDic = dataArray[indexPath.row];
    [self.navigationController pushViewController:messageDetailVC animated:YES];
}
- (void)deleteMessage:(NSIndexPath *)indexPath {
    [MBProgressHUD showMessag:@"正在删除..." toView:self.view];
    NSString *deleteId =[NSString stringWithFormat:@"%@",[dataArray[indexPath.row] objectForKey:@"id"]];
    [HttpHelper deleteMessageWithUserId:userInfo.desc
                                  token:userInfo.token
                                 msgIds:@[deleteId]
                                success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                    NSLog(@"delte message responseObject :%@",responseObjcet);
                                    NSDictionary *dict = (NSDictionary *)responseObjcet;
                                    NSString *code = dict[@"code"];
                                    if ([code isEqualToString:SERVICE_SUCCESS]) {
                                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                        [MBProgressHUD showSuccess:@"删除成功" toView:self.view];
                                        [dataArray removeObject:dataArray[indexPath.row]];
                                        [myTableView reloadData];
                                    } else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                    } else {
                                        [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                    }
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    NSLog(@"delete message error :%@",error);
                                    [MBProgressHUD showError:@"请求错误，请重试" toView:self.view];
                                }];
}
/**列表滑动删除时的回调方法*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self deleteMessage:indexPath];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
#pragma mark -设置tableView分割线
-(void)viewDidLayoutSubviews
{
    if ([myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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
