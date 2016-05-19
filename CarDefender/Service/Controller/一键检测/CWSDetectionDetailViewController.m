//
//  CWSDetectionDetailViewController.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/17.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSDetectionDetailViewController.h"

#define CELL_HEIGHT 45.0f
@interface CWSDetectionDetailViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView* myTableView;
    
    NSMutableArray* dataArray;

}

@end

@implementation CWSDetectionDetailViewController

-(instancetype)init{
    if(self = [super init]){
        self.obdDataArray = @[].copy;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"检测项说明";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [Utils changeBackBarButtonStyle:self];
    

    
    [self initialData];
    [self createTableView];
}


#pragma mark -================================InitialData
-(void)initialData{
    if(!dataArray){
        dataArray = @[].mutableCopy;
    }
    
  //  [self loadData];
}

-(void)loadData{
    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setValue:KUserManager.uid forKey:@"uid"];
//    [dic setValue:KUserManager.mobile forKey:@"mobile"];
//    [dic setValue:KUserManager.userCID forKey:@"cid"];
//    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//    [ModelTool getCarCheckWithParameter:dic andSuccess:^(id object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if ([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
//                NSLog(@"%@",object);
//                NSLog(@"------------%@",object[@"data"][@"dtc"][@"name"]);
//                for (NSDictionary *dic in object[@"data"][@"obd"]) {
//                    NSLog(@"%@-----------%@",dic[@"name"],dic[@"value"]);
//                }
//                
//            }else {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
//            }
//            
//        });
//    } andFail:^(NSError *err) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }];
    
    [dataArray addObject:@{@"Item":@"总里程(km)",@"ItemValue":@"-"}];
    [dataArray addObject:@{@"Item":@"总耗油量(l)",@"ItemValue":@"-"}];
    [dataArray addObject:@{@"Item":@"车速(km/h)",@"ItemValue":@"0~160"}];
    [dataArray addObject:@{@"Item":@"发动机转速(rpm)",@"ItemValue":@"0~6000"}];
    [dataArray addObject:@{@"Item":@"进口气温度(°C)",@"ItemValue":@"-40-80"}];
    [dataArray addObject:@{@"Item":@"冷却液温度(°C)",@"ItemValue":@"-40-110"}];
    [dataArray addObject:@{@"Item":@"发动机运行时间(min)",@"ItemValue":@"0-120"}];
    [dataArray addObject:@{@"Item":@"距上次保养(km)",@"ItemValue":@"5000"}];
    [dataArray addObject:@{@"Item":@"据下次年检(天)",@"ItemValue":@"-"}];
    [dataArray addObject:@{@"Item":@"故障码",@"ItemValue":@"-"}];
    
}


-(void)setObdDataArray:(NSArray *)obdDataArray{
    _obdDataArray = obdDataArray;
    
    dataArray = [NSMutableArray arrayWithArray:obdDataArray];
    [myTableView reloadData];
}

#pragma mark -================================CreateUI
-(void)createTableView{
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-kDockHeight) style:UITableViewStylePlain];
    myTableView.backgroundColor = KGrayColor3;
    myTableView.rowHeight = CELL_HEIGHT;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.bounces = YES;
    myTableView.showsHorizontalScrollIndicator = NO;
    myTableView.showsVerticalScrollIndicator = NO;
    [self setExtraCellLineHidden:myTableView];
    [self.view addSubview:myTableView];
}




#pragma mark -================================TableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetectItemCell"];
    
    if(!cell){
    
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetectItemCell"];
    }
    
    
    NSDictionary* currentDataDict = [NSDictionary dictionaryWithDictionary:dataArray[indexPath.row]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",currentDataDict[@"name"],currentDataDict[@"unit"]];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    if([currentDataDict[@"fault"] boolValue]){
        cell.textLabel.textColor = KRedColor;
    }else{
        cell.textLabel.textColor = KBlackMainColor;
    }

    
    UILabel* valueLabel = nil;
    if([currentDataDict[@"name"] isEqualToString:@"obd时间"]){
        valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSizeOfScreen.width-150, 0, 150, 16)];
    }else{
        valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSizeOfScreen.width-70, 0, 70, 16)];
    }
    valueLabel.text = [NSString stringWithFormat:@"%@",[PublicUtils checkNSNullWithgetString:currentDataDict[@"value"]]];
    if([currentDataDict[@"fault"] boolValue]){
        valueLabel.textColor = KRedColor;
    }else{
        valueLabel.textColor = KBlackMainColor;
    }

    valueLabel.textAlignment = NSTextAlignmentCenter;
    valueLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.accessoryView = valueLabel;
    
    return cell;
}


#pragma mark -================================TableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CELL_HEIGHT;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, CELL_HEIGHT)];
    sectionHeaderView.backgroundColor = [UIColor whiteColor];
    
    UILabel* headerNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, kSizeOfScreen.width, 16)];
    headerNameLabel.textColor = KBlueColor;
    headerNameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    headerNameLabel.text = @"检测项";
    [sectionHeaderView addSubview:headerNameLabel];
    
    UILabel* delerationLabel = [[UILabel alloc]initWithFrame:CGRectMake(kSizeOfScreen.width-85, 15, 70, 16)];
    delerationLabel.textColor = KBlueColor;
    delerationLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    delerationLabel.text = @"正常范围";
    delerationLabel.textAlignment = NSTextAlignmentCenter;
    [sectionHeaderView addSubview:delerationLabel];
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, sectionHeaderView.frame.size.height-1, kSizeOfScreen.width, 1)];
    lineView.backgroundColor = KGrayColor2;
    [sectionHeaderView addSubview:lineView];
    
    return sectionHeaderView;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark -================================OtherCallBack

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


-(void)viewDidLayoutSubviews{
    
    if ([myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
