//
//  CWSMessageViewController.m
//  CarDefender
//
//  Created by 李散 on 15/6/2.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSMessageViewController.h"
#import "CWSMessageCell.h"
#import "CWSMessageCancelBtn.h"
#import "CWSMessageDetailViewController.h"
#import "CWSNoDataView.h"
@interface CWSMessageViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView*_tableView;
    NSMutableArray*_dataArray;
    NSMutableDictionary*_deleteDic;
    
    NSMutableArray*_unreadArray;
    
    CWSMessageCancelBtn*_leftBtn;
    UIView*_downView;
    
    CWSMessageCancelBtn*_readAllMsgBtn;
    UIButton*_clearAllMsgBtn;
    
    int _tableAccount;
    
    NSMutableArray*_cancelUnreadArray;
    
    BOOL downRefreash;
    NSIndexPath *deleIndexPath;
    
    CWSNoDataView*_noDataView;
    int _page;
}
@end
#define kMessageMsg @"kMessageCenterMsg"
@implementation CWSMessageViewController
//记录当前正在执行的操作，0代表删除，1代表插入
NSUInteger action;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    downRefreash=NO;
    self.title=@"消息中心";
    _unreadArray=[NSMutableArray array];
    _cancelUnreadArray=[NSMutableArray array];
    _page = 1;
    [self getDataWithPage:_page];
    [self buildUI];
    _tableAccount=10;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [ModelTool stopAllOperation];
}

-(void)buildUI
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"CWSMessageCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}

#pragma mark - 上拉加载方法
-(void)footerRefreshing{
    MyLog(@"上拉加载");
    _page ++;
    [self getDataWithPage:_page];
}

#pragma mark - 下拉刷新方法
-(void)headerRefreshing
{
    MyLog(@"下拉刷新");
    if (!_tableView.editing) {
        downRefreash=YES;
//        [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self loadShareDataInPage];
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        });
        [_dataArray removeAllObjects];
        _page = 1;
        [self getDataWithPage:_page];
    }
}
#pragma mark - 更新数据源方法
-(void)loadShareDataInPage
{
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}
-(void)getDataWithPage:(NSInteger)page
{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    action=0;
    _dataArray=[NSMutableArray array];
    _deleteDic=[NSMutableDictionary dictionary];
    [ModelTool httpAppGainPushNewWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key} success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(dateLate) withObject:nil afterDelay:0.5];
            [self loadShareDataInPage];
            MyLog(@"%@",object);
            NSString*pathName=[NSString stringWithFormat:@"%@%@",kMessageMsg,KUserManager.uid];
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                NSArray*messageArray=object[@"data"][@"data"];
                    //有数据就更新未读数据
                if (downRefreash) {
                    downRefreash=NO;
                    if (messageArray.count) {
                        NSString*namePath=[NSString stringWithFormat:@"kMessageCenter%@",KUserManager.uid];
                        if ([LHPShaheObject checkPathIsOk:namePath]) {
                            int countNub=[[NSString stringWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:namePath] encoding:NSUTF8StringEncoding error:nil] intValue];
                            if (countNub<0) {
                                countNub=0;
                            }
                            countNub+=messageArray.count;
                            [LHPShaheObject saveUnreadMsgWithName:namePath andCount:countNub];
                        }
                    }
                }

                if ([LHPShaheObject checkPathIsOk:pathName]) {
                    NSMutableArray*arrayMsg=[NSMutableArray arrayWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:pathName]];
                    for (int i=(int)(messageArray.count-1); i<messageArray.count; i--) {
                        [arrayMsg insertObject:messageArray[i] atIndex:0];
                    }
                    [LHPShaheObject saveMsgWithName:pathName andWithMsg:arrayMsg];
                }else{
                    [LHPShaheObject saveMsgWithName:pathName andWithMsg:object[@"data"][@"data"]];
                }
                _dataArray=[NSMutableArray arrayWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:pathName]];
                [_tableView reloadData];
                [self buildNoMsgViewWithHttpBool:YES];
            }else{
                [[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
        });
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self loadShareDataInPage];
    }];
}

-(void)buildNoMsgViewWithHttpBool:(BOOL)httpBool
{
    if (!_dataArray.count) {
        if (httpBool) {
            self.navigationItem.rightBarButtonItem = nil;
            if (_noDataView == nil) {
                _noDataView = [[CWSNoDataView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height)];
            }
            [self.view addSubview:_noDataView];
            [self.view insertSubview:_noDataView atIndex:self.view.subviews.count - 2];
        }
    }else{
        int nubMsg = 0;
        for (NSDictionary*dic in _dataArray) {
            if (![dic[@"isRead"] intValue]) {
                nubMsg++;
            }
        }
        
        NSString*namePath=[NSString stringWithFormat:@"kMessageCenter%@",KUserManager.uid];
        [LHPShaheObject saveUnreadMsgWithName:namePath andCount:nubMsg];
        
        [_noDataView removeFromSuperview];
        if (!httpBool) {
            self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(messageEditing:)];
        }else{
            if (_dataArray.count) {
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(messageEditing:)];
            }
        }
    }
}
-(void)messageEditing:(UIBarButtonItem*)sender
{
    if (_leftBtn==nil) {
        _leftBtn=[[CWSMessageCancelBtn alloc]initWithFrame:CGRectMake(0, 20, 120, 44)];
        _leftBtn.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bj.png"]];
        [_leftBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:kCOLOR(197, 197, 197) forState:UIControlStateNormal];
        [self.navigationController.view addSubview:_leftBtn];
        [_leftBtn addTarget:self action:@selector(cancelChooseMsg:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_leftBtn removeFromSuperview];
        _leftBtn=nil;
    }
    
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
        action=1;
        [_tableView setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
        self.navigationItem.rightBarButtonItem.title=@"完成";
        [self buildDownView];
     //   [_tableView removeHeader];
        
        
        if (_dataArray.count<_tableAccount+1) {
            for (int i = 0; i<_dataArray.count; i++) {
                if ([_dataArray[i][@"isRead"] intValue]==0) {
                    [_unreadArray addObject:_dataArray[i]];
                }
            }
        }else{
            for (int i=0; i<_tableAccount; i++) {
                if ([_dataArray[i][@"isRead"] intValue]==0) {
                    [_unreadArray addObject:_dataArray[i]];
                }
            }
        }
        int nub=(int)_unreadArray.count;
        if (!nub) {
            [_readAllMsgBtn setTitle:@"全部阅读" forState:UIControlStateNormal];
        }else{
            [_readAllMsgBtn setTitle:[NSString stringWithFormat:@"全部阅读(%d)",nub] forState:UIControlStateNormal];
        }
        
    }else{
        action=0;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
        [_tableView setEditing:NO animated:YES];
        self.navigationItem.rightBarButtonItem.title=@"编辑";
        [_downView removeFromSuperview];
        CGRect tableFrame=_tableView.frame;
        tableFrame.size.height=[UIScreen mainScreen].bounds.size.height-64;
        _tableView.frame=tableFrame;
        
        [_unreadArray removeAllObjects];
    }
}
-(void)buildDownView
{
    if (_downView==nil) {
        _downView=[[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-64-kDockHeight,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
        _downView.backgroundColor=kCOLOR(245, 245, 245);
        
        _readAllMsgBtn = [[CWSMessageCancelBtn alloc]initWithFrame:CGRectMake(10 , 0, 120, kDockHeight)];
        [_readAllMsgBtn setTitleColor:kMainColor forState:UIControlStateNormal];
        [_readAllMsgBtn setTitle:@"全部阅读" forState:UIControlStateNormal];
        [_downView addSubview:_readAllMsgBtn];
        [_readAllMsgBtn addTarget:self action:@selector(readAllMsgEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        _clearAllMsgBtn = [[UIButton alloc]initWithFrame:CGRectMake(kSizeOfScreen.width-56, 0, 56, kDockHeight)];
        [_clearAllMsgBtn setTitleColor:kMainColor forState:UIControlStateNormal];
        [_clearAllMsgBtn setTitle:@"清空" forState:UIControlStateNormal];
        [_downView addSubview:_clearAllMsgBtn];
        [_clearAllMsgBtn addTarget:self action:@selector(clearAllMsgEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:_downView];
    
    CGRect tableFrame=_tableView.frame;
    tableFrame.size.height=[UIScreen mainScreen].bounds.size.height-64-kDockHeight;
    _tableView.frame=tableFrame;
}
-(void)readAllMsgEvent:(UIButton*)sender
{
    int nubUnread=0;
    if (_dataArray.count<_tableAccount) {
        for (int i = 0; i<_dataArray.count; i++) {
            if ([_dataArray[i][@"isRead"] intValue]==0) {
                [_unreadArray addObject:_dataArray[i]];
                [self setUnreadMsgRead:i];
                nubUnread++;
            }
        }
    }else{
        for (int i=0; i<_tableAccount; i++) {
            if ([_dataArray[i][@"isRead"] intValue]==0) {
                [_unreadArray addObject:_dataArray[i]];
                [self setUnreadMsgRead:i];
                nubUnread++;
            }
        }
    }
    NSString*namePath=[NSString stringWithFormat:@"kMessageCenter%@",KUserManager.uid];
    int countNub=[[NSString stringWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:namePath] encoding:NSUTF8StringEncoding error:nil] intValue];
    countNub=countNub-nubUnread;
    if (countNub<0) {
        countNub=0;
    }
    [LHPShaheObject saveUnreadMsgWithName:namePath andCount:countNub];
    
    [_tableView reloadData];
    [self clearUnreadMsg];
    [_readAllMsgBtn setTitle:@"全部阅读" forState:UIControlStateNormal];
}
-(void)setUnreadMsgRead:(int)i
{
    NSMutableDictionary*dicMsg=[NSMutableDictionary dictionaryWithDictionary:_dataArray[i]];
    [dicMsg setObject:@"1" forKey:@"isRead"];
    [_dataArray replaceObjectAtIndex:i withObject:dicMsg];
    [LHPShaheObject saveMsgWithName:[NSString stringWithFormat:@"%@%@",kMessageMsg,KUserManager.uid] andWithMsg:_dataArray];
}
-(void)clearUnreadMsg
{
    NSString*namePath=[NSString stringWithFormat:@"kMessageCenter%@",KUserManager.uid];
    if ([LHPShaheObject checkPathIsOk:namePath]) {
        int countNub=[[NSString stringWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:namePath] encoding:NSUTF8StringEncoding error:nil] intValue];
        countNub=countNub-(int)_unreadArray.count;
        if (countNub<0) {
            countNub=0;
        }
        [LHPShaheObject saveUnreadMsgWithName:namePath andCount:countNub];
        [_unreadArray removeAllObjects];
    }
}
-(void)clearAllMsgEvent:(UIButton*)sender
{
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定清空数据" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清空", nil];
    alert.tag=11;
    [alert show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11) {
        if (buttonIndex==1) {
            action=0;
            [self clearUnreadMsg];
            
            [_deleteDic removeAllObjects];
            [_downView removeFromSuperview];
            [_leftBtn removeFromSuperview];
            _leftBtn=nil;
            [_tableView setEditing:NO animated:YES];
            self.navigationItem.rightBarButtonItem.title=@"编辑";
            CGRect tableFrame=_tableView.frame;
            tableFrame.size.height=[UIScreen mainScreen].bounds.size.height-64;
            _tableView.frame=tableFrame;
            
            [_dataArray removeAllObjects];
            
            [LHPShaheObject saveMsgWithName:[NSString stringWithFormat:@"%@%@",kMessageMsg,KUserManager.uid] andWithMsg:_dataArray];
            [_readAllMsgBtn setTitle:@"全部阅读" forState:UIControlStateNormal];
            
//            if(_dataArray.count){
                [_tableView reloadData];
            [self buildNoMsgViewWithHttpBool:NO];
//            }
        }
    }else if (alertView.tag==12){
        if (buttonIndex==1) {
            if ([_dataArray[deleIndexPath.row][@"isRead"] intValue]==0) {
                NSString*namePath=[NSString stringWithFormat:@"kMessageCenter%@",KUserManager.uid];
                if ([LHPShaheObject checkPathIsOk:namePath]) {
                    int countNub=[[NSString stringWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:namePath] encoding:NSUTF8StringEncoding error:nil] intValue];
                    countNub-=1;
                    if (countNub<0) {
                        countNub=0;
                    }
                    [LHPShaheObject saveUnreadMsgWithName:namePath andCount:countNub];
                }
            }
            
            [_dataArray removeObjectAtIndex:deleIndexPath.row];
            [_tableView deleteRowsAtIndexPaths:@[deleIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [LHPShaheObject saveMsgWithName:[NSString stringWithFormat:@"%@%@",kMessageMsg,KUserManager.uid] andWithMsg:_dataArray];
            _tableAccount=_tableAccount-1;
            [_tableView reloadData];
//            [self buildNoMsgViewWithHttpBool:NO];
//            if (!_dataArray.count) {
//                if (httpBool) {
//                    self.navigationItem.rightBarButtonItem = nil;
//                    if (_noDataView == nil) {
//                        _noDataView = [[CWSNoDataView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height)];
//                    }
//                    [self.view addSubview:_noDataView];
//                    [self.view insertSubview:_noDataView atIndex:self.view.subviews.count - 2];
//                }
//            }else{
                int nubMsg = 0;
                for (NSDictionary*dic in _dataArray) {
                    if (![dic[@"isRead"] intValue]) {
                        nubMsg++;
                    }
                }
                
                NSString*namePath=[NSString stringWithFormat:@"kMessageCenter%@",KUserManager.uid];
                [LHPShaheObject saveUnreadMsgWithName:namePath andCount:nubMsg];
                if (_dataArray.count) {
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(messageEditing:)];
                }
//                [_noDataView removeFromSuperview];
        }
    }
}
-(void)cancelChooseMsg:(UIButton*)sender
{
    if (_deleteDic.count) {
        [_dataArray removeObjectsInArray:[_deleteDic allValues]];
        for (int i = 0; i<[[_deleteDic allKeys] count]; i++) {
            [_dataArray removeObject:[NSIndexPath indexPathForRow:[[_deleteDic allKeys][i] integerValue] inSection:0]];
        }
        [_deleteDic removeAllObjects];
        [_leftBtn setTitleColor:kCOLOR(197, 197, 197) forState:UIControlStateNormal];
        [LHPShaheObject saveMsgWithName:[NSString stringWithFormat:@"%@%@",kMessageMsg,KUserManager.uid] andWithMsg:_dataArray];
         _tableAccount=_tableAccount-(int)_deleteDic.count;

        
        NSString*namePath=[NSString stringWithFormat:@"kMessageCenter%@",KUserManager.uid];
        if ([LHPShaheObject checkPathIsOk:namePath]) {
            int countNub=[[NSString stringWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:namePath] encoding:NSUTF8StringEncoding error:nil] intValue];
            countNub-=_cancelUnreadArray.count;
            if (countNub<0) {
                countNub=0;
            }
            [LHPShaheObject saveUnreadMsgWithName:namePath andCount:countNub];
            [_unreadArray removeObjectsInArray:_cancelUnreadArray];
            [_cancelUnreadArray removeAllObjects];
            int nub=(int)_unreadArray.count;
            if (!nub) {
                [_readAllMsgBtn setTitle:@"全部阅读" forState:UIControlStateNormal];
            }else{
                [_readAllMsgBtn setTitle:[NSString stringWithFormat:@"全部阅读(%d)",nub] forState:UIControlStateNormal];
            }
        }
    }
    
    [_tableView reloadData];
    [self buildNoMsgViewWithHttpBool:NO];
    [sender setTitle:@"删除" forState:UIControlStateNormal];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray.count<10) {
        return _dataArray.count;
    }else
        return _tableAccount;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellIdentifier = @"Cell";
    CWSMessageCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[CWSMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    MyLog(@"%d-%lu",_tableAccount,(unsigned long)_dataArray.count);
        cell.cellDic=_dataArray[indexPath.row];
    return cell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (action) {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}

#pragma mark -
#pragma mark Table view delegate
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除这条信息吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定删除", nil];
    [alert show];
    alert.tag=12;
    
    deleIndexPath=indexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"完成"]) {
        [_deleteDic setObject:_dataArray[indexPath.row] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",(unsigned long)[[_deleteDic allKeys] count]] forState:UIControlStateNormal];
        if ([_dataArray[indexPath.row][@"isRead"] intValue]==0) {
            if (![_cancelUnreadArray containsObject:_dataArray[indexPath.row]]) {
                [_cancelUnreadArray addObject:_dataArray[indexPath.row]];
            }
        }
        if (!_dataArray.count) {
            [self buildNoMsgViewWithHttpBool:YES];
        }
    }else{
        if([_dataArray[indexPath.row][@"isRead"] intValue]==0){
            [self setUnreadMsgRead:(int)indexPath.row];
            [_tableView reloadData];
            
            NSString*namePath=[NSString stringWithFormat:@"kMessageCenter%@",KUserManager.uid];
            if ([LHPShaheObject checkPathIsOk:namePath]) {
                int countNub=[[NSString stringWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:namePath] encoding:NSUTF8StringEncoding error:nil] intValue];
                countNub-=1;
                if (countNub<0) {
                    countNub=0;
                }
                [LHPShaheObject saveUnreadMsgWithName:namePath andCount:countNub];
            }
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        CWSMessageDetailViewController*detailVC=[[CWSMessageDetailViewController alloc]initWithNibName:@"CWSMessageDetailViewController" bundle:nil];
        detailVC.title=@"消息详情";
        detailVC.detailDic=_dataArray[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"完成"]) {
        [_deleteDic removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        [_leftBtn setTitle:[NSString stringWithFormat:@"删除(%lu)",(unsigned long)[[_deleteDic allKeys] count]] forState:UIControlStateNormal];
        if (!_deleteDic.count) {
            [_leftBtn setTitleColor:kCOLOR(197, 197, 197) forState:UIControlStateNormal];
        }
        if ([_dataArray[indexPath.row][@"isRead"] intValue]==0) {
            if ([_cancelUnreadArray containsObject:_dataArray[indexPath.row]]) {
                [_cancelUnreadArray removeObject:_dataArray[indexPath.row]];
            }
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
