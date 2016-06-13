//
//  CWSCarBeautyViewController.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/8.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSCarBeautyViewController.h"
#import "CWSCarBeautyDetailViewController.h"
#import "CWSCarWashDetileController.h"
#import "CWSCarWashDetailViewController.h"


#import "CarBeautyTableViewCell.h"
#import "CWSTableViewButtonCellDelegate.h"
#import "CWSCarManageController.h"
#import "NewCarWashTableHeaderView.h"
#import "NewCarWashTableViewCell.h"
#import "CWSPayViewController.h"
#import "ChoseDatePikerView.h"

@interface CWSCarBeautyViewController ()<UITableViewDataSource,UITableViewDelegate,CWSTableViewButtonCellDelegate,ChoseDatePikerViewDelegate>{

    UITableView* myTableView;
    
    NSMutableArray* _dataArray;
    int                 _page;   //当前页码
    int     _pageSize; //每页条数
    NSMutableArray*_cellDataArray;
    NSDictionary  *currentDic;
    CWSNoDataView *_noDataView;
    UserInfo *userInfo;
}

@end

@implementation CWSCarBeautyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"汽车美容";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    self.view.backgroundColor = kCOLOR(245, 245, 245);
    userInfo = [UserInfo userDefault];
    [self initialData];
    

}


#pragma mark -===========================================================InitialData
-(void)initialData{
    
    _page = 1;
    _pageSize = 5;
    _dataArray = [NSMutableArray array];
    _cellDataArray = [NSMutableArray array];
    [self getData:NO];

}

//获取租户列表
- (void)getData:(Boolean) isRefresh {
    [HttpHelper searchRenterListWithServiceCategoryId:@"5"
                                               userId:userInfo.desc
                                                token:userInfo.token
                                             latitude:@"30.55513"
                                            longitude:@"104.077245"
                                             pageSize:_pageSize
                                           pageNumber:_page
                                              success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                                  NSLog(@"美容 :%@",responseObjcet);
                                                  NSDictionary *dict = (NSDictionary *)responseObjcet;
                                                  NSString *code = dict[@"code"];
                                                  userInfo.token = dict[@"token"];
                                                  if ([code isEqualToString:SERVICE_SUCCESS]) {
                                                      if (isRefresh) {
                                                          [_dataArray addObject:dict[@"msg"]];
                                                          [myTableView.mj_header endRefreshing];
                                                          [myTableView.mj_footer endRefreshing];
                                                      }else{
                                                          NSMutableArray* rootArray = [dict[@"msg"] mutableCopy];
                                                          _dataArray = rootArray;
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

-(void)loadData{
    [self createNoDataView];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setValue:KUserManager.uid forKey:@"uid"];
//    [dic setValue:KUserManager.mobile forKey:@"mobile"];
//    //    [dic setValue:@"" forKey:@"device"];
//    if (KManager.currentPt.latitude >0 && KManager.currentPt.longitude>0) {
//        [dic setValue:[NSString stringWithFormat:@"%f",KManager.currentPt.latitude] forKey:@"lat"];
//        [dic setValue:[NSString stringWithFormat:@"%f",KManager.currentPt.longitude] forKey:@"lon"];
//    }
//    else {
//        [dic setValue:[NSString stringWithFormat:@"%f",KManager.mobileCurrentPt.latitude] forKey:@"lat"];
//        [dic setValue:[NSString stringWithFormat:@"%f",KManager.mobileCurrentPt.longitude] forKey:@"lon"];
//    }
//    [dic setValue:[NSString stringWithFormat:@"%d",_page] forKey:@"pageNumber"];
//    [dic setValue:[NSString stringWithFormat:@"%d",_pageSize] forKey:@"pageSize"];
//    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//    [ModelTool getBeautyWithParameter:dic andSuccess:^(id object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            MyLog(@"-------------美容信息------------%@",object);
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            if ([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
//                NSMutableArray* rootArray = [object[@"data"] mutableCopy];
//                [ModelTool getWalletInfoWithParameter:@{@"uid":KUserManager.uid,@"mobile":KUserManager.mobile} andSuccess:^(id object) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                        if([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]){
//                            _dataArray = rootArray;
//                            if (_dataArray.count == 0) {
//                                [self createNoDataView];
//                            }else {
//                                [self createTableView];
//                            }
//                            
//                            
//                        }
//                    });
//                } andFail:^(NSError *err) {
//                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                    [alert show];
//                }];
//            }
//            else {
//                UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
//            }
//        });
//    } andFail:^(NSError *err) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }];
    
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
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-kDockHeight) style:UITableViewStylePlain];
    myTableView.backgroundColor = KGrayColor3;
    myTableView.showsHorizontalScrollIndicator = NO;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.rowHeight = 38;
    myTableView.bounces = YES;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    myTableView.contentOffset = CGPointMake(0, 10);
    
    [self setExtraCellLineHidden:myTableView];
//    [myTableView registerNib:[UINib nibWithNibName:@"CarBeautyTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CarBeautyCell"];
    [self.view addSubview:myTableView];
    
    myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [_dataArray removeAllObjects];
        [self getData:NO];
    }];
    myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self getData:YES];
    }];
    
}

#pragma mark - 刷新加载
-(void)refreshData{
    
    NSDictionary* paramDict = @{@"uid":KUserManager.uid,@"mobile":KUserManager.mobile,@"lat":[NSString stringWithFormat:@"%f",KUserManager.currentPt.latitude],@"lon":[NSString stringWithFormat:@"%f",KUserManager.currentPt.longitude],@"pageNumber":[NSString stringWithFormat:@"%d",_page],@"pageSize":[NSString stringWithFormat:@"%d",_pageSize]};
    [ModelTool getBeautyWithParameter:paramDict andSuccess:^(id object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]){
                for (NSDictionary* dict in object[@"data"]) {
                    [_dataArray addObject:dict];
                }
                [myTableView.mj_header endRefreshing];
                [myTableView.mj_footer endRefreshing];
            }
        });
    } andFail:^(NSError *err) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}

#pragma mark -===========================================================TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    _cellDataArray = [_dataArray[section][@"carService"] mutableCopy];
//    currentDic = [[NSDictionary alloc] initWithDictionary:_dataArray[section]];
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
    
//    CarBeautyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CarBeautyCell"];
//    
//    cell.delegate = self;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
    
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
    cell.discountPriceLabel.text = [NSString stringWithFormat:@"%@",goodsDic[@"promotion_price"]];
    cell.originalPriceLabel.text = [NSString stringWithFormat:@"%@",goodsDic[@"price"]];
    return cell;
}


#pragma mark -===========================================================TableViewDelegate








#pragma mark -===========================================================OtherCallBack
/**个人汽车信息按钮回调*/
-(void)titleViewButtonClicked:(UIButton*)sender{
    
    NSLog(@"titleViewButtonClicked!");
    
}


-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1.00f];
    [tableView setTableFooterView:view];
}


#pragma mark -===========================================================CellDelegate
//-(void)selectTableViewButtonClicked:(UIButton *)sender{
//    
//    if([sender.titleLabel.text isEqualToString:@"支付"]){
//    
//        NSLog(@"点击支付！");
//        
//        
//    }else if([sender.titleLabel.text isEqualToString:@"预约"]){
//    
//        CWSCarWashDetileController* carWashDetailVc = [CWSCarWashDetileController new];
//        [self.navigationController pushViewController:carWashDetailVc animated:YES];
//        
//    }else{
//    
//        CWSCarBeautyDetailViewController* carBeautyDetailVc = [CWSCarBeautyDetailViewController new];
//        carBeautyDetailVc.title = @"美容详情";
//        [self.navigationController pushViewController:carBeautyDetailVc animated:YES];
//    }
//}
-(void)selectTableViewButtonClicked:(UIButton*)sender Red:(NSInteger)red ID:(NSInteger)idNumber andDataDict:(NSDictionary *)thyDict{
    NSLog(@"thydict=%@",thyDict);
    if([sender.titleLabel.text isEqualToString:@"支付"]){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:[NSString stringWithFormat:@"%ld",(long)thyDict[@"store_id"] ] forKey:@"store_id"];
        [dic setValue:KUserManager.uid forKey:@"uid"];
        [dic setValue:[NSString stringWithFormat:@"%ld",(long)thyDict[@"service_id"] ] forKey:@"goods_id"];
        [dic setValue:[NSString stringWithFormat:@"%@",thyDict[@"serviceName"]] forKey:@"goods_name"];
        [dic setValue:[NSString stringWithFormat:@"%@",thyDict[@"promotion_price"]] forKey:@"discount_price"];
        [dic setValue:[NSString stringWithFormat:@"%d",YES] forKey:@"is_discount_price"];
        [dic setValue:[NSString stringWithFormat:@"%@",thyDict[@"tenantName"]] forKey:@"store_name"];
        //tag为0表示红包标志为0，表示不能红包支付
        if(red){
            CWSPayViewController* payVc = [CWSPayViewController new];
            [payVc setDataDict:dic];
            payVc.isRedpackageUseable = YES;
            [self.navigationController pushViewController:payVc animated:YES];
        }else{
            
            CWSPayViewController* payVc = [CWSPayViewController new];
            [payVc setDataDict:dic];
            payVc.isRedpackageUseable = NO;
            [self.navigationController pushViewController:payVc animated:YES];
        }
    }else if([sender.titleLabel.text isEqualToString:@"预约"]){   //进入订单详情
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:[NSString stringWithFormat:@"%@",thyDict[@"store_id"] ] forKey:@"store_id"];
        [dic setValue:KUserManager.uid forKey:@"uid"];
        [dic setValue:[NSString stringWithFormat:@"%@",thyDict[@"id"]] forKey:@"goods_id"];
        //判断是否有优惠
        if([thyDict[@"is_discount_price"] integerValue] == 1){
            
            [dic setValue:thyDict[@"discount_price"] forKey:@"price"];
            
        }else {
            [dic setValue:thyDict[@"price"] forKey:@"price"];
        }
        
        //时间选择器
        myTableView.userInteractionEnabled = YES;
        ChoseDatePikerView *chooseDate = [[ChoseDatePikerView alloc]initWithFrame:CGRectMake(20, 70, self.view.frame.size.width-40, 280)];
        chooseDate.delegate = self;
        chooseDate.layer.cornerRadius = 5;
        chooseDate.goodDic = thyDict;
        
        
        [self.view addSubview:chooseDate];
     
        
        
    }else{
        CWSCarWashDetailViewController* carBeautyDetailVc = [CWSCarWashDetailViewController new];
        carBeautyDetailVc.title = @"商家详情";
        carBeautyDetailVc.idNumber = idNumber;
        [self.navigationController pushViewController:carBeautyDetailVc animated:YES];
    }
}
-(void)sureBtnCommitOrderButton:(UIButton*)button goodDic:(NSDictionary*)goodDic{
    if (goodDic[@"service_id"]&&goodDic[@"price"]) {
        NSDictionary *dic = @{@"userId":KUserInfo.desc,@"token":KUserInfo.token,@"serviceId":goodDic[@"service_id"],@"price":goodDic[@"price"]};
        [MBProgressHUD showMessag:@"正在预约" toView:self.view];
        [HttpHelper insertVehicleSubscribeServiceWithUserDic:dic success:^(AFHTTPRequestOperation *operation,id object){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSDictionary *dataDictionary = (NSDictionary *)object;
            NSLog(@"dataDictionary=%@",dataDictionary);
            
            if ([dataDictionary[@"code"] isEqualToString:SERVICE_SUCCESS]) {
                CWSCarWashDetileController* carWashDetailVc = [CWSCarWashDetileController new];
                
                carWashDetailVc.orderID = dataDictionary[@"desc"];
                //订单详情
                
                
                [self.navigationController pushViewController:carWashDetailVc animated:YES];
            }else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"desc"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
   
}
-(void)getGenerateOrder:(NSDictionary*)dic{
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
@end
