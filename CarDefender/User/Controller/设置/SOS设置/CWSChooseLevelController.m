//
//  CWSChooseLevelController.m
//  CarDefender
//
//  Created by 李散 on 15/7/31.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSChooseLevelController.h"
#import "ModelTool.h"
#import "CWSSOSSettingController.h"
#import "CWSChooseLevelCell.h"
@interface CWSChooseLevelController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*_tableView;
    NSArray*_levelArray;
}
@end

@implementation CWSChooseLevelController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    [self getData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [ModelTool stopAllOperation];
}

-(void)getData
{
    _levelArray = @[@"轻度",@"中度",@"重度"];
    [self buildUI];
}
-(void)buildUI
{
    self.view.backgroundColor = kCOLOR(245, 245, 245);
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.bounces = NO;
    UIView*viewHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 20)];
    viewHead.backgroundColor = kCOLOR(245, 245, 245);
    _tableView.tableHeaderView = viewHead;
    _tableView.tableFooterView = [[UIView alloc]init];
    [_tableView registerNib:[UINib nibWithNibName:@"CWSChooseLevelCell" bundle:nil] forCellReuseIdentifier:@"levelID"];
    _tableView.backgroundColor = kCOLOR(245, 245, 245);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _levelArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellID = @"levelID";
    CWSChooseLevelCell*cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CWSChooseLevelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.textColor = kCOLOR(102, 102, 102);
    cell.textLabel.text = _levelArray[indexPath.row];
    if (indexPath.row == self.levelInt) {
        cell.chooseImg.hidden = NO;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showHudInView:self.view hint:@"提交中..."];
    [ModelTool httpAppUpWarnWithParameter:@{@"uid":KUserManager.uid,@"key":KUserManager.key,@"type":@"4",@"status":[NSString stringWithFormat:@"%ld",(long)indexPath.row+1]} success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            MyLog(@"%@",object);
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                if ([[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2] isKindOfClass:[CWSSOSSettingController class]]) {
                    CWSSOSSettingController*sosVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
                    sosVC.typeBack = @"碰撞等级回来了";
                    sosVC.levelInt = (int)indexPath.row;
                    [self.navigationController popToViewController:sosVC animated:YES];
                }
            }
        });
    } faile:^(NSError *err) {
        [self hideHud];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
