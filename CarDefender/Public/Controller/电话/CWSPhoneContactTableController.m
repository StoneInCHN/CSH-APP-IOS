//
//  CWSPhoneContactTableController.m
//  CarDefender
//
//  Created by 李散 on 15/5/5.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSPhoneContactTableController.h"
#import "pinyin.h"
#import "POAPinyin.h"

#import "CWSPhoneWaitController.h"
@interface CWSPhoneContactTableController ()
{
    CWSPhoneWaitController*_phoneWaitVC;//拨打电话等待界面
}
@end

@implementation CWSPhoneContactTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"联系人";
    [Utils changeBackBarButtonStyle:self];
    filteredArray=[[NSMutableArray alloc] init];
    sectionDic= [[NSMutableDictionary alloc] init];
    phoneDic=[[NSMutableDictionary alloc] init];
    contactDic=[[NSMutableDictionary alloc] init];
    //获取联系人数据
    
//    [self loadContacts];
}
-(void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    
}
-(BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.searchDisplayController isActive]) {
        ABAuthorizationStatus addressBookStatus = ABAddressBookGetAuthorizationStatus();
        if (addressBookStatus == kABAuthorizationStatusAuthorized) {
            [self loadContacts];
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"通讯录权限获取失败，您可以按着步骤去设置获取通讯录权限：设置-隐私-通讯录 然后找到“车生活”并打开权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=Contact"]];
            
        }
        [self.tableView reloadData];
    }
    [self.searchDisplayController.searchResultsTableView reloadData];
}
//导入通讯录
-(void)loadContacts
{
    
    
    [sectionDic removeAllObjects];
    [phoneDic   removeAllObjects];
    [contactDic removeAllObjects];
    
    //添加A-Z#右侧导航条title
    for (int i = 0; i < 26; i++)
        [sectionDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'A'+i]];
    [sectionDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'#']];
    
    ABAddressBookRef myAddressBook = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        myAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(myAddressBook, ^(bool granted, CFErrorRef error) {
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(myAddressBook);
    CFMutableArrayRef mresults=CFArrayCreateMutableCopy(kCFAllocatorDefault,
                                                        CFArrayGetCount(results),
                                                        results);
    //将结果按照拼音排序，将结果放入mresults数组中
    CFArraySortValues(mresults,
                      CFRangeMake(0, CFArrayGetCount(results)),
                      (CFComparatorFunction) ABPersonComparePeopleByName,
                      (void*) ABPersonGetSortOrdering());
    //遍历所有联系人
    for (int k=0;k<CFArrayGetCount(mresults);k++) {
        //创建联系人对象
        ABRecordRef record=CFArrayGetValueAtIndex(mresults, k);
        //联系人姓名
        NSString *personname = (__bridge NSString *)ABRecordCopyCompositeName(record);
        MyLog(@"%@",personname);
        //获取联系人的电话属性，初始化为多值
        ABMultiValueRef phone = ABRecordCopyValue(record, kABPersonPhoneProperty);
        ABRecordID recordID=ABRecordGetRecordID(record);
        
        char first=pinyinFirstLetter([personname characterAtIndex:0]);
        NSString *sectionName;
        //一些常用于姓的多音字
        if ((first>='a'&&first<='z')||(first>='A'&&first<='Z')) {
            if([self searchResult:personname searchText:@"曾"])
                sectionName = @"Z";
            else if([self searchResult:personname searchText:@"解"])
                sectionName = @"X";
            else if([self searchResult:personname searchText:@"仇"])
                sectionName = @"Q";
            else if([self searchResult:personname searchText:@"朴"])
                sectionName = @"P";
            else if([self searchResult:personname searchText:@"查"])
                sectionName = @"Z";
            else if([self searchResult:personname searchText:@"能"])
                sectionName = @"N";
            else if([self searchResult:personname searchText:@"乐"])
                sectionName = @"Y";
            else if([self searchResult:personname searchText:@"单"])
                sectionName = @"S";
            else
                sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([personname characterAtIndex:0])] uppercaseString];
        }
        else {
            sectionName=[[NSString stringWithFormat:@"%c",'#'] uppercaseString];
        }
        
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            NSRange range=NSMakeRange(0,3);
            NSString *str=[personPhone substringWithRange:range];
            if ([str isEqualToString:@"+86"]) {
                personPhone=[personPhone substringFromIndex:3];
            }
            
            [phoneDic setObject:(__bridge id)(record) forKey:[NSString stringWithFormat:@"%@%d",personPhone,recordID]];
            
        }
        
        [[sectionDic objectForKey:sectionName] addObject:(__bridge id)(record)];
        [contactDic setObject:(__bridge id)(record) forKey:[NSNumber numberWithInt:recordID]];
    }
    MyLog(@"sectionDic - \n%@\n contactDic \n%@",sectionDic,contactDic);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableView代理方法
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    tableView.sectionIndexBackgroundColor=[UIColor clearColor];
    tableView.sectionIndexColor=[UIColor lightGrayColor];
    if ([tableView isEqual:self.tableView]) {
        NSMutableArray *indices = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
        for (int i = 0; i < 27; i++)
            [indices addObject:[[ALPHA substringFromIndex:i] substringToIndex:1]];
        return indices;
    }
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (title == UITableViewIndexSearch)
    {
        [self.tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
        return -1;
    }
    
    return  [ALPHA rangeOfString:title].location;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:self.tableView]) {
        return 27;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        NSString *key=[NSString stringWithFormat:@"%c",[ALPHA characterAtIndex:section]];
        return  [[sectionDic objectForKey:key] count];
    }
    return [filteredArray count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return nil;
    }
    NSString *key=[NSString stringWithFormat:@"%c",[ALPHA characterAtIndex:section]];
    if ([[sectionDic objectForKey:key] count]!=0) {
        return key;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (![tableView isEqual:self.tableView]) {
        //搜索结果
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        NSDictionary *person=[filteredArray objectAtIndex:indexPath.row];
        cell.textLabel.text=[person objectForKey:@"name"];
        cell.detailTextLabel.text=[person objectForKey:@"phone"];
    }
    else {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        NSString *key=[NSString stringWithFormat:@"%c",[ALPHA characterAtIndex:indexPath.section]];
        NSMutableArray *persons=[sectionDic objectForKey:key];
        ABRecordRef record=(__bridge ABRecordRef)([persons objectAtIndex:indexPath.row]);
        cell.textLabel.text=(__bridge NSString *)ABRecordCopyCompositeName(record);
        //用户头像
        //        NSData *imageData=(__bridge NSData*)ABPersonCopyImageData(record);
        //        [cell.imageView setImage:[UIImage imageWithData:imageData]];
        //         cell.imageView.contentMode=UIViewContentModeScaleToFill;
        
        ABMultiValueRef phones = ABRecordCopyValue(record, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phones); k++)
        {
            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, k);
            if (k==0) {//默认获取第一个联系人电话
                cell.detailTextLabel.text=personPhone;
            }
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ABRecordRef person;
    if (![tableView isEqual:self.tableView]) {
        NSMutableDictionary *record=[filteredArray objectAtIndex:indexPath.row];
        NSString *recordID=[record objectForKey:@"ID"];
        person=(__bridge ABRecordRef)([contactDic objectForKey:recordID]);
    }else {
        NSString *key=[NSString stringWithFormat:@"%c",[ALPHA characterAtIndex:indexPath.section]];
        NSMutableArray *persons=[sectionDic objectForKey:key];
        person=(__bridge ABRecordRef)([persons objectAtIndex:indexPath.row]);
    }
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (int k = 0; k<ABMultiValueGetCount(phones); k++)
    {
        //获取該Label下的电话值
        NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, k);
        //联系人姓名
        NSString *personname = (__bridge NSString *)ABRecordCopyCompositeName(person);
        if (k==0) {
            [self makePhoneCallWithPhoneNub:personPhone withName:personname];
        }
       
    }
}
-(BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT{
    NSComparisonResult result = [contactName compare:searchT options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, searchT.length)];
    if (result == NSOrderedSame)
        return YES;
    else
        return NO;
}
#pragma UISearchDisplayDelegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self performSelectorOnMainThread:@selector(searchWithString:) withObject:searchString waitUntilDone:YES];
    
    return YES;
}
#pragma mark - 检索联系人
-(void)searchWithString:(NSString *)searchString
{
    [filteredArray removeAllObjects];
    NSString * regex        = @"(^[0-9]+$)";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([searchString length]!=0) {
        if ([pred evaluateWithObject:searchString]) { //判断是否是数字
            NSArray *phones=[phoneDic allKeys];
            for (NSString *phone in phones) {
                if ([self searchResult:phone searchText:searchString]) {
                    ABRecordRef person=(__bridge ABRecordRef)([phoneDic objectForKey:phone]);
                    ABRecordID recordID=ABRecordGetRecordID(person);
                    NSString *ff=[NSString stringWithFormat:@"%d",recordID];
                    
                    NSString *name=(__bridge NSString *)ABRecordCopyCompositeName(person);
                    NSMutableDictionary *record=[[NSMutableDictionary alloc] init];
                    [record setObject:name forKey:@"name"];
                    [record setObject:[phone substringToIndex:(phone.length-ff.length)] forKey:@"phone"];
                    [record setObject:[NSNumber numberWithInt:recordID] forKey:@"ID"];
                    [filteredArray addObject:record];
                }
            }
        }
        else {
            //搜索对应分类下的数组
            NSString *sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([searchString characterAtIndex:0])] uppercaseString];
            NSArray *array=[sectionDic objectForKey:sectionName];
            for (int j=0;j<[array count];j++) {
                ABRecordRef person=(__bridge ABRecordRef)([array objectAtIndex:j]);
                NSString *name=(__bridge NSString *)ABRecordCopyCompositeName(person);
                if ([self searchResult:name searchText:searchString]) { //先按输入的内容搜索
                    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
                    NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, 0);
                    ABRecordID recordID=ABRecordGetRecordID(person);
                    NSMutableDictionary *record=[[NSMutableDictionary alloc] init];
                    [record setObject:name forKey:@"name"];
                    if (personPhone.length) {
                        [record setObject:personPhone forKey:@"phone"];
                    }else{
                        [record setObject:@"" forKey:@"phone"];
                    }
                    [record setObject:[NSNumber numberWithInt:recordID] forKey:@"ID"];
                    [filteredArray addObject:record];
                }
                else { //按拼音搜索
                    NSString *string = @"";
                    NSString *firststring=@"";
                    for (int i = 0; i < [name length]; i++)
                    {
                        if([string length] < 1)
                            string = [NSString stringWithFormat:@"%@",
                                      [POAPinyin quickConvert:[name substringWithRange:NSMakeRange(i,1)]]];
                        else
                            string = [NSString stringWithFormat:@"%@%@",string,
                                      [POAPinyin quickConvert:[name substringWithRange:NSMakeRange(i,1)]]];
                        if([firststring length] < 1)
                            firststring = [NSString stringWithFormat:@"%c",
                                           pinyinFirstLetter([name characterAtIndex:i])];
                        else
                        {
                            if ([name characterAtIndex:i]!=' ') {
                                firststring = [NSString stringWithFormat:@"%@%c",firststring,
                                               pinyinFirstLetter([name characterAtIndex:i])];
                            }
                            
                        }
                    }
                    if ([self searchResult:string searchText:searchString]
                        ||[self searchResult:firststring searchText:searchString])
                    {
                        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
                        NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, 0);
                        ABRecordID recordID=ABRecordGetRecordID(person);
                        NSMutableDictionary *record=[[NSMutableDictionary alloc] init];
                        [record setObject:name forKey:@"name"];
                        [record setObject:personPhone forKey:@"phone"];
                        [record setObject:[NSNumber numberWithInt:recordID] forKey:@"ID"];
                        [filteredArray addObject:record];
                        
                    }
                    
                    
                }
            }
        }
    }
}
-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    
}
#pragma mark - 拨打电话
-(void)makePhoneCallWithPhoneNub:(NSString*)phoneNub withName:(NSString*)name
{
    NSString*tellNub = [Utils checkPhoneNubAndRemoveIllegalCharacters:phoneNub];
    if (tellNub.length!=11) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"号码有误请查询后再拨" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
#if USENEWVERSION
    [self buildPhoneWaitVCWithDic:@{@"user":KUserManager.mobile,@"called":tellNub}];
#else
    [self buildPhoneWaitVCWithDic:@{@"user":KUserManager.tel,@"called":tellNub}];
#endif
    
    [self saveCallNubMsg:phoneNub withName:name];
}

#pragma mark - 实例化等待界面
-(void)buildPhoneWaitVCWithDic:(NSDictionary*)dic
{
//    if (_phoneWaitVC==nil) {
//        _phoneWaitVC = [[CWSPhoneWaitController alloc]initWithNibName:@"CWSPhoneWaitController" bundle:nil];
//    }
//    _phoneWaitVC.phoneDic=dic;
//    [self presentViewController:_phoneWaitVC animated:YES completion:nil];
    CWSPhoneWaitController*waitVC = [[CWSPhoneWaitController alloc]initWithNibName:@"CWSPhoneWaitController" bundle:nil];
    waitVC.phoneDic = dic;
    [self presentViewController:waitVC animated:YES completion:nil];
}
#pragma mark - 保存联系人数据
-(void)saveCallNubMsg:(NSString*)phoneNub withName:(NSString*)name
{
    NSDictionary*dic=@{@"tel":phoneNub,@"name":name,@"time":[Utils getTime]};
    if ([LHPShaheObject checkPathIsOk:kCallRecrd]) {
        NSMutableArray*array=[[NSMutableArray alloc]initWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:kCallRecrd]];
        if (array.count) {
            [array insertObject:dic atIndex:0];
        }else{
            array=[NSMutableArray arrayWithObjects:dic, nil];
        }
        [LHPShaheObject saveMsgWithName:kCallRecrd andWithMsg:array];
    }else{
        [LHPShaheObject saveMsgWithName:kCallRecrd andWithMsg:[NSMutableArray arrayWithObjects:dic, nil]];
    }
}

@end
