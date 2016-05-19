//
//  CWSRepairController.m
//  CarDefender
//
//  Created by 周子涵 on 15/4/8.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSRepairController.h"
#import "CWSRepairDetailsController.h"
#import "RepairCell.h"
#import "CWSNoDataView.h"
@interface CWSRepairController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView* _tableView;
    NSMutableArray*     _dataArray;
    NSMutableDictionary*_bodyDic;
    CWSNoDataView*_noDataView;
}
@end

@implementation CWSRepairController
-(void)getData{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    [ModelTool httpAppGainGasWithParameter:_bodyDic success:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self performSelector:@selector(dateLate) withObject:nil afterDelay:0.5];
            [self loadShareDataInPage];
            MyLog(@"%@",object);
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                if ([_bodyDic[@"page"] isEqualToString:@"1"]) {
                    _dataArray = [NSMutableArray arrayWithArray:object[@"data"][@"data"][@"pointList"]];
                    if (_tableView!=nil) {
                        [_tableView reloadData];
                    }else{
                        if (_dataArray.count) {
                            [self creatTableView];
                        }else{
//                            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"选中的城市没有此项服务，点击确定以返回" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                            alert.tag=1001;
//                            [alert show];
                            if (_noDataView == nil) {
                                _noDataView = [[CWSNoDataView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height)];
                            }
                            [self.view addSubview:_noDataView];
                            [self.view insertSubview:_noDataView atIndex:self.view.subviews.count - 2];
                        }
                    }
                }else{
                    NSArray*array=object[@"data"][@"data"][@"pointList"];
                    for (int i=0; i<array.count; i++) {
                        [_dataArray insertObject:array[i] atIndex:_dataArray.count];
                    }
                    [_tableView reloadData];
                }
                
            }else{
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        });
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self loadShareDataInPage];
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1001) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    _bodyDic=[NSMutableDictionary dictionary];
    _dataArray=[NSMutableArray array];
    [_bodyDic setObject:[self.keyWords stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"keyWord"];
    [_bodyDic setObject:[self.cityString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"cityName"];
    [_bodyDic setObject:@"1" forKey:@"page"];
    [_bodyDic setObject:@"20" forKey:@"size"];
    [self getData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [ModelTool stopAllOperation];
}

-(void)creatTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTO_TOP_DISTANCE, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kCOLOR(242, 242, 242);
    [self.view addSubview:_tableView];
    [self creatUpdateView];
}
#pragma mark - 创建刷新视图
-(void)creatUpdateView
{
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
}
#pragma mark - 上拉加载方法
-(void)footerRefreshing{
    MyLog(@"上拉加载");
    [self getdataWithUpRefresh];
}
#pragma mark - 上啦加载数据
-(void)getdataWithUpRefresh
{
    int pageNub = [_bodyDic[@"page"] intValue];
    pageNub+=1;
    [_bodyDic setObject:[NSString stringWithFormat:@"%d",pageNub] forKey:@"page"];
    [self getData];
}
#pragma mark - 下拉刷新方法
-(void)headerRefreshing
{
    MyLog(@"下拉刷新");
    [self getdataWithDownRefresh];
}
#pragma mark - 下啦加载数据
-(void)getdataWithDownRefresh
{
    [_bodyDic setObject:@"1" forKey:@"page"];
    [self getData];
}
#pragma mark - 更新数据源方法
-(void)loadShareDataInPage
{
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
}


#pragma mark - tableView数据源协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"RepairCell";
    RepairCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"RepairCell" owner:self options:nil][0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSDictionary* dic = _dataArray[indexPath.row];
    cell.repairMsgDic=dic;
    return cell;
}
#pragma mark - tableView代理协议
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CWSRepairDetailsController* lController = [[CWSRepairDetailsController alloc] init];
    NSDictionary* dic = _dataArray[indexPath.row];
    NSArray*allKey=[dic allKeys];
    if ([allKey containsObject:@"additionalInformation"]) {//有详情
        lController.repairDic = dic[@"additionalInformation"];
    }else{//没有详情
        lController.repairDic=nil;
    }
    lController.alllMsgDic=dic;
    lController.title = @"详情";
    [self.navigationController pushViewController:lController animated:YES];
}
@end
