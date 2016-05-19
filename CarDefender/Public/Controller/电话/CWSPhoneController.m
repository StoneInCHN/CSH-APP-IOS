//
//  CWSPhoneController.m
//  宗隆
//
//  Created by sky on 15/3/10.
//  Copyright (c) 2015年 sky. All rights reserved.
//

#import "CWSPhoneController.h"
#import "ZLPhoneContactCell.h"
#import "LHPShaheObject.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "TongXunObject.h"
#import "pinyin.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "CWSFindCarLocDetailController.h"
#import "CWSPhoneContactTableController.h"
#import "CWSPhoneWaitController.h"
#import "CWSMyWealthController.h"
@interface CWSPhoneController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*_contactTableView;//联系人列表
    NSMutableString*_phoneNub;//拨打电话时时存储的手机号码
    BOOL _keyboardHiddenOrNo;//有输入号码时显示框弹出，为空时隐藏
    NSMutableArray*_tableArray;//数据源
    
    NSMutableArray*addressBookTemp;//联系人数据
    
    NSMutableArray *searchResults;//记录筛选项
    NSMutableArray*_chooseArray;//筛选出来的数据存储数组
    
    UITableView*_secondTableView;//检索出数据展示列表
    
    CWSPhoneWaitController*_phoneWaitVC;//拨打电话等待界面
    
    BOOL _makePhoneCallSuccess;//yes判断拨出了电话，no为没有播出过电话
}
@end
NSInteger action;
@implementation CWSPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    _makePhoneCallSuccess=NO;
    self.title=@"网络电话";
    [Utils changeBackBarButtonStyle:self];
    _phoneNub=[NSMutableString string];
    action=0;
    _keyboardHiddenOrNo=NO;
    
    [self buildTableView];
    
    [self getContact];//获取通讯录
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"话费余额" style:UIBarButtonItemStylePlain target:self action:@selector(stopCarAddress)];
}
//-(void)stopCarAddress
//{
//    CWSMyWealthController*wealthVC = [[CWSMyWealthController alloc]initWithNibName:@"CWSMyWealthController" bundle:nil];
//    [self.navigationController pushViewController:wealthVC animated:YES];
//}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _tableArray=[NSMutableArray arrayWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:kCallRecrd]];
    self.phoneLabel.text=@"";
    if (_tableArray.count) {
        if (_contactTableView==nil) {
            [self buildTableView];
        }else{
            [_contactTableView reloadData];
        }
    }
}

-(void)buildTableView{
    _contactTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-self.keyBoardView.frame.size.height-kDockHeight)];
    _contactTableView.dataSource=self;
    _contactTableView.delegate=self;
    [self.view addSubview:_contactTableView];
    [_contactTableView registerNib:[UINib nibWithNibName:@"ZLPhoneContactCell" bundle:nil] forCellReuseIdentifier:@"phoneCellKey"];
    _contactTableView.tableFooterView=[[UIView alloc]init];
}

- (IBAction)callNubEvent:(UIButton *)sender {
    if (_phoneNub.length) {
        
    }
    if (sender.tag==20) {
        MyLog(@"*");
        _phoneNub=(NSMutableString*)[_phoneNub stringByAppendingString:@"*"];
    }else if (sender.tag==21){
        MyLog(@"#");
        _phoneNub=(NSMutableString*)[_phoneNub stringByAppendingString:@"#"];
    }else{
        MyLog(@"%ld",(long)sender.tag-10);
        _phoneNub=(NSMutableString*)[_phoneNub stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)sender.tag-10]];
    }
    if (_phoneNub.length) {
        self.displayBoxView.hidden=NO;
        _phoneLabel.text=_phoneNub;
        
        CGRect tableFrame=_contactTableView.frame;
        tableFrame.size.height=kSizeOfScreen.height-self.keyBoardView.frame.size.height-kDockHeight-self.displayBoxView.frame.size.height;
        _contactTableView.frame=tableFrame;
    }
    if (_phoneNub.length>15) {
        _phoneNub = (NSMutableString*)[_phoneNub substringWithRange:NSMakeRange(0, 14)];
    }
    //根据输入号码检索出相类似的联系人
    [self checkPhoneNub];
}

#pragma mark - 根据输入号码检索出相类似的联系人
-(void)checkPhoneNub
{
    //检索的联系人数组
    searchResults = [[NSMutableArray alloc]init];
    
    if (_phoneNub.length>0&&![ChineseInclude isIncludeChineseInString:_phoneNub]) {//判断输入的不是中文字符
        for (int i=0; i<addressBookTemp.count; i++) {
            TongXunObject*tongxun=addressBookTemp[i];
            NSString*tellNub = [Utils checkPhoneNubAndRemoveIllegalCharacters:tongxun.tel];
            
            if (tellNub.length>=_phoneNub.length) {
                NSRange range=NSMakeRange(0, _phoneNub.length);
                NSString*string = [tellNub substringWithRange:range];
                if ([string isEqualToString:_phoneNub]) {
                    [searchResults addObject:tongxun];
                }
            }
        }
    }
    _chooseArray = [NSMutableArray arrayWithArray:searchResults];
    if (_chooseArray.count) {//检索处理来有数据
        _tableArray = [NSMutableArray arrayWithArray:_chooseArray];
        [_contactTableView reloadData];
    }else{//没有检索出数据来
        if (_phoneNub.length) {//有号码输入 就展示为空
            _tableArray = [NSMutableArray arrayWithArray:@[]];
            [_contactTableView reloadData];
        }else{//也没有输入就展示存储的数据
            if ([LHPShaheObject checkPathIsOk:kCallRecrd]) {//沙盒中有数据
                _tableArray = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:kCallRecrd]]];
            }else{//沙盒中没有数据
                _tableArray = [NSMutableArray arrayWithArray:@[]];
            }
            [_contactTableView reloadData];
        }
    }
}
-(BOOL)isValidateMobile:(NSString *)mobile
{
    NSString *phoneRegex = @"^(1[3458])\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
#pragma mark - 联系人、拨打电话、删除号码事件
- (IBAction)callAndDelAndContactEvent:(UIButton *)sender {
    if (sender.tag==30) {//联系人
        CWSPhoneContactTableController*contactController=[[CWSPhoneContactTableController alloc]initWithNibName:@"CWSPhoneContactTableController" bundle:nil];
        [self.navigationController pushViewController:contactController animated:YES];
    }else if (sender.tag==31){//拨打电话
        if ([Utils isValidateTellphone:_phoneNub] || [self isValidateMobile:_phoneNub]) {
            [self makePhoneCallWith:_phoneNub];
        }else{
//            NSString *stringMsg = [_phoneNub substringWithRange:NSMakeRange(0, 2)];
//            if ([stringMsg isEqualToString:@"17"]) {
//                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉，占时不提供对17号段的号码提供拨打服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
//                return;
//            }
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"号码有误请查询后再拨" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
        }
    }else if (sender.tag==32){//删除号码
        if (_phoneNub.length) {
            NSRange range=NSMakeRange(_phoneNub.length-1, 1);
            NSMutableString*stringNub=[NSMutableString stringWithString:_phoneNub];
            [stringNub deleteCharactersInRange:range];
            _phoneNub = [NSMutableString stringWithString:stringNub];
            self.phoneLabel.text=stringNub;
            if (!_phoneNub.length) {
                self.displayBoxView.hidden=YES;
                CGRect tableFrame=_contactTableView.frame;
                tableFrame.size.height=kSizeOfScreen.height-self.keyBoardView.frame.size.height-kDockHeight;
                _contactTableView.frame=tableFrame;
            }
        }else{
            self.displayBoxView.hidden=YES;
            CGRect tableFrame=_contactTableView.frame;
            tableFrame.size.height=kSizeOfScreen.height-self.keyBoardView.frame.size.height-kDockHeight;
            _contactTableView.frame=tableFrame;
        }
        [self checkPhoneNub];
    }
}

#pragma mark - 保存拨打的联系人
-(void)saveCallNubMsg:(NSString*)phoneNub withIndext:(int)intNub
{
    if (_chooseArray.count) {//有搜索的就在这个数组里面便利数据
        for (TongXunObject*tongxun in _chooseArray) {
            NSString*tellNub=[Utils checkPhoneNubAndRemoveIllegalCharacters:tongxun.tel];
            
            if ([tellNub isEqualToString:phoneNub]) {
                NSDictionary*dic=@{@"tel":tellNub,@"name":tongxun.name,@"time":[Utils getTime]};
                if ([LHPShaheObject checkPathIsOk:kCallRecrd]) {
                    NSMutableArray*array=[[NSMutableArray alloc]initWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:kCallRecrd]];
                    if (array.count) {
                        [array insertObject:dic atIndex:0];
                    }else{
                        array=[NSMutableArray arrayWithObjects:dic, nil];
                    }
                    _tableArray = [NSMutableArray arrayWithArray:array];
                    [LHPShaheObject saveMsgWithName:kCallRecrd andWithMsg:array];
                }else{
                    [LHPShaheObject saveMsgWithName:kCallRecrd andWithMsg:[NSMutableArray arrayWithObjects:dic, nil]];
                    _tableArray=[NSMutableArray arrayWithObjects:tongxun, nil];
                }
            }
        }
    }else{//没有的话就
        if (_tableArray.count) {
            if ([_tableArray[0] isKindOfClass:[NSDictionary class]]) {
                if (intNub>=0) {
                    NSDictionary*dic=@{@"tel":_tableArray[intNub][@"tel"],@"name":_tableArray[intNub][@"name"],@"time":[Utils getTime]};
                    NSMutableArray*array=[[NSMutableArray alloc]initWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:kCallRecrd]];
                    if (array.count) {
                        [array insertObject:dic atIndex:0];
                    }else{
                        array=[NSMutableArray arrayWithObjects:dic, nil];
                    }
                    _tableArray = [NSMutableArray arrayWithArray:array];
                    [LHPShaheObject saveMsgWithName:kCallRecrd andWithMsg:array];
                    return;
                }
            }else{
                if (_chooseArray.count) {
                    for (TongXunObject*tongxun in _chooseArray) {
                        NSString*tellNub =[Utils checkPhoneNubAndRemoveIllegalCharacters:tongxun.tel];
                        if ([tongxun.tel isEqualToString:phoneNub]) {
                            NSDictionary*dic=@{@"tel":tellNub,@"name":tongxun.name,@"time":[Utils getTime]};
                            if ([LHPShaheObject checkPathIsOk:kCallRecrd]) {
                                NSMutableArray*array=[[NSMutableArray alloc]initWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:kCallRecrd]];
                                if (array.count) {
                                    [array insertObject:dic atIndex:0];
                                }else{
                                    array=[NSMutableArray arrayWithObjects:dic, nil];
                                }
                                _tableArray = [NSMutableArray arrayWithArray:array];
                                [LHPShaheObject saveMsgWithName:kCallRecrd andWithMsg:array];
                            }else{
                                [LHPShaheObject saveMsgWithName:kCallRecrd andWithMsg:[NSMutableArray arrayWithObjects:dic, nil]];
                                _tableArray=[NSMutableArray arrayWithObjects:tongxun, nil];
                            }
                            break;
                        }
                    }
                }else{
                    NSDictionary*dic=@{@"tel":phoneNub,@"name":@"未知号码",@"time":[Utils getTime]};
                    if ([LHPShaheObject checkPathIsOk:kCallRecrd]) {
                        NSMutableArray*array=[NSMutableArray array];
                        array=[[NSMutableArray alloc]initWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:kCallRecrd]];
                        [array insertObject:dic atIndex:0];
                        [LHPShaheObject saveMsgWithName:kCallRecrd andWithMsg:array];
                        _tableArray = [NSMutableArray arrayWithArray:array];
                    }else{
                        [LHPShaheObject saveMsgWithName:kCallRecrd andWithMsg:[NSMutableArray arrayWithObjects:dic, nil]];
                        _tableArray=[NSMutableArray arrayWithObjects:dic, nil];
                    }
                }
            }
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_makePhoneCallSuccess) {
        _makePhoneCallSuccess=NO;
        _phoneNub=[NSMutableString stringWithString:@""];
        self.displayBoxView.hidden=YES;
        _chooseArray=[NSMutableArray arrayWithArray:@[]];
        _tableArray = [NSMutableArray arrayWithContentsOfFile:[LHPShaheObject readMsgFromeShaHeWithName:kCallRecrd]];
        CGRect tableFrame=_contactTableView.frame;
        tableFrame.size.height=kSizeOfScreen.height-self.keyBoardView.frame.size.height-kDockHeight;
        _contactTableView.frame=tableFrame;
    }
}
#pragma mark - 拨打电话
-(void)makePhoneCallWith:(NSString*)telepNub withIndext:(int)indextNub
{
    _makePhoneCallSuccess=YES;
    telepNub = [Utils checkPhoneNubAndRemoveIllegalCharacters:telepNub];
    if (telepNub.length!=11) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"号码有误请查询后再拨" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    [self saveCallNubMsg:telepNub withIndext:indextNub];
#if USENEWVERSION
    
#else
    [self buildPhoneWaitVCWithDic:@{@"user":KUserManager.tel,@"called":telepNub}];
#endif
    
}
#pragma mark - 拨打电话
-(void)makePhoneCallWith:(NSString*)telepNub
{
    _makePhoneCallSuccess=YES;
    telepNub = [Utils checkPhoneNubAndRemoveIllegalCharacters:telepNub];
    
    if (telepNub.length!=11) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"号码有误请查询后再拨" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    [self saveCallNubMsg:telepNub withIndext:-1];
#if USENEWVERSION
    
#else
    [self buildPhoneWaitVCWithDic:@{@"user":KUserManager.tel,@"called":telepNub}];
#endif
    
}
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


#pragma mark - tableview代理方法
//设定多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableArray.count;
}
//设定行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
//行点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_chooseArray.count) {
        TongXunObject*tongxun=_chooseArray[indexPath.row];
        [self makePhoneCallWith:tongxun.tel withIndext:(int)indexPath.row];
    }else{
        NSString*tellNub=[_tableArray[indexPath.row] objectForKey:@"tel"];
        [self makePhoneCallWith:tellNub withIndext:(int)indexPath.row];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//给行添加数据
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString*phoneCellKey=@"phoneCellKey";
    ZLPhoneContactCell*cell=[tableView dequeueReusableCellWithIdentifier:phoneCellKey];
    if (cell==nil) {
        cell=[[ZLPhoneContactCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:phoneCellKey];
    }
    if (_chooseArray.count) {
        MyLog(@"%@",_tableArray);
        TongXunObject*tongxun=_tableArray[indexPath.row];
        cell.name.text=tongxun.name;
        cell.phoneNub.text=tongxun.tel;
        cell.time.hidden=YES;
        cell.phoneOutOrIn.hidden=YES;
    }else{
        cell.time.hidden=NO;
        cell.phoneOutOrIn.hidden=NO;
        cell.name.text=[_tableArray[indexPath.row] objectForKey:@"name"];
        
        cell.phoneNub.text=[_tableArray[indexPath.row] objectForKey:@"tel"];
        NSArray*array=[_tableArray[indexPath.row] objectForKey:@"time"];
        cell.time.text=[NSString stringWithFormat:@"%@:%@",array[3],array[4]];
        
        cell.phoneOutOrIn.image=[UIImage imageNamed:@"call_callOut@2x"];
    }
    return cell;
}

-(NSString*)checkTeleNameWithTel:(NSString*)tel
{
    NSString*cellName;
    BOOL haveName=NO;
    if (addressBookTemp.count) {
        for (int i=0; i<addressBookTemp.count; i++) {
            TongXunObject*tongxun=addressBookTemp[i];
            NSString*tellNub = [Utils checkPhoneNubAndRemoveIllegalCharacters:tongxun.tel];
            if ([tellNub isEqualToString:tel]) {
                haveName=YES;
                cellName=tongxun.name;
            }
        }
    }
    if (!haveName) {
        cellName=@"未知";
    }
    return cellName;
}
#pragma mark - tableView删除方法、插入方法

//UITableViewDelegate协议中定义的方法。该方法的返回值决定单元格的编辑状态
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return action==0?UITableViewCellEditingStyleDelete:UITableViewCellEditingStyleInsert;
}
// UITableViewDelegate协议中定义的方法。
// 该方法的返回值作为删除指定表格行时确定按钮的文本
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
// UITableViewDataSource协议中定义的方法。该方法的返回值决定某行是否可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //返回NO——代表这行数据不能编辑
    if (_chooseArray.count) {
        return NO;
    }else{
        return YES;
    }
}
// UITableViewDataSource协议中定义的方法。移动完成时激发该方法
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSInteger sourceRowNo=[sourceIndexPath row];
    NSInteger destRowNo=[destinationIndexPath row];
    // 获取将要移动的数据
    id trgetObj=[_tableArray objectAtIndex:sourceRowNo];
    // 从底层数组中删除指定数据项
    [_tableArray removeObjectAtIndex:sourceRowNo];
    // 将移动的数据项插入到指定位置。
    [_tableArray insertObject:trgetObj atIndex:destRowNo];
}
// UITableViewDataSource协议中定义的方法。
// 编辑（包括删除或插入）完成时激发该方法
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果正在提交删除操作
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NSInteger rowNo = [indexPath row];
        // 从底层NSArray集合中删除指定数据项
        [_tableArray removeObjectAtIndex:rowNo];
        
        [LHPShaheObject saveMsgWithName:kCallRecrd andWithMsg:_tableArray];
        
        // 从UITable程序界面上删除指定表格行。
        //        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.row] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}

#pragma mark - 获取通讯录
-(void)getContact
{
    //    _sectionHeadsKeys = [[NSMutableArray alloc] init];
    
    addressBookTemp = [NSMutableArray array];
    //新建一个通讯录类
    ABAddressBookRef addressBooks = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        
        addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
        
        //获取通讯录权限
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);});
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++)
    {
        //新建一个addressBook model类
        TongXunObject *addressBook = [[TongXunObject alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        addressBook.name = nameString;
        addressBook.recordID = (int)ABRecordGetRecordID(person);;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        addressBook.tel = (__bridge NSString*)value;
                        break;
                    }
                    case 1: {// Email
                        addressBook.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        [addressBookTemp addObject:addressBook];
        
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
}
@end
