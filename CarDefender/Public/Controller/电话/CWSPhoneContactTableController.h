//
//  CWSPhoneContactTableController.h
//  CarDefender
//
//  Created by 李散 on 15/5/5.
//  Copyright (c) 2015年 SKY. All rights reserved.
//  通讯录展现界面

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface CWSPhoneContactTableController : UITableViewController<UISearchDisplayDelegate,ABNewPersonViewControllerDelegate,ABPersonViewControllerDelegate>
{
    NSMutableDictionary *sectionDic;//通过字母排序后的联系人数据
    NSMutableDictionary *phoneDic;//联系人数据（姓名和号码）
    NSMutableDictionary *contactDic;//总的联系人列表
    NSMutableArray *filteredArray;//通过筛选出来的数据
    //NSMutableArray *contactNames;
}
-(void)loadContacts;
@end
