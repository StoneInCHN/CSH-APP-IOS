//
//  CWSIntegralController.m
//  CarDefender
//
//  Created by 周子涵 on 15/6/2.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSIntegralController.h"
#import "CWSExplainIntegralController.h"
#import "IntegralCell.h"
#import "MJRefresh.h"


@interface CWSIntegralController ()<UITableViewDataSource,UITableViewDelegate>
{
    int                 _temp;
    UITableView*        _tableView;
    NSMutableArray*     _dataArray;
    CWSNoDataView*      _noDataView;
}
@property (weak, nonatomic) IBOutlet UILabel *totalScoreLable;
@property (weak, nonatomic) IBOutlet UILabel *increaseLabel;
@property (weak, nonatomic) IBOutlet UILabel *mileScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *signScoreLabel;

@end

@implementation CWSIntegralController

-(void)getDataWithPage:(NSInteger)page{

    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    NSDictionary* lDic = @{@"uid":KUserManager.uid,
                           @"mobile":KUserManager.mobile,
                           @"pageNumber":@(_temp),
                           @"pageSize":@20,
                           };
    [ModelTool getRedDetaikWithParameter:lDic andSuccess:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
                NSLog(@"%@",object);
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [_dataArray addObjectsFromArray:object[@"data"][@"list"] ];
                if (_dataArray.count == 0) {
                    if (_noDataView == nil) {
                        _noDataView = [[CWSNoDataView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height)];
                    }
                    [self.view addSubview:_noDataView];
                }else{
                    if (_noDataView != nil) {
                        [_noDataView removeFromSuperview];
                    }
                }
                [self creatTableView];
                
            }else {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
            [_tableView reloadData];
            [self loadShareDataInPage];
        });
    } andFail:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    [Utils changeBackBarButtonStyle:self];
    _temp = 1;
    [self getDataWithPage:_temp];
    
    if (!KUserManager.type) {//隐藏
        self.queryBtn.hidden = YES;
        self.queryImageView.hidden = YES;
    }
}
-(void)creatTableView{
    [Utils setViewRiders:self.backTopBtn riders:4];
    [self.integralHeadView setFrame:CGRectMake(0, 0, kSizeOfScreen.width, 277)];
//    [self.view addSubview:self.integralHeadView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.integralHeadView;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:_tableView];
    [self.view insertSubview:_tableView atIndex:0];
//    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}

#pragma mark - 下拉刷新方法
-(void)headerRefreshing
{
    MyLog(@"下拉刷新");
    [_dataArray removeAllObjects];
    _temp = 1;
    [self getDataWithPage:_temp];
    
}

#pragma mark - 上拉加载
-(void)footerRefreshing{
//    NSDictionary* lDic = @{@"uid":KUserManager.uid,
//                           @"key":KUserManager.key,
//                           @"score":KUserManager.score.cid,
//                           @"page":[NSString stringWithFormat:@"%i",_temp]};
//    [ModelTool httpGetScoreWithParameter:lDic success:^(id object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            MyLog(@"%@",object);
//            [self hideHud];
//            NSDictionary* dic = object[@"data"];
//            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
//                [_dataArray addObjectsFromArray:dic[@"list"]];
//                [_tableView reloadData];
//                [self loadShareDataInPage];
//                _temp ++;
//
//            }
//        });
//    } faile:^(NSError *err) {
//        [self hideHud];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self loadShareDataInPage];
//        });
//    }];
    _temp ++;
    [self getDataWithPage:_temp];
}
#pragma mark - 更新数据源方法
-(void)loadShareDataInPage{
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"scoreCell";
    IntegralCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"IntegralCell" owner:self options:nil][0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSDictionary* dic = _dataArray[indexPath.row];
    cell.nameLabel.text = dic[@"type"];
    cell.dateLabel.text = dic[@"time"];
    if ([dic[@"rule"] isEqualToString:@"0"]) {
        cell.scoreLabel.text = [NSString stringWithFormat:@"+%@",dic[@"total"]];
        cell.scoreLabel.textColor = kCOLOR(57, 197, 30);
//        cell.scoreLabel.textColor = [UIColor greenColor];
    }else{
        cell.scoreLabel.text = [NSString stringWithFormat:@"-%@",dic[@"total"]];
        cell.scoreLabel.textColor = [UIColor redColor];
    }
    return cell;
}
#pragma mark - tableView代理协议
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}
#pragma mark - scrollView代理协议
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int temp = 277;
    if (scrollView.contentOffset.y >= temp) {
        self.backTopBtn.hidden = NO;
    }else{
        self.backTopBtn.hidden = YES;
    }
}
#pragma mark - 按钮点击时间
- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag == 1) {
        CWSExplainIntegralController* lController = [[CWSExplainIntegralController alloc] init];
        lController.title = @"积分说明";
        lController.type = @"jifen";
        lController.isHidden = !KUserManager.type;
        [self.navigationController pushViewController:lController animated:YES];
     }else{
         [UIView animateWithDuration:0.5 animations:^{
            _tableView.contentOffset = CGPointMake(0, 0);
         }];
    }
}
@end
