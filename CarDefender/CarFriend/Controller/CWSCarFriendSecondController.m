//
//  CWSCarFriendSecondController.m
//  CarDefender
//
//  Created by 李散 on 15/5/12.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSCarFriendSecondController.h"
#import "CWSCarFriendDetailController.h"
#import "CarFriendTypeCell.h"
@interface CWSCarFriendSecondController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*_tableView;
    NSArray*_tableArray;
}
@end

@implementation CWSCarFriendSecondController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    self.title=@"车生活新动态";
    
    _tableArray=[NSArray array];
    [self showHudInView:self.view  hint:@"加载中..."];
    [ModelTool httpAppGainCicleInfoWithParameter:@{@"type":[self.listDic[@"type"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]} success:^(id object) {
        MyLog(@"%@",object);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                _tableArray=object[@"data"][@"list"];
                [self buildTableView];
            }else{
                [[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
            }
        });
    } faile:^(NSError *err) {
        [self hideHud];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [ModelTool stopAllOperation];
}
-(void)buildTableView
{
    self.view.backgroundColor=kCOLOR(242, 242, 242);
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kTO_TOP_DISTANCE, kSizeOfScreen.width, self.view.frame.size.height)];
    _tableView.backgroundColor=kCOLOR(242, 242, 242);
    _tableView.dataSource=self;
    _tableView.delegate=self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CarFriendTypeCell heightForCellWithContentForCellDict:_tableArray[indexPath.row]];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellID=@"carFriendCell";
    CarFriendTypeCell*cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[CarFriendTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.typeDic=_tableArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CWSCarFriendDetailController*detailVC=[[CWSCarFriendDetailController alloc]initWithNibName:@"CWSCarFriendDetailController" bundle:nil];
    detailVC.detailDic=_tableArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
