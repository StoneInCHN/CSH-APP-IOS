//
//  CWSCarMaintainViewController.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/5.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSCarMaintainViewController.h"
#import "CWSTableViewButtonCellDelegate.h"

#import "CarMaintainTableViewCell.h"
#import "CWSCarMaintainDetailViewController.h"
#import "CWSCarWashDetailViewController.h"

#import "CWSCarWashDetileController.h"
#import "NewCarWashTableHeaderView.h"
#import "CWSCarManageController.h"
#import "CWSPayViewController.h"

@interface CWSCarMaintainViewController ()<UITableViewDataSource,UITableViewDelegate,CWSTableViewButtonCellDelegate>{

    NSInteger                 _temp;
    UITableView* myTableView;
    
    NSMutableArray* dataArray;
    NSMutableArray*_cellDataArray;
    NSDictionary  *currentDic;
    UIView* titleView;
    CWSNoDataView *_noDataView;
    UserInfo *userInfo;
}

@end

@implementation CWSCarMaintainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"预约保养";
    self.view.backgroundColor = [UIColor whiteColor];
    userInfo = [UserInfo userDefault];
    [Utils changeBackBarButtonStyle:self];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _temp = 1;

/**
    titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 40)];
    titleView.backgroundColor = KBlueColor;
    UILabel* titleViewLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, kSizeOfScreen.width-20, 15)];
    titleViewLabel.font = [UIFont systemFontOfSize:14.0f];
//    titleViewLabel.text = @"我的车辆:现代 朗动 2015款 1.6L 自动领先型";
    titleViewLabel.text = [NSString stringWithFormat:@"我的车辆:%@   %@",KUserManager.userDefaultVehicle[@"brand"][@"brandName"],KUserManager.userDefaultVehicle[@"brand"][@"seriesName"]];
    titleViewLabel.textColor = [UIColor whiteColor];
    [titleView addSubview:titleViewLabel];

    UIImageView* titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kSizeOfScreen.width-20, 12, 10, 15)];
    titleImageView.image = [UIImage imageWithCGImage:[UIImage imageNamed:@"tabbar_jiantou"].CGImage scale:1 orientation:UIImageOrientationDown];
    [titleView addSubview:titleImageView];
    [self.view addSubview:titleView];
    UIButton* titleViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleViewButton.frame = titleView.frame;
    [titleViewButton addTarget:self action:@selector(titleViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:titleViewButton];
 */
    
    [self initialData];
    [self getData:NO];

}

//获取租户列表
- (void)getData:(Boolean) isRefresh {
    [HttpHelper searchRenterListWithServiceCategoryId:@"1"
                                               userId:userInfo.desc
                                                token:userInfo.token
                                             latitude:userInfo.latitude
                                            longitude:userInfo.longitude
                                             pageSize:5
                                           pageNumber:[[NSString stringWithFormat:@"%ld", (long)_temp] intValue]
                                              success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                                  NSLog(@"保养 :%@",responseObjcet);
                                                  NSDictionary *dict = (NSDictionary *)responseObjcet;
                                                  NSString *code = dict[@"code"];
                                                  userInfo.token = dict[@"token"];
                                                  if ([code isEqualToString:SERVICE_SUCCESS]) {
                                                      if (isRefresh) {
                                                          [dataArray addObject:dict[@"msg"]];
                                                          [myTableView.mj_header endRefreshing];
                                                          [myTableView.mj_footer endRefreshing];
                                                      }else{
                                                          NSMutableArray* rootArray = [dict[@"msg"] mutableCopy];
                                                          dataArray = rootArray;
                                                          [self createTableView];
                                                      }
                                                      
                                                  }else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                                  } else {
                                                      [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                                  }
                                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  [MBProgressHUD showError:@"请求失败，请重试" toView:self.view];
                                              }];
}

#pragma mark -===========================================================InitialData
-(void)getDataWithPage:(NSInteger)page
{
    [self createNoDataView];
//    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setValue:KUserManager.uid forKey:@"uid"];
//    [dic setValue:KUserManager.mobile forKey:@"mobile"];
//    [dic setValue:KUserManager.userDefaultVehicle[@"device"] forKey:@"device"];
//    if (KManager.currentPt.latitude >0 && KManager.currentPt.longitude>0) {
//        [dic setValue:[NSString stringWithFormat:@"%f",KManager.currentPt.latitude] forKey:@"lat"];
//        [dic setValue:[NSString stringWithFormat:@"%f",KManager.currentPt.longitude] forKey:@"lon"];
//    }
//    else {
//        [dic setValue:[NSString stringWithFormat:@"%f",KManager.mobileCurrentPt.latitude] forKey:@"lat"];
//        [dic setValue:[NSString stringWithFormat:@"%f",KManager.mobileCurrentPt.longitude] forKey:@"lon"];
//    }
//    [dic setValue:@(_temp) forKey:@"pageNumber"];
//    [dic setValue:@20 forKey:@"pageSize"];
//    [ModelTool getMaintenanceServiceListWithParameter:dic andSuccess:^(id object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if ([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
//                MyLog(@"----------预约保养信息---------%@",object);
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                [dataArray addObjectsFromArray:object[@"data"]] ;
//                if (dataArray.count == 0) {
//                    [self createNoDataView];
//                }else {
//                    [self createTableView];
//                }
//                
//                
//            }else {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
//            }
//            [myTableView reloadData];
//            [self loadShareDataInPage];
//        });
//        
//        
//    } andFail:^(NSError *err) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }];
}


-(void)initialData{

    dataArray = [NSMutableArray array];
    _cellDataArray = [NSMutableArray array];
}



#pragma mark -===========================================================CreateUI
- (void)createNoDataView
{
    _noDataView = [[CWSNoDataView alloc]initWithFrame:CGRectMake(0, 15, kSizeOfScreen.width, kSizeOfScreen.height-15)];
    _noDataView.noDataTitleLabel.text = @"亲，暂无相关数据";
    _noDataView.hidden = NO;
    [self.view addSubview:_noDataView];
}


-(void)createTableView{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), kSizeOfScreen.width, kSizeOfScreen.height-kSTATUS_BAR-titleView.frame.size.height-10) style:UITableViewStylePlain];
    myTableView.backgroundColor = KGrayColor3;
    myTableView.showsHorizontalScrollIndicator = NO;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.rowHeight = 75;
    myTableView.bounces = YES;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setExtraCellLineHidden:myTableView];
//    myTableView.contentOffset = CGPointMake(0, 10);
//    [myTableView registerNib:[UINib nibWithNibName:@"CarMaintainTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CarMaintainCell"];
    [self.view addSubview:myTableView];
    myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}

#pragma mark - 下拉刷新方法
-(void)headerRefreshing
{
    MyLog(@"下拉刷新");
    [dataArray removeAllObjects];
    _temp = 1;
    [self getData:NO];
    
}

#pragma mark - 上拉加载
-(void)footerRefreshing{
    

    MyLog(@"上拉加载");
    _temp ++;
    [self getData:YES];
}

#pragma mark - 更新数据源方法
-(void)loadShareDataInPage{
    [myTableView.mj_header endRefreshing];
    [myTableView.mj_footer endRefreshing];
}

#pragma mark -===========================================================TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    _cellDataArray = [dataArray[section][@"carService"] mutableCopy];
//    currentDic = [[NSDictionary alloc] initWithDictionary:dataArray[section]];
    return [_cellDataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 75;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NewCarWashTableHeaderView *view = [[NewCarWashTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 75) Data:dataArray[section]];
    
    view.delegate = self;
    return view;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CarMaintainTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CarMaintainCell"];
    
    NSMutableDictionary *goodsDic = [NSMutableDictionary dictionaryWithDictionary:dataArray[indexPath.section][@"carService"][indexPath.row]];
    [goodsDic setValue:currentDic[@"id"] forKey:@"store_id"];
    [goodsDic setValue:currentDic[@"tenantName"] forKey:@"tenantName"];
    
    cell = [[CarMaintainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CarMaintainCell" Data:goodsDic];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    cell.maintainTitleLabel.text = [NSString stringWithFormat:@"%@",goodsDic[@"serviceName"]];
    cell.maintainContentLabel.text = [NSString stringWithFormat:@"%@",goodsDic[@"serviceName"]];
//    if ([goodsDic[@"is_discount_price"] integerValue] == 1) {
//        cell.moneyLabel.text = [NSString stringWithFormat:@"￥%@",goodsDic[@"discount_price"]];
//    }
//    else {
//        cell.moneyLabel.text = [NSString stringWithFormat:@"￥%@",goodsDic[@"price"]];
//    }
    cell.maintainTitleLabel.hidden = YES;
    cell.moneyLabel.hidden = YES;
    
    return cell;
}




#pragma mark -===========================================================TableViewDelegate








#pragma mark -===========================================================OtherCallBack
/**个人汽车信息按钮回调*/
-(void)titleViewButtonClicked:(UIButton*)sender{
    
    NSLog(@"titleViewButtonClicked!");
    CWSCarManageController* lController = [[CWSCarManageController alloc] init];
    [self.navigationController pushViewController:lController animated:YES];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = KGrayColor;
    [tableView setTableFooterView:view];
}


#pragma mark -===========================================================CellDelegate

-(void)selectTableViewButtonClicked:(UIButton*)sender Red:(NSInteger)red ID:(NSInteger)idNumber andDataDict:(NSDictionary *)thyDict{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[NSString stringWithFormat:@"%@",thyDict[@"merchantsID"] ] forKey:@"store_id"];
    [dic setValue:KUserManager.uid forKey:@"uid"];
    [dic setValue:[NSString stringWithFormat:@"%@",thyDict[@"id"]] forKey:@"goods_id"];
    //判断是否有优惠
    if([thyDict[@"is_discount_price"] integerValue] == 1){
        
        [dic setValue:thyDict[@"discount_price"] forKey:@"price"];
        
    }else {
        [dic setValue:thyDict[@"price"] forKey:@"price"];
    }
    
    
    if([sender.titleLabel.text isEqualToString:@"预约"]){
        //生成订单
        [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
        [ModelTool getGenerateOrderWithParameter:dic andSuccess:^(id object) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
                    MyLog(@"-----------预约订单信息--------%@",object);
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    //预约界面  即订单详情界面
                    CWSCarWashDetileController* carWashDetailVc = [CWSCarWashDetileController new];
                    [carWashDetailVc setDataDict:object[@"data"]];
                    [self.navigationController pushViewController:carWashDetailVc animated:YES];
                    
                }
                else {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }
            });
        } andFail:^(NSError *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }];
        
        
    }else if([sender.titleLabel.text isEqualToString:@"保养详情"]){
        CWSCarMaintainDetailViewController* carMaintainDetailVc = [CWSCarMaintainDetailViewController new];
        
        [self.navigationController pushViewController:carMaintainDetailVc animated:YES];
    }else{
        //商家详情
        CWSCarWashDetailViewController* carWashDetailVc = [CWSCarWashDetailViewController new];
        carWashDetailVc.idNumber = idNumber;
        carWashDetailVc.title = @"商家详情";
        [self.navigationController pushViewController:carWashDetailVc animated:YES];
    }
}


@end
