//
//  CWSContactsController.m
//  CarDefender
//
//  Created by 李散 on 15/4/2.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSContactsController.h"
#import "BaseTableViewCell.h"
#import "RealtimeSearchUtil.h"//实时搜索
#import "ChineseToPinyin.h"
#import "EMSearchBar.h"
#import "SRRefreshView.h"

#import "EMSearchDisplayController.h"


#import "AddFriendViewController.h"
#import "ApplyViewController.h"
#import "GroupListViewController.h"
#import "ChatViewController.h"

#import "CarFriendContactTopView.h"
#import "MainCell.h"
@interface CWSContactsController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UIActionSheetDelegate, BaseTableCellDelegate, SRRefreshDelegate>
{
    NSIndexPath *_currentLongPressIndex;
    NSMutableArray *titleDataArray;
    NSMutableArray*_friendArray;//好友数据
    NSMutableArray*_myCircleArray;//我的圈子数据
    NSMutableArray*_numberOfPublicArray;//公众号数据
    
    NSMutableDictionary*_allContactDataDic;//存好友数据、圈子、公众号数据
    NSMutableArray *selectedArr;//二级列表是否展开状态
    
}

@property (strong, nonatomic) NSMutableArray *contactsSource;//联系人
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *sectionTitles;

@property (strong, nonatomic) UILabel *unapplyCountLabel;//好友申请未读展示数量
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) SRRefreshView *slimeView;
@property (strong, nonatomic) GroupListViewController *groupController;//群试图

@property (strong, nonatomic) EMSearchDisplayController *searchController;//搜索试图

@end

@implementation CWSContactsController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    _dataSource = [NSMutableArray array];
    _contactsSource = [NSMutableArray array];
    _sectionTitles = [NSMutableArray array];
    selectedArr=[NSMutableArray array];
    _allContactDataDic=[NSMutableDictionary dictionary];
    [self searchController];
    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    [self.view addSubview:self.searchBar];
    
    self.tableView.frame = CGRectMake(0, self.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.searchBar.frame.size.height);
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.slimeView];//添加刷新
    
    [self.slimeView setLoadingWithExpansion];//expansion 扩展，膨胀，阐述
    
    [self getData];
}
-(void)getData{
    //分类
    titleDataArray = [[NSMutableArray alloc] initWithObjects:@"我的好友",@"我的圈子",@"我的公众号", nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadApplyView];
}

#pragma mark - getter

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[EMSearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}

- (UILabel *)unapplyCountLabel
{
    if (_unapplyCountLabel == nil) {
        _unapplyCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 5, 20, 20)];
        _unapplyCountLabel.textAlignment = NSTextAlignmentCenter;
        _unapplyCountLabel.font = [UIFont systemFontOfSize:11];
        _unapplyCountLabel.backgroundColor = [UIColor redColor];
        _unapplyCountLabel.textColor = [UIColor whiteColor];
        _unapplyCountLabel.layer.cornerRadius = _unapplyCountLabel.frame.size.height / 2;
        _unapplyCountLabel.hidden = YES;
        _unapplyCountLabel.clipsToBounds = YES;
    }
    
    return _unapplyCountLabel;
}

- (SRRefreshView *)slimeView
{
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return _slimeView;
}

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];//没有数据就展示为空状态没有 空cell
        _tableView.tableHeaderView=self.topTabelView;
    }
    return _tableView;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak CWSContactsController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            EMBuddy *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"chatListCellHead.png"];
            cell.textLabel.text = buddy.username;
            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            EMBuddy *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
            NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
            if (loginUsername && loginUsername.length > 0) {
                if ([loginUsername isEqualToString:buddy.username]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                    [alertView show];
                    
                    return;
                }
            }
            
            [weakSelf.searchController.searchBar endEditing:YES];
            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:buddy.username isGroup:NO];
            chatVC.title = buddy.username;
            UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:chatVC];
//            [weakSelf.navigationController pushViewController:chatVC animated:YES];
            [weakSelf presentViewController:nav animated:YES completion:nil];
        }];
    }
    
    return _searchController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
//    return [self.dataSource count] + 1;
    return titleDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *string = [NSString stringWithFormat:@"%d",(int)section];
    MyLog(@"%@\n%@",string,selectedArr);
    if ([selectedArr containsObject:string]) {
        
        UIImageView *imageV = (UIImageView *)[_tableView viewWithTag:20000+section];
        imageV.image = [UIImage imageNamed:@"buddy_header_arrow_down@2x.png"];
        
        NSArray *array1 = _allContactDataDic[string];
        return array1.count;
    }
    return 0;
    
//    return [[self.dataSource objectAtIndex:(section - 1)] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当前是第几个表头
    NSString *indexStr = [NSString stringWithFormat:@"%d",(int)indexPath.section];
    
        static NSString *CellIdentifier = @"MainCell";
        
        MainCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        if ([selectedArr containsObject:indexStr]) {
            cell.Headerphoto.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",arc4random()%11]];
            EMBuddy*budy=_friendArray[indexPath.row];
            cell.nameLabel.text = budy.username;
            cell.IntroductionLabel.text = @"他开着你的花，在每一个晚霞，靠着你的肩膀绣着枝桠";
            cell.networkLabel.text = @"2G";
        }
        
//        if (indexPath.row == dataArray.count-1) {
//            cell.imageLine.image = nil;
//        }
//        else
//            cell.imageLine.image = [UIImage imageNamed:@"line.png"];
    
        return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 0) {
        [self isViewLoaded];
        return NO;
    }
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        EMBuddy *buddy = [[self.dataSource objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
        if ([buddy.username isEqualToString:loginUsername]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notDeleteSelf", @"can't delete self") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
        
        [tableView beginUpdates];
        [[self.dataSource objectAtIndex:(indexPath.section - 1)] removeObjectAtIndex:indexPath.row];
        [self.contactsSource removeObject:buddy];
        [tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView  endUpdates];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error;
            [[EaseMob sharedInstance].chatManager removeBuddy:buddy.username removeFromRemote:YES error:&error];
            if (!error) {
                [[EaseMob sharedInstance].chatManager removeConversationByChatter:buddy.username deleteMessages:YES append2Chat:YES];
            }
        });
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    
//    if ([_allContactDataDic[indexStr][indexPath.row][@"cell"] isEqualToString:@"MainCell"])
//    {
//        return 60;
//    }
//    else
        return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
//Section Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, tableView.frame.size.width-20, 30)];
    titleLabel.text = [titleDataArray objectAtIndex:section];
    [view addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 15, 15)];
    imageView.tag = 20000+section;
    
    //判断是不是选中状态
    NSString *string = [NSString stringWithFormat:@"%ld",(long)section];
    
    if ([selectedArr containsObject:string]) {
        imageView.image = [UIImage imageNamed:@"buddy_header_arrow_down@2x.png"];
    }
    else
    {
        imageView.image = [UIImage imageNamed:@"buddy_header_arrow_right@2x.png"];
    }
    [view addSubview:imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 320, 40);
    button.tag = 100+section;
    [button addTarget:self action:@selector(doButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, 320, 1)];
    lineImage.image = [UIImage imageNamed:@"line.png"];
    [view addSubview:lineImage];
    
    return view;
}
-(void)doButton:(UIButton *)sender
{
    NSString *string = [NSString stringWithFormat:@"%d",(int)sender.tag-100];
    
    //数组selectedArr里面存的数据和表头想对应，方便以后做比较
    if ([selectedArr containsObject:string])
    {
        [selectedArr removeObject:string];
    }
    else
    {
        [selectedArr addObject:string];
    }
    MyLog(@"%@\n%@",selectedArr,string);
    [_tableView reloadData];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:[ApplyViewController shareController]];
//            [self.navigationController pushViewController:nav animated:YES];
            [self presentViewController:nav animated:YES completion:nil];
        }
        else if (indexPath.row == 1)
        {
            if (_groupController == nil) {
                _groupController = [[GroupListViewController alloc] initWithStyle:UITableViewStylePlain];
            }
            else{
                [_groupController reloadDataSource];
            }
//            [self.navigationController pushViewController:_groupController animated:YES];
            UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:_groupController];
//            [self.navigationController pushViewController:nav animated:YES];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
    else{
        EMBuddy *buddy = [[self.dataSource objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
        NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
        NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
        if (loginUsername && loginUsername.length > 0) {
            if ([loginUsername isEqualToString:buddy.username]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                [alertView show];
                
                return;
            }
        }
        
        ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:buddy.username isGroup:NO];
        chatVC.title = buddy.username;
        UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:chatVC];
//        [self.navigationController pushViewController:chatVC animated:YES];
        [self presentViewController:nav animated:YES completion:nil];
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
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.contactsSource searchText:(NSString *)searchText collationStringSelector:@selector(username) resultBlock:^(NSArray *results) {
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

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex && _currentLongPressIndex) {
        EMBuddy *buddy = [[self.dataSource objectAtIndex:(_currentLongPressIndex.section - 1)] objectAtIndex:_currentLongPressIndex.row];
        [self.tableView beginUpdates];
        [[self.dataSource objectAtIndex:(_currentLongPressIndex.section - 1)] removeObjectAtIndex:_currentLongPressIndex.row];
        [self.contactsSource removeObject:buddy];
        [self.tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:_currentLongPressIndex] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView  endUpdates];
        
        [[EaseMob sharedInstance].chatManager blockBuddy:buddy.username relationship:eRelationshipBoth];
    }
    
    _currentLongPressIndex = nil;
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
//刷新列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    __weak CWSContactsController *weakSelf = self;
    [[[EaseMob sharedInstance] chatManager] asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error) {
            [weakSelf reloadDataSource];
        }
        [weakSelf.slimeView endRefresh];
    } onQueue:nil];
}

#pragma mark - BaseTableCellDelegate

- (void)cellImageViewLongPressAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        // 群组
        return;
    }
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    EMBuddy *buddy = [[self.dataSource objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
    if ([buddy.username isEqualToString:loginUsername])
    {
        return;
    }
    
    _currentLongPressIndex = indexPath;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") destructiveButtonTitle:NSLocalizedString(@"friend.block", @"join the blacklist") otherButtonTitles:nil, nil];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

#pragma mark - private

- (NSMutableArray *)sortDataArray:(NSArray *)dataArray
{
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //名字分section
    for (EMBuddy *buddy in dataArray) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:buddy.username];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:buddy];
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(EMBuddy *obj1, EMBuddy *obj2) {
            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1.username];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2.username];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    return sortedArray;
}

#pragma mark - dataSource

- (void)reloadDataSource
{
    [self showHudInView:self.view hint:NSLocalizedString(@"refreshData", @"Refresh data...")];
    [self.dataSource removeAllObjects];
    [self.contactsSource removeAllObjects];
    
    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    for (EMBuddy *buddy in buddyList) {
        if (buddy.followState != eEMBuddyFollowState_NotFollowed) {
            [self.contactsSource addObject:buddy];
        }
    }
    
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    if (loginUsername && loginUsername.length > 0) {
        EMBuddy *loginBuddy = [EMBuddy buddyWithUsername:loginUsername];
        [self.contactsSource addObject:loginBuddy];
    }
    
//    [self.dataSource addObjectsFromArray:[self sortDataArray:self.contactsSource]];
    _friendArray = [NSMutableArray arrayWithArray:self.contactsSource];
    [_allContactDataDic setObject:_friendArray forKey:@"0"];
    
    [_tableView reloadData];
    [self hideHud];
}

#pragma mark - action

- (void)reloadApplyView
{
    NSInteger count = [[[ApplyViewController shareController] dataSource] count];
    
    if (count == 0) {
        self.unapplyCountLabel.hidden = YES;
    }
    else
    {
        NSString *tmpStr = [NSString stringWithFormat:@"%i", (int)count];
        CGSize size = [tmpStr sizeWithFont:self.unapplyCountLabel.font constrainedToSize:CGSizeMake(50, 20) lineBreakMode:NSLineBreakByWordWrapping];
        CGRect rect = self.unapplyCountLabel.frame;
        rect.size.width = size.width > 20 ? size.width : 20;
        self.unapplyCountLabel.text = tmpStr;
        self.unapplyCountLabel.frame = rect;
        self.unapplyCountLabel.hidden = NO;
    }
}

- (void)reloadGroupView
{
    [self reloadApplyView];
    
    if (_groupController) {
        [_groupController reloadDataSource];
    }
}

- (void)addFriendAction
{
    AddFriendViewController *addController = [[AddFriendViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:addController animated:YES];
}

@end
