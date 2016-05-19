//
//  CWSCWSIllegalCheckDetailViewController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/9.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSCWSIllegalCheckDetailViewController.h"
#import "IllegalCheckDetailTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface CWSCWSIllegalCheckDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    CWSNoDataView*      _noDataView;
    int _page;
}
@end

@implementation CWSCWSIllegalCheckDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"违章查询";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    _dataArray = [NSMutableArray array];
    _page = 1;
    [self getDataWithPage:_page];
    [self initalizeUserInterface];
}

#pragma mark - 数据源
- (void)getData
{

}

#pragma mark - 界面
- (void)initalizeUserInterface
{
    [self.refreshButton addTarget:self action:@selector(refreshButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_dataArray addObject:@1];
    if (_dataArray.count == 0) {
        if (_noDataView == nil) {
            _noDataView = [[CWSNoDataView alloc] initWithFrame:self.footView.frame];
        }
        [self.view addSubview:_noDataView];
    }
    else {
        NSString*url=[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"baseUrl"],self.dic[@"brand"][@"brandIcon"]];
        NSURL*logoImgUrl=[NSURL URLWithString:url];
        [self.headCarImageView setImageWithURL:logoImgUrl placeholderImage:[UIImage imageNamed:@"logo"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
        
        self.headCarBrandLabel.text = self.dic[@"plate"];
        
        
        [_noDataView removeFromSuperview];
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.footView.W, self.footView.H) style:UITableViewStylePlain];
//        _tableView.dataSource = self;
//        _tableView.delegate = self;
//        _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
//        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
//        _tableView.tableFooterView = view;
//        [self.footView addSubview:_tableView];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
//        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    }
}

#pragma mark - 刷新按钮
- (void)refreshButtonClick:(UIButton *)sender
{
    [_dataArray removeAllObjects];
    _page= 1;
    [self getDataWithPage:_page];
}

-(void)getDataWithPage:(int)page{
    
//    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//    NSDictionary* lDic = @{@"uid":KUserManager.uid,
//                           @"mobile":KUserManager.mobile,
//                           @"pageNumber":@(_page),
//                           @"pageSize":@20,
//                           };
//    [ModelTool getRedDetaikWithParameter:lDic andSuccess:^(id object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if ([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
//                NSLog(@"%@",object);
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                _dataArray = object[@"data"][@"list"];;
//                [self initalizeUserInterface];
//                
//            }else {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
//            }
//            [_tableView reloadData];
//            [self loadShareDataInPage];
//        });
//    } andFail:^(NSError *err) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }];
}

#pragma mark - 下拉刷新方法
-(void)headerRefreshing
{
    MyLog(@"下拉刷新");
    [_dataArray removeAllObjects];
     _page= 1;
    [self getDataWithPage:_page];
    
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
    //            }
    //        });
    //    } faile:^(NSError *err) {
    //        [self hideHud];
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [self loadShareDataInPage];
    //        });
    //    }];
    MyLog(@"上拉加载");
    _page ++;
    [self getDataWithPage:_page];
}

#pragma mark - 更新数据源方法
-(void)loadShareDataInPage{
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return _dataArray.count;
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 128;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UINib *nib = [UINib nibWithNibName:@"IllegalCheckDetailTableViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"illegalCheckDetailTableViewCell"];
    IllegalCheckDetailTableViewCell *cell = [[IllegalCheckDetailTableViewCell alloc] init];
    cell = [tableView dequeueReusableCellWithIdentifier:@"illegalCheckDetailTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

@end
