//
//  CWChatListController.m
//  CarDefender
//
//  Created by 李散 on 15/4/2.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWChatListController.h"
#import "SRRefreshView.h"
#import "ChatListCell.h"
#import "EMSearchBar.h"
#import "NSDate+Category.h"
#import "RealtimeSearchUtil.h"
#import "ChatViewController.h"
#import "EMSearchDisplayController.h"
#import "ConvertToCommonEmoticonsHelper.h"//表情
@interface CWChatListController ()<UITableViewDelegate,UITableViewDataSource, UISearchDisplayDelegate,SRRefreshDelegate, UISearchBarDelegate, IChatManagerDelegate>
@property (strong, nonatomic) NSMutableArray        *dataSource;

@property (strong, nonatomic) UITableView           *tableView;
@property (nonatomic, strong) EMSearchBar           *searchBar;
@property (nonatomic, strong) SRRefreshView         *slimeView;
@property (nonatomic, strong) UIView                *networkStateView;//没有网络时展现状态

@property (strong, nonatomic) EMSearchDisplayController *searchController;
@end

@implementation CWChatListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeEmptyConversationsFromDB];//移除说有空会话
    [Utils changeBackBarButtonStyle:self];
    [self.view addSubview:self.searchBar];//加载搜索
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.slimeView];
    [self networkStateView];
    
    [self searchController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshDataSource];//注册刷新事件
    [self registerNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}

#pragma mark - getter

- (SRRefreshView *)slimeView
{
    if (!_slimeView) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
        _slimeView.backgroundColor = [UIColor whiteColor];
    }
    
    return _slimeView;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.backgroundColor = kCOLOR(212, 212, 212);
        
    }
    
    return _searchBar;
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)hsearchBar
{
    _searchBar.showsCancelButton = YES;
//   [_searchBar setCancelButtonTitle:@"取消"];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ChatListCell class] forCellReuseIdentifier:@"chatListCell"];
    }
    
    return _tableView;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak CWChatListController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ChatListCell";
            ChatListCell *cell = (ChatListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            EMConversation *conversation = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            cell.name = conversation.chatter;
            if (!conversation.isGroup) {
                cell.placeholderImage = [UIImage imageNamed:@"chatListCellHead.png"];
            }
            else{
                NSString *imageName = @"groupPublicHeader";
                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:conversation.chatter]) {
                        cell.name = group.groupSubject;
                        imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                        break;
                    }
                }
                cell.placeholderImage = [UIImage imageNamed:imageName];
            }
            cell.detailMsg = [weakSelf subTitleMessageByConversation:conversation];
            cell.time = [weakSelf lastMessageTimeByConversation:conversation];
            cell.unreadCount = [weakSelf unreadMessageCountByConversation:conversation];
            if (indexPath.row % 2 == 1) {
                cell.contentView.backgroundColor = RGBACOLOR(246, 246, 246, 1);
            }else{
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
            EMConversation *conversation = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:conversation.chatter isGroup:conversation.isGroup];
            chatVC.title = conversation.chatter;
            UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:chatVC];
//            [weakSelf.navigationController pushViewController:chatVC animated:YES];
            [weakSelf presentViewController:nav animated:YES completion:nil];
        }];
    }
    
    return _searchController;
}
- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

#pragma mark - private
//获取数据并排序
- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    return ret;
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                ret = didReceiveText;
            } break;
            case eMessageBodyType_Voice:{
                ret = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case eMessageBodyType_Location: {
                ret = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case eMessageBodyType_Video: {
                ret = NSLocalizedString(@"message.vidio1", @"[vidio]");
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}

#pragma mark - TableViewDelegate & TableViewDatasource

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"chatListCell";
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    cell.name = conversation.chatter;
    if (!conversation.isGroup) {
        cell.placeholderImage = [UIImage imageNamed:@"chatListCellHead.png"];
    }
    else{
        NSString *imageName = @"groupPublicHeader";
        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *group in groupArray) {
            if ([group.groupId isEqualToString:conversation.chatter]) {
                cell.name = group.groupSubject;
                imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                break;
            }
        }
        cell.placeholderImage = [UIImage imageNamed:imageName];
    }
    cell.detailMsg = [self subTitleMessageByConversation:conversation];
    cell.time = [self lastMessageTimeByConversation:conversation];
    cell.unreadCount = [self unreadMessageCountByConversation:conversation];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    
    ChatViewController *chatController;
    NSString *title = conversation.chatter;
    if (conversation.isGroup) {
        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *group in groupArray) {
            if ([group.groupId isEqualToString:conversation.chatter]) {
                title = group.groupSubject;
                break;
            }
        }
    }
    
    NSString *chatter = conversation.chatter;
    chatController = [[ChatViewController alloc] initWithChatter:chatter isGroup:conversation.isGroup];
    chatController.title = title;
//    [self.navigationController pushViewController:chatController animated:YES];
    UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:chatController];
    [self presentViewController:nav animated:YES completion:nil];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMConversation *converation = [self.dataSource objectAtIndex:indexPath.row];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:YES append2Chat:YES];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataSource searchText:(NSString *)searchText collationStringSelector:@selector(chatter) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchController.resultsSource removeAllObjects];
                [self.searchController.resultsSource addObjectsFromArray:results];
                [self.searchController.searchResultsTableView reloadData];
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate
//刷新消息列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self refreshDataSource];
    [_slimeView endRefresh];
}

#pragma mark - IChatMangerDelegate
//未读信息数量变化
-(void)didUnreadMessagesCountChanged
{
    [self refreshDataSource];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"chatUnreadMessagesCountChanged" object:nil];
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self refreshDataSource];
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
}

#pragma mark - public

-(void)refreshDataSource
{
    self.dataSource = [self loadDataSource];
    [_tableView reloadData];
    [self hideHud];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        _tableView.tableHeaderView = _networkStateView;//如果网络变化了 --  没网就添加头部文件
    }
    else{
        _tableView.tableHeaderView = nil;
    }
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionDisconnected) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }
}

- (void)willReceiveOfflineMessages{
    NSLog(NSLocalizedString(@"message.beginReceiveOffine", @"Begin to receive offline messages"));
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages{
    NSLog(NSLocalizedString(@"message.endReceiveOffine", @"End to receive offline messages"));
    [self refreshDataSource];
}

@end
