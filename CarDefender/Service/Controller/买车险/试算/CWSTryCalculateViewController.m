//
//  CWSTryCalculateViewController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/7.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSTryCalculateViewController.h"
#import "TryCalculateTableViewCell.h"

@interface CWSTryCalculateViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    int                 _temp;
    NSMutableArray*     _dataArray;
    int                 tag;//标记tableview偏移量
    
}

@property (weak, nonatomic) IBOutlet UILabel *businessTotalLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTop;
@property (weak, nonatomic) IBOutlet UILabel *footTotalMoneyLabel;

- (IBAction)rightAwayBuyButton:(UIButton *)sender;

@end

@implementation CWSTryCalculateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车险试算";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    _dataArray = [NSMutableArray array];
    
    _temp = 1;
    tag = 1;
//    [self getDataWithPage:_temp];
    [self initalizeUserInterface];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:@"moneyClick" object:nil];
}

- (void)notification:(NSNotification *)info
{
    NSInteger currentTotal = [self.businessTotalLabel.text integerValue];
    NSString *totalString = [[self.footTotalMoneyLabel.text substringFromIndex:1] mutableCopy];
    
    NSInteger total = [totalString integerValue];
    NSString *theTag = info.userInfo[@"tag"];
    NSString *cellMoneyString = info.userInfo[@"money"];
    //选中
    if ([theTag isEqualToString:@"1"]) {
        currentTotal  +=  [cellMoneyString integerValue];
        total += [cellMoneyString integerValue];
    }
    //未选中
    else{
        currentTotal  -=  [cellMoneyString integerValue];
        total -= [cellMoneyString integerValue];
    }
    
    self.businessTotalLabel.text = [NSString stringWithFormat:@"%ld",(long)currentTotal];
    self.footTotalMoneyLabel.text = [NSString stringWithFormat:@"￥%ld",(long)total];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"moneyClick" object:nil];
}

#pragma mark - 数据源
-(void)getDataWithPage:(int)page{
    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setValue:KUserManager.uid forKey:@"uid"];
//    [dic setValue:KUserManager.mobile forKey:@"mobile"];
//    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//    
//    [ModelTool getMyOrderWithParameter:dic andSuccess:^(id object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if ([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                NSLog(@"%@",object);
//                for (NSDictionary* lDic in object[@"data"]) {
//                    CWSHistoryOrder* oredr = [[CWSHistoryOrder alloc] initWithDic:lDic];
//                    [_dataArray addObject:oredr];
//                }
//                
//                if (_dataArray.count == 0) {
//                    if (_noDataView == nil) {
//                        [self creatNoDataView];
//                        self.navigationItem.rightBarButtonItem = nil;
//                    }
//                }
//                else {
//                    //1.创建界面
//                    [self initalizeUserInterface];
//                }
//                
//            }
//            else  {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
//            }
//            
//            [_tableView reloadData];
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


#pragma mark - 上拉加载
-(void)footerRefreshing{
    _temp ++;
    [self getDataWithPage:_temp];
    
}
#pragma mark - 下拉刷新方法
-(void)headerRefreshing
{
    MyLog(@"下拉刷新");
    [_dataArray removeAllObjects];
    _temp = 1;
    [self getDataWithPage:_temp];
    
}

#pragma mark - 更新数据源方法
-(void)loadShareDataInPage{
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
}
#pragma mark - 界面
- (void)initalizeUserInterface
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];

//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
//    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];

}

#pragma mark - 立即购买
- (IBAction)rightAwayBuyButton:(UIButton *)sender {
    
}



#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else {
        return 10;
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    return 60;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
   
    if (section == 0) {
        
         UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"TryCalculateFirstHeadView" owner:self options:nil] lastObject];
        return view;
    }
    else {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"TryCalculateHeadView" owner:self options:nil] lastObject];
        return view;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    }
    else {
        return 60;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"TryCalculateFootView" owner:self options:nil] lastObject];
        return view;
    }
    else {
        return nil;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UINib *nib = [UINib nibWithNibName:@"TryCalculateTableViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"tryCalculateTableViewCell"];
    TryCalculateTableViewCell *cell = [[TryCalculateTableViewCell alloc] init];
    cell = [tableView dequeueReusableCellWithIdentifier:@"tryCalculateTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [cell.dropDownButton addTarget:self action:@selector(dropDownButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
   
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


@end
