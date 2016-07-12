//
//  CWSCarWashViewController.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/8.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSCarWashViewController.h"
#import "CWSTableViewButtonCellDelegate.h"

#import "NewCarWashTableViewCell.h"
#import "CWSCarWashDetailViewController.h"

#import "CWSPayViewController.h"
#import "CWSPayWithoutRedPackageViewController.h"
#import "UIImageView+WebCache.h"
#import "NewCarWashTableHeaderView.h"
#import "CWSCarWashDetileController.h"



@interface CWSCarWashViewController ()<UITableViewDataSource,UITableViewDelegate,CWSTableViewButtonCellDelegate>{

    UITableView* myTableView;
    
    NSMutableArray* _dataArray;
    int                 _page;   //当前页码
    int     _pageSize; //每页条数
    NSMutableArray*_cellDataArray;
    NSDictionary  *currentDic;
    UserInfo *userInfo;
}

@end

@implementation CWSCarWashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"到店洗车";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [Utils changeBackBarButtonStyle:self];
    userInfo = [UserInfo userDefault];
    [self initialData];
}

#pragma mark -InitialData
-(void)initialData{
    _page = 1;
    _pageSize = 5;
    _dataArray = [NSMutableArray array];
    _cellDataArray = [NSMutableArray array];
    [self loadData:1];
}
- (void)loadData:(int)page {
    if (page > 10) {
        _page = 1;
        page = 1;
    }
    [HttpHelper searchRenterListWithServiceCategoryId:@"2"
                                               userId:userInfo.desc
                                                token:userInfo.token
                                             latitude:userInfo.latitude
                                            longitude:userInfo.longitude
                                             pageSize:_pageSize
                                           pageNumber:page
                                              success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                                  NSLog(@"到店洗车 :%@",responseObjcet);
                                                  NSDictionary *dict = (NSDictionary *)responseObjcet;
                                                  NSString *code = dict[@"code"];
                                                  userInfo.token = dict[@"token"];
                                                  if ([code isEqualToString:SERVICE_SUCCESS]) {
                                                      NSArray *cars = dict[@"msg"];
                                                      NSInteger total = [dict[@"page"][@"total"] integerValue];
                                                      if (_dataArray.count < total) {
                                                          [_dataArray addObjectsFromArray:cars];
                                                      }
                                                      if (_dataArray.count > 0) {
                                                          [self createTableView];
                                                      }
                                                      [myTableView reloadData];

                                                      if (cars.count == 0) {
                                                          [MBProgressHUD showError:@"没有更多数据了哦" toView:self.view.window];
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

#pragma mark -CreateUI
-(void)createTableView{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-kDockHeight) style:UITableViewStyleGrouped];
    myTableView.backgroundColor = KGrayColor3;
    myTableView.showsHorizontalScrollIndicator = NO;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.rowHeight = 38;
    myTableView.bounces = YES;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
    myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    [self setExtraCellLineHidden:myTableView];
    [self.view addSubview:myTableView];
}
- (void)headerRefreshing {
    [self loadData:1];
    [myTableView.mj_header endRefreshing];
}
- (void)footerRefreshing {
    _page++;
    [self loadData:_page];
    [myTableView.mj_footer endRefreshing];
}
#pragma mark - 更新数据源方法
-(void)loadShareDataInPage{
    [myTableView.mj_footer endRefreshing];
}

#pragma mark -===========================================================TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    _cellDataArray = [_dataArray[section][@"carService"] mutableCopy];
    return [_cellDataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 77;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NewCarWashTableHeaderView *view = [[NewCarWashTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 77) Data:_dataArray[section]];
    
    
    view.delegate = self;
    return view;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if (_dataArray.count == 0) {
        return nil;
    }
    NewCarWashTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NewCarWashCell"];

    NSMutableDictionary *goodsDic = [NSMutableDictionary dictionaryWithDictionary:_dataArray[indexPath.section][@"carService"][indexPath.row]];
//    [goodsDic setValue:_dataArray[indexPath.section][@"id"] forKey:@"merchantsID"];
    [goodsDic setValue:_dataArray[indexPath.section][@"id"] forKey:@"store_id"];
    [goodsDic setValue:_dataArray[indexPath.section][@"tenantName"] forKey:@"tenantName"];
//    [goodsDic setObject:[NSString stringWithFormat:@"%@",_dataArray[indexPath.section][@"carService"][indexPath.row][@"service_id"]] forKey:@"service_id"];

    cell = [[NewCarWashTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewCarWashCell" Data:goodsDic];
    
    cell.delegate = self;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.projectNameLabel.text = [NSString stringWithFormat:@"%@",goodsDic[@"serviceName"]];
//    if ([goodsDic[@"is_discount_price"] integerValue] == 1) {
//        cell.discountPriceLabel.text = [NSString stringWithFormat:@"%@",goodsDic[@"discount_price"]];
//    }
//    else {
//        cell.discountPriceLabel.text = [NSString stringWithFormat:@"%@",goodsDic[@"price"]];
//    }
    cell.discountPriceLabel.text = [NSString stringWithFormat:@"%@",goodsDic[@"promotion_price"]];
    cell.originalPriceLabel.text = [NSString stringWithFormat:@"%@",goodsDic[@"price"]];
    [cell.payButton setTitle:@"支付" forState:UIControlStateNormal];
    return cell;
}


#pragma mark -===========================================================TableViewDelegate




#pragma mark -===========================================================OtherCallBack
/**个人汽车信息按钮回调*/
-(void)titleViewButtonClicked:(UIButton*)sender{
    
    MyLog(@"titleViewButtonClicked!");
    
}


-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor grayColor];
    [tableView setTableFooterView:view];
}


#pragma mark -===========================================================CellDelegate
-(void)selectTableViewButtonClicked:(UIButton*)sender Red:(NSInteger)red ID:(NSInteger)idNumber andDataDict:(NSDictionary *)thyDict{
    if([sender.titleLabel.text isEqualToString:@"支付"]){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:[NSString stringWithFormat:@"%@",thyDict[@"store_id"] ] forKey:@"store_id"];
        [dic setValue:KUserManager.uid forKey:@"uid"];
        [dic setValue:[NSString stringWithFormat:@"%@",thyDict[@"service_id"] ] forKey:@"goods_id"];
        [dic setValue:[NSString stringWithFormat:@"%@",thyDict[@"serviceName"]] forKey:@"goods_name"];
        [dic setValue:[NSString stringWithFormat:@"%@",thyDict[@"promotion_price"]] forKey:@"discount_price"];
        [dic setValue:[NSString stringWithFormat:@"%d",YES] forKey:@"is_discount_price"];
        [dic setValue:[NSString stringWithFormat:@"%@",thyDict[@"tenantName"]] forKey:@"store_name"];
        [dic setValue:@"洗车" forKey:@"categoryName"];
        //tag为0表示红包标志为0，表示不能红包支付
        if(red){
            CWSPayViewController* payVc = [CWSPayViewController new];
            payVc.isRedpackageUseable = YES;
            [payVc setDataDict:dic];
            [self.navigationController pushViewController:payVc animated:YES];
        }else{
//            CWSPayWithoutRedPackageViewController* payWithoutRedPackageVc = [CWSPayWithoutRedPackageViewController new];
//            [self.navigationController pushViewController:payWithoutRedPackageVc animated:YES];
            CWSPayViewController* payVc = [CWSPayViewController new];
            payVc.isRedpackageUseable = YES;
            [payVc setDataDict:dic];
            [self.navigationController pushViewController:payVc animated:YES];
        }
    }else if([sender.titleLabel.text isEqualToString:@"预约"]){
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
    }
    else{
        
        CWSCarWashDetailViewController* carWashDetailVc = [CWSCarWashDetailViewController new];
        carWashDetailVc.idNumber = idNumber;
        [self.navigationController pushViewController:carWashDetailVc animated:YES];
    }
}




@end
