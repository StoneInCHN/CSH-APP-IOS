//
//  CWSSOSSettingController.m
//  CarDefender
//
//  Created by 李散 on 15/7/31.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSSOSSettingController.h"
#import "CWSAddContactController.h"
#import "CWSChooseLevelController.h"
#import "LHPShaheObject.h"
#import "ModelTool.h"
@interface CWSSOSSettingController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UISwitch*_swithView;
    UITableView*_tableView;
    UILabel*_alertLbel;
    UIView*_downView;
    UILabel*_downLabel;
    UIButton*_addBtn;
    UILabel*_noticeLabel;

    NSMutableArray*_tellArray;
    NSDictionary*_dicMsg;

    NSIndexPath *_selectPath;
}
@end

@implementation CWSSOSSettingController
//记录当前正在执行的操作，0代表删除，1代表插入
NSUInteger action;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _tellArray = [NSMutableArray array];
    [Utils changeBackBarButtonStyle:self];
    [self getDataWith:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([self.typeBack isEqualToString:@"碰撞等级回来了"]) {
        [self getDataWith:NO];
    }else if ([self.typeBack isEqualToString:@"添加联系人回来了"]){
        [self getDataWith:NO];
    }else if ([self.typeBack isEqualToString:@"编辑回来了"]){
        [self getDataWith:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [ModelTool stopAllOperation];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_tellArray.count==3 ||_tellArray.count == 0) {
        return 0;
    }
    return 10;
}
-(void)getDataWith:(BOOL)onOrNo
{
    [self showHudInView:self.view hint:@"加载中..."];
    [ModelTool httpAppGainWarnWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key} success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            MyLog(@"%@",object);
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                NSString*stringMsg = object[@"data"][@"status"];
                action = 0;
                _dicMsg = @{@"sos_switch":[NSString stringWithFormat:@"%@",[stringMsg substringWithRange:NSMakeRange(5, 1)]],@"sos_level":[NSString stringWithFormat:@"%@",[stringMsg substringWithRange:NSMakeRange(4, 1)]]};
                _tellArray = [NSMutableArray arrayWithArray:object[@"data"][@"list"]];
                if (onOrNo) {
                    [self buildUI];
                }else{
                    [self refreshMsg];
                }
            }
        });
    } faile:^(NSError *err) {
        [self hideHud];
    }];
}
-(void)refreshMsg
{
    _swithView.on = [_dicMsg[@"sos_switch"] boolValue];
    [_tableView reloadData];
    if ([_dicMsg[@"sos_level"] intValue] == 1) {
        _downLabel.text = @"轻度碰撞";
    }else if ([_dicMsg[@"sos_level"] intValue] == 2) {
        _downLabel.text = @"中度碰撞";
    }else if ([_dicMsg[@"sos_level"] intValue] == 3) {
        _downLabel.text = @"重度碰撞";
    }
    if (_tellArray.count<3) {
    }else{
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    [self changeFrame:44];
    self.typeBack = @"";

}
-(void)buildUI
{
    self.view.backgroundColor = kCOLOR(245, 245, 245);
    UIView*view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kSizeOfScreen.width, 50)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    UILabel *label1 = [Utils labelWithFrame:CGRectMake(15, 0, kSizeOfScreen.width*0.75, 45) withTitle:@"发生碰撞时通知TA" titleFontSize:kFontOfSize(16) textColor:kCOLOR(102, 102, 102) alignment:NSTextAlignmentLeft];
    [view1 addSubview:label1];
    _swithView = [[UISwitch alloc]initWithFrame:CGRectMake(kSizeOfScreen.width-60, 7, 51, 31)];
    [view1 addSubview:_swithView];
    [_swithView addTarget:self action:@selector(switchTouchChange:) forControlEvents:UIControlEventValueChanged];
    _swithView.on = [_dicMsg[@"sos_switch"] boolValue];

    _noticeLabel = [Utils labelWithFrame:CGRectMake(15, view1.frame.size.height+view1.frame.origin.y+12, kSizeOfScreen.width-30, 40) withTitle:@"打开“发生碰撞时通知TA”，让亲友的关心与你同行。" titleFontSize:kFontOfSize(16) textColor:kCOLOR(153, 153, 153) alignment:NSTextAlignmentLeft];
    [self.view addSubview:_noticeLabel];
    _noticeLabel.numberOfLines = 0;
    
    CGFloat heightFloat;
    if (_tellArray.count<3) {
        if (_tellArray.count == 0) {
            heightFloat = (_tellArray.count+1)*44;
        }else
            heightFloat = (_tellArray.count+1)*44+10;
    }else{
        heightFloat = _tellArray.count*44;
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, view1.frame.size.height+view1.frame.origin.y+20, kSizeOfScreen.width, heightFloat)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    if (_tellArray.count<3) {
        [self setAddBtn];
    }else{
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    
    _alertLbel = [Utils labelWithFrame:CGRectMake(15, _tableView.frame.size.height+_tableView.frame.origin.y+12, kSizeOfScreen.width-30, 20) withTitle:@"您可以设置最多3位应急联系人" titleFontSize:kFontOfSize(16) textColor:kCOLOR(153, 153, 153) alignment:NSTextAlignmentLeft];
    [self.view addSubview:_alertLbel];
    
    _downView = [[UIView alloc]initWithFrame:CGRectMake(0, _alertLbel.frame.origin.y+_alertLbel.frame.size.height+12, kSizeOfScreen.width, 50)];
    [self.view addSubview:_downView];
    _downView.backgroundColor = [UIColor whiteColor];
    
    NSString*levelString;
    if ([_dicMsg[@"sos_level"] intValue] == 1) {
        levelString = @"轻度碰撞";
    }else if ([_dicMsg[@"sos_level"] intValue] == 2) {
        levelString = @"中度碰撞";
    }else if ([_dicMsg[@"sos_level"] intValue] == 3) {
        levelString = @"重度碰撞";
    }
    UILabel *label2 = [Utils labelWithFrame:CGRectMake(15, 0, kSizeOfScreen.width*0.75, 50) withTitle:@"通知TA碰撞强度" titleFontSize:kFontOfSize(16) textColor:kCOLOR(102, 102, 102) alignment:NSTextAlignmentLeft];
    [_downView addSubview:label2];
    
    _downLabel = [Utils labelWithFrame:CGRectMake(kSizeOfScreen.width*0.75-25, 0, kSizeOfScreen.width*0.25, 50) withTitle:levelString titleFontSize:kFontOfSize(16) textColor:kCOLOR(153, 153, 153) alignment:NSTextAlignmentRight];
    [_downView addSubview:_downLabel];
    UIButton*levelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 50)];
    [levelBtn addTarget:self action:@selector(levelBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_downView addSubview:levelBtn];
    UIImageView*imgView = [[UIImageView alloc]initWithFrame:CGRectMake(_downLabel.frame.size.width+_downLabel.frame.origin.x+5, 18, 8, 14)];
    imgView.image = [UIImage imageNamed:@"infor_jiantou.png"];
    [_downView addSubview:imgView];
    
    if ([_dicMsg[@"sos_switch"] isEqualToString:@"0"]) {
        [self setHiddenOrAppear:YES];
    }else{
        _noticeLabel.hidden = YES;
    }
}
-(void)setHiddenOrAppear:(BOOL)horapp
{
    _tableView.hidden = horapp;
    _downView.hidden = horapp;
    _alertLbel.hidden = horapp;
    _noticeLabel.hidden = !horapp;
}
-(void)switchTouchChange:(UISwitch*)sender
{
    [self showHudInView:self.view hint:@"提交中..."];
    [ModelTool httpAppUpWarnWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key,@"type":@"5",@"status":[NSString stringWithFormat:@"%d",sender.on]} success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            MyLog(@"%@",object);
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                if (sender.on) {//打开
                    [self setHiddenOrAppear:NO];
                }else{//关闭
                    [self setHiddenOrAppear:YES];
                }
            }
        });
    } faile:^(NSError *err) {
        [self hideHud];
    }];
}
-(void)noticeAppear:(BOOL)appOrDis
{
    if (_noticeLabel == nil) {
        _noticeLabel = [Utils labelWithFrame:CGRectMake(15, _tableView.frame.size.height+_tableView.frame.origin.y+12, kSizeOfScreen.width-30, 20) withTitle:@"打开“发生碰撞时通知TA”，让亲友的关心与你同行。" titleFontSize:kFontOfSize(16) textColor:kCOLOR(153, 153, 153) alignment:NSTextAlignmentLeft];
        [self.view addSubview:_noticeLabel];
    }
}
-(void)levelBtnEvent:(UIButton*)sender
{
    int levelInt;
    if ([_downLabel.text isEqualToString:@"轻度碰撞"]) {
        levelInt = 0;
    }else if ([_downLabel.text isEqualToString:@"中度碰撞"]) {
        levelInt = 1;
    }else if ([_downLabel.text isEqualToString:@"重度碰撞"]) {
        levelInt = 2;
    }
    
    CWSChooseLevelController*levelVC = [[CWSChooseLevelController alloc]initWithNibName:@"CWSChooseLevelController" bundle:nil];
    levelVC.title = @"碰撞等级";
    levelVC.levelInt = levelInt;
    [self.navigationController pushViewController:levelVC animated:YES];
}
-(void)addEvent:(UIButton*)sender
{
    CWSAddContactController*addVC = [[CWSAddContactController alloc]initWithNibName:@"CWSAddContactController" bundle:nil];
    addVC.title = @"新增联系人";
    [self.navigationController pushViewController:addVC animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tellArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellID = @"sosID";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.textLabel.text = _tellArray[indexPath.row][@"name"];
    cell.detailTextLabel.text = _tellArray[indexPath.row][@"tel"];
    cell.textLabel.textColor = kCOLOR(51, 51, 51);
    cell.detailTextLabel.textColor = kCOLOR(102, 102, 102);
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CWSAddContactController*addVC = [[CWSAddContactController alloc]initWithNibName:@"CWSAddContactController" bundle:nil];
    addVC.title = @"编辑联系人";
    addVC.dicMsg = _tellArray[indexPath.row];
    [self.navigationController pushViewController:addVC animated:YES];
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
    _selectPath = indexPath;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self showHudInView:self.view hint:@"提交中..."];
        [ModelTool httpAppDelSosWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key,@"sid":_tellArray[_selectPath.row][@"id"]} success:^(id object) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
                if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                    if (_tellArray.count==3) {
                        [self setAddBtn];
                    }
                    [_tellArray removeObjectAtIndex:_selectPath.row];
                    [self changeFrame:-44];
                    [_tableView reloadData];
                }
            });
        } faile:^(NSError *err) {
            [self hideHud];
        }];
    }
}
-(void)setAddBtn
{
    _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 44)];
    [_addBtn setTitle:@" 添加新的联系人" forState:UIControlStateNormal];
    [_addBtn setImage:[UIImage imageNamed:@"set_tianjia_click.png"] forState:UIControlStateNormal];
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 1)];
    view.backgroundColor = kCOLOR(245, 245, 245);
    [_addBtn addSubview:view];
    _tableView.tableFooterView = _addBtn;
    [_addBtn setTitleColor:kTextBlackColor forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)changeFrame:(int)intMsg
{
    CGFloat heightFloat;
    if (_tellArray.count<3) {
        if (_tellArray.count == 0) {
            heightFloat = (_tellArray.count+1)*44;
        }else
            heightFloat = (_tellArray.count+1)*44+10;
    }else{
        heightFloat = _tellArray.count*44;
    }
    CGRect tableFrame = _tableView.frame;
    tableFrame.size.height = heightFloat;
    _tableView.frame = tableFrame;
    
    CGRect alertFrame = _alertLbel.frame;
    alertFrame.origin.y = _tableView.frame.origin.y+_tableView.frame.size.height+12;
    _alertLbel.frame = alertFrame;
    
    CGRect downFrame = _downView.frame;
    downFrame.origin.y = _alertLbel.frame.origin.y+_alertLbel.frame.size.height+12;
    _downView.frame = downFrame;
}
@end
