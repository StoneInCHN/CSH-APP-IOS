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
    NSMutableArray* originalDataArray;
    
    UIBarButtonItem* rightBarButtonItem;
    UIBarButtonItem* leftBarButtonItem;
    UIBarButtonItem* currentLeftBarButtonItem;
    UIView* toolView;
    UILabel* deleteCountLabel;
    NSMutableArray *models;
    
    int deleteCount;
    CWSNoDataView* _noCarView;
    UserInfo *userInfo;
}

@end

@implementation CWSUserMessageCenterViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"CWSUserMessageCenterViewController message list :%@",self.messageList);
    userInfo = [UserInfo userDefault];
    [self initialData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    currentLeftBarButtonItem = self.navigationItem.leftBarButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"message_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllMessage)];
}

#pragma mark 删除所有信息
- (void)deleteAllMessage {
    if ([self.messageList isKindOfClass:[NSNull class]] || self.messageList.count == 0) {
        [MBProgressHUD showError:@"当前没有可以删除的消息" toView:self.view];
        return;
    }
    
    NSMutableArray *deleteMessages = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.messageList) {
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
                                            [self.messageList removeAllObjects];
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
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}
#pragma mark -================================InitialData
-(void)initialData{
    dataArray = self.messageList;
    if(!dataArray){
        dataArray = @[].mutableCopy;
        originalDataArray = @[].mutableCopy;
    }
    [self loadData];
}
- (void)getData{
        [self loadData];
        [self createTableView];
        [self customizeNavigationItem];
}
-(void)loadData{
    
    if (dataArray.count == 0) {
        [self createNoDataView];
    } else {
        [self createTableView];
//        [self customizeNavigationItem];
    }
    /*
    for(int i=0; i<50; i++){
        
        CWSUserMessageCenterModel* model = [CWSUserMessageCenterModel new];
        model.messageTitle = [NSString stringWithFormat:@"这是消息标题%d",i];
        model.messageContent = [NSString stringWithFormat:@"这是消息内容%d",i];
        model.messageType = arc4random() % 5;
        model.messageDate = @"2015-12-10";
        [dataArray addObject:model];
    }
    [originalDataArray removeAllObjects];
    [dataArray removeAllObjects];
     originalDataArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"userInformations"]];
    if(originalDataArray.count){
        
        if(_noCarView != nil){
            _noCarView = nil;
            [_noCarView removeFromSuperview];
        }
        
        NSArray* resultArray = [originalDataArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            NSNumber* number1 = [NSNumber numberWithInteger:[obj1[@"id"] integerValue]];
            NSNumber* number2 = [NSNumber numberWithInteger:[obj2[@"id"] integerValue]];
            
            NSComparisonResult result = [number1 compare:number2];
            return result == NSOrderedAscending;  //降序
        }];
        for (NSDictionary* dict in resultArray) {
            CWSUserMessageCenterModel* model = [[CWSUserMessageCenterModel alloc]initWithDict:dict];
            [dataArray addObject:model];
        }
        
        [self createTableView];
        [self customizeNavigationItem];
    }else{
        [self createNoDataView];
    }
     */
}
#pragma mark 下拉刷新
- (void)headerRefreshing {
    [MBProgressHUD showSuccess:@"more" toView:self.view];
    [myTableView.mj_header endRefreshing];
}
#pragma mark -================================CreateUI

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
    myTableView.rowHeight = 70.0f;
    myTableView.showsHorizontalScrollIndicator = NO;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.allowsMultipleSelectionDuringEditing = YES;
    [myTableView setEditing:NO];
    [self setExtraCellLineHidden:myTableView];
    [myTableView registerNib:[UINib nibWithNibName:@"CWSUserMessageInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MessageInfoCell"];
    myTableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    [self.view addSubview:myTableView];
}

-(void)customizeNavigationItem{
    
    rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"message_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(deleteBarButtonClicked:)];
    leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarButtonClicked:)];
    [leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : KBlueColor} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    
    toolView = [[UIView alloc]initWithFrame:CGRectMake(0, kSizeOfScreen.height-kDockHeight, kSizeOfScreen.width, 45)];
    toolView.backgroundColor = KGrayColor2;
    deleteCountLabel =  [[UILabel alloc]initWithFrame:CGRectMake(10, (toolView.frame.size.height-18)/2, 100, 18)];
    deleteCountLabel.text = @"删除";
    deleteCountLabel.textColor = [UIColor grayColor];
    deleteCountLabel.textAlignment = NSTextAlignmentLeft;
    deleteCountLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [toolView addSubview:deleteCountLabel];
    UILabel* deleteAllLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSizeOfScreen.width-10-33, (toolView.frame.size.height-18)/2, 33, 18)];
    deleteAllLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    deleteAllLabel.text = @"清空";
    deleteAllLabel.textColor = KBlueColor;
    [toolView addSubview:deleteAllLabel];
    
    UIButton* deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteButton.frame = CGRectMake(0, 0, 66, toolView.frame.size.height);
    [deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:deleteButton];
    
    UIButton* deleteAllButton = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteAllButton.frame = CGRectMake(kSizeOfScreen.width-50, 0, 50, toolView.frame.size.height);
    [deleteAllButton addTarget:self action:@selector(deleteAllButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:deleteAllButton];
    
    
    [self.view addSubview:toolView];
}


#pragma mark -================================TableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CWSUserMessageInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MessageInfoCell"];
    CWSUserMessageCenterModel *model =  [[CWSUserMessageCenterModel alloc] initWithDict:dataArray[indexPath.row]];
    [cell setUserMessageModel:model];
    [models addObject:model];
    if(myTableView.editing){
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)readMessage:(NSDictionary *)detailDic withIndexPath:(NSIndexPath *)indexPath{
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
    [self readMessage:dataArray[indexPath.row] withIndexPath:indexPath];
    
    CWSMessageDetailViewController *messageDetailVC = [[CWSMessageDetailViewController alloc] init];
    messageDetailVC.detailDic = dataArray[indexPath.row];
    [self.navigationController pushViewController:messageDetailVC animated:YES];
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(myTableView.editing){
        deleteCount--;
        if(deleteCount<2){
            deleteCountLabel.text = @"删除";
        }else{
            deleteCountLabel.text = [NSString stringWithFormat:@"删除(%d)",deleteCount];
        }
    }
}


/**列表滑动删除时的回调方法*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
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
                                            [self.messageList removeObjectAtIndex:indexPath.row];
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
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


#pragma mark -=========================================================OtherCallBack
/**消息删除按钮*/
-(void)deleteBarButtonClicked:(UIBarButtonItem*)sender{
    
    [myTableView setEditing:YES animated:YES];
    CGRect rect = myTableView.frame;
    rect.size.height -= toolView.frame.size.height;
    myTableView.frame = rect;
    
    [myTableView reloadData];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    [self changeUIViewAnimationWithSubType:(-45.0f)];
}

/**取消删除按钮*/
-(void)cancelBarButtonClicked:(UIBarButtonItem*)sender{
    
    [myTableView setEditing:NO animated:YES];
    [myTableView reloadData];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.navigationItem.leftBarButtonItem = currentLeftBarButtonItem;
    [self changeUIViewAnimationWithSubType:45.0f];
}


/**清空按钮回调*/
-(void)deleteAllButtonClicked:(UIButton*)sender{
    if(myTableView.editing){
        if(dataArray.count){
            int tempDeleteCount = deleteCount;
            deleteCount = 0;
            for(int i=0; i<dataArray.count; i++){
                NSIndexPath* selectedIndex = [NSIndexPath indexPathForRow:i inSection:0];
                [self tableView:myTableView didSelectRowAtIndexPath:selectedIndex];
                [myTableView selectRowAtIndexPath:selectedIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
            [WCAlertView showAlertWithTitle:@"温馨提示" message:@"您要清除全部消息?" customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                if(!buttonIndex){
                    deleteCount -= tempDeleteCount;
                    for(int i=0; i<dataArray.count; i++){
                        NSIndexPath* selectedIndex = [NSIndexPath indexPathForRow:i inSection:0];
                        [self tableView:myTableView didDeselectRowAtIndexPath:selectedIndex];
                        [myTableView deselectRowAtIndexPath:selectedIndex animated:YES];
                    }
                    deleteCount = 0;
                }else{
                    [originalDataArray removeAllObjects];
                    [[NSUserDefaults standardUserDefaults] setObject:originalDataArray forKey:@"userInformations"];
                    [NSUserDefaults resetStandardUserDefaults];
                    [dataArray removeAllObjects];
                    [myTableView reloadData];
                    [self cancelBarButtonClicked:nil];
                }
            } cancelButtonTitle:@"算了" otherButtonTitles:@"是的", nil];
        }else{
            [WCAlertView showAlertWithTitle:nil message:@"您还没有任何消息" customizationBlock:nil completionBlock:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        }
    }
}


/**删除按钮回调*/
-(void)deleteButtonClicked:(UIButton*)sender{
    
    if(!deleteCount){
        if(!dataArray.count){
            [WCAlertView showAlertWithTitle:nil message:@"您还没有任何消息" customizationBlock:nil completionBlock:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        }else{
            [WCAlertView showAlertWithTitle:nil message:@"您还没有选择!" customizationBlock:nil completionBlock:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        }
    }else{
        NSMutableArray* indexPathArray = [[myTableView indexPathsForSelectedRows] mutableCopy];
        [indexPathArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSIndexPath* indexPath1 = obj1;
            NSIndexPath* indexPath2 = obj2;
            return indexPath1.section == indexPath2.section ? indexPath1.row < indexPath2.row : indexPath1.section < indexPath2.section;//按照降序排列
        }];
        
        for (NSIndexPath* removeIndex in indexPathArray) {
            [self deleteFromOriginalDataWithId:dataArray[removeIndex.row]];
            [dataArray removeObjectAtIndex:removeIndex.row];
            [myTableView deleteRowsAtIndexPaths:@[removeIndex] withRowAnimation:UITableViewRowAnimationLeft];
            if(!dataArray.count){
                [self createNoDataView];
            }
        }
        [self cancelBarButtonClicked:nil];
    }

}

/**删除UserdefaultsData*/
-(void)deleteFromOriginalDataWithId:(CWSUserMessageCenterModel*)thyModel{
    for (NSDictionary* dict in originalDataArray) {
        if([[dict[@"id"] stringValue] isEqualToString:thyModel.messageId]){
            [originalDataArray removeObject:dict];
            break;
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:originalDataArray forKey:@"userInformations"];
    [NSUserDefaults resetStandardUserDefaults];
}


/**UIView动画*/
-(void)changeUIViewAnimationWithSubType:(CGFloat)dealtaY{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect toolViewY;
        toolViewY = toolView.frame;
        toolViewY.origin.y = toolViewY.origin.y + dealtaY;
        toolView.frame = toolViewY;
        if(dealtaY > 0){
            CGRect rect = myTableView.frame;
            rect.size.height += toolView.frame.size.height;
            myTableView.frame = rect;
        }
        
    } completion:^(BOOL finished) {
        if(!myTableView.editing){
            deleteCountLabel.text = @"删除";
            deleteCount = 0;
        }
    }];
}



-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
