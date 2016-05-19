//
//  CWSIllegalQueryController.m
//  CarDefender
//
//  Created by 李散 on 15/6/30.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSIllegalQueryController.h"
#import "CWSQueryCell.h"
#import "CWSQueryHistoryController.h"
#import "CWSQueryResultController.h"
#import "CWSEditHelpController.h"
#import "TSLocateView.h"
@interface CWSIllegalQueryController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UITableView*_tableView;
    NSMutableArray*_dataArray;
    TSLocateView*_locateView;
}
@end

@implementation CWSIllegalQueryController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    [self buildUI];
    [self getData];
}
-(void)buildUI
{
    self.title = @"查违章";
    [self buildTableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"查询历史" style:UIBarButtonItemStyleDone target:self action:@selector(checkHistory)];
}
-(void)checkHistory
{
    CWSQueryHistoryController *queryVC = [[CWSQueryHistoryController alloc]initWithNibName:@"CWSQueryHistoryController" bundle:nil];
    [self.navigationController pushViewController:queryVC animated:YES];
}
-(void)buildTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kTO_TOP_DISTANCE, kSizeOfScreen.width, kSizeOfScreen.height-kDockHeight)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"CWSQueryCell" bundle:nil] forCellReuseIdentifier:@"queryCell"];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.tableHeaderView = self.topView;
}
-(void)getData
{
    _dataArray = [NSMutableArray arrayWithObjects:@{@"carImg":@"",@"carNub":@"渝A12345",@"time":@"一天前"},
                                                  @{@"carImg":@"",@"carNub":@"渝A12345",@"time":@"一天前"},
                                                  @{@"carImg":@"",@"carNub":@"渝A12345",@"time":@"一天前"},
                                                  @{@"carImg":@"",@"carNub":@"渝A12345",@"time":@"一天前"},
                                                  @{@"carImg":@"",@"carNub":@"渝A12345",@"time":@"一天前"},
                                                  @{@"carImg":@"",@"carNub":@"渝A12345",@"time":@"一天前"},
                                                  @{@"carImg":@"",@"carNub":@"渝A12345",@"time":@"一天前"},
                                                    nil];
    [_tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellID = @"queryCell";
    CWSQueryCell*cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CWSQueryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CWSQueryResultController*resultVC = [[CWSQueryResultController alloc]initWithNibName:@"CWSQueryResultController" bundle:nil];
    [self.navigationController pushViewController:resultVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    TSLocateView *locateView = (TSLocateView *)actionSheet;
    TSLocation *location = locateView.locate;
    self.shortText.text=location.city;
    if(buttonIndex == 0) {
        MyLog(@"Cancel");
    }else {
        MyLog(@"Select");
    }
}

- (IBAction)chooseShortPro:(id)sender {
    if (_locateView==nil) {
        _locateView = [[TSLocateView alloc] initWithTitle:@"定位城市" delegate:self];
    }
    [_locateView showInView:self.view];
}

- (IBAction)startQueryClick:(UIButton *)sender {
}

- (IBAction)unknowClick:(UIButton *)sender {
    CWSEditHelpController*helpVC = [[CWSEditHelpController alloc]init];
    [self.navigationController pushViewController:helpVC animated:YES];
}
@end
