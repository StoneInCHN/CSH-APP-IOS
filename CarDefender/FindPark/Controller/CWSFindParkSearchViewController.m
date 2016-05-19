//
//  CWSFindParkSearchViewController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/12.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSFindParkSearchViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "FindParkSearchCell.h"

@interface CWSFindParkSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,BMKSuggestionSearchDelegate>
{
    NSMutableArray*             _dataArray;
    NSMutableArray*             _historyArray;
    UITableView*                _tableView;
    BMKSuggestionSearch*        _searcher;
    BMKSuggestionSearchOption*  _option;
    NSInteger                   tag;//判断是历史记录还是索引
}
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
- (IBAction)cancleButtonClick:(UIButton *)sender;


@end

@implementation CWSFindParkSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    tag = 1;
    [Utils changeBackBarButtonStyle:self];
    _dataArray = [NSMutableArray array];
    [self initalizeUserInterface];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [self.searchTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [ModelTool stopAllOperation];
}

#pragma mark - 界面
- (void)initalizeUserInterface
{
    
    //2.获取历史数据
    [self getHistoryArray];
    //3.设置百度搜索类
    _searcher =[[BMKSuggestionSearch alloc]init];
    _searcher.delegate = self;
    
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.searchView.endY+1, kSizeOfScreen.width, 1)];
    [self.view addSubview:lineView];
    
    //创建tableview
    [self creatTabelView];
    
}

#pragma mark - 获取历史数据
-(void)getHistoryArray{
    NSUserDefaults*user=[[NSUserDefaults alloc]init];
    _dataArray = [NSMutableArray arrayWithArray:[user arrayForKey:@"history"]];
    _historyArray = [NSMutableArray arrayWithArray:[user arrayForKey:@"history"]];
}

#pragma mark - 创建TabelView
-(void)creatTabelView{
    //1.创建TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 54, kSizeOfScreen.width, kSizeOfScreen.height - 38) style:UITableViewStylePlain];
    _tableView.backgroundColor = kCOLOR(245, 245, 245);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    //2.创建TabelView的头部View
//    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 35)];
//    headView.backgroundColor = kCOLOR(245, 245, 245);
//    UILabel* markLabel = [Utils labelWithFrame:CGRectMake(10, 10, kSizeOfScreen.width - 20, 13) withTitle:@"最近搜过" titleFontSize:kFontOfSize(13) textColor:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft];
//    [headView addSubview:markLabel];
//    _tableView.tableHeaderView = headView;
    //3.创建TabelView的底部View
    UIView* footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 45)];
    footView.backgroundColor = [UIColor whiteColor];
    UIButton* deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 45)];
    [deleteBtn setTitle:@" 清除历史数据" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = kFontOfSize(17);
    [deleteBtn setImage:[UIImage imageNamed:@"sousuo_icon"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(delegateHistory) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:deleteBtn];
    _tableView.tableFooterView = footView;
}

#pragma mark - tableview数据源协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"FindParkSearchCell";
    FindParkSearchCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FindParkSearchCell" owner:self options:nil][0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSDictionary* dic = _dataArray[indexPath.row];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",dic[@"city"],dic[@"district"]];
    cell.nameLabel.text = dic[@"key"];

    //索引
    if (tag == 2) {
        if (indexPath.row == 0) {
            cell.cellImageView.image = [UIImage imageNamed:@"jiuyuan_location"];
        }
        else {
            cell.cellImageView.image = [UIImage imageNamed:@"jiuyuan_shijian"];
        }
    }
    //历史记录
    else {
        cell.cellImageView.image = [UIImage imageNamed:@"jiuyuan_shijian"];
    }
    return cell;
}
#pragma mark - tableView代理协议
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchTextField resignFirstResponder];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.searchView.hidden = YES;
    [self.searchTextField resignFirstResponder];
    //    NSValue* value = _dataArray[indexPath.row][@"pt"];
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[_dataArray[indexPath.row][@"lat"] floatValue], [_dataArray[indexPath.row][@"lng"] floatValue]};
    [self.delegate destinationClickWithPt:pt City:[NSString stringWithFormat:@"%@%@%@",_dataArray[indexPath.row][@"city"],_dataArray[indexPath.row][@"district"],_dataArray[indexPath.row][@"key"]]];
    
    //    [_historyArray addObject:_dataArray[indexPath.row]];
    [_historyArray insertObject:_dataArray[indexPath.row] atIndex:0];
    NSUserDefaults*user=[[NSUserDefaults alloc]init];
    [user setObject:_historyArray forKey:@"history"];
    [NSUserDefaults resetStandardUserDefaults];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 地图搜索代理协议
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        [_dataArray removeAllObjects];
        
        NSDictionary* dataDic = @{@"key":@"当前位置",
                                  @"city":KManager.currentCity,
                                  @"district":[NSString stringWithFormat:@"%@%@%@",KManager.currentSubCity,KManager.currentStreetName,KManager.currentStreetNumber],
                                  @"lat":[NSString stringWithFormat:@"%f",KManager.currentPt.latitude],
                                  @"lng":[NSString stringWithFormat:@"%f",KManager.currentPt.longitude]};
        [_dataArray addObject:dataDic];
        
        for (int i = 0; i < result.keyList.count; i++) {
            NSValue* value = result.ptList[i];
            NSDictionary* dataDic = @{@"key":result.keyList[i],
                                      @"city":result.cityList[i],
                                      @"district":result.districtList[i],
                                      @"lat":[NSString stringWithFormat:@"%f",value.CGPointValue.x],
                                      @"lng":[NSString stringWithFormat:@"%f",value.CGPointValue.y]};
            [_dataArray addObject:dataDic];
            tag = 2;
            
        }
        
        
    }else {
        NSLog(@"抱歉，未找到结果");
        [WCAlertView showAlertWithTitle:@"提示" message:@"抱歉，未找到结果" customizationBlock:nil completionBlock:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    }
    [_tableView reloadData];
}
#pragma mark - textField代理协议
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    
    if (_option == nil) {
        _option = [[BMKSuggestionSearchOption alloc] init];
    }
    _option.cityname = KManager.currentCity;
    _option.keyword  = string;
    BOOL flag = [_searcher suggestionSearch:_option];
    if(flag)
    {
        NSLog(@"建议检索发送成功");
    }
    else
    {
        NSLog(@"建议检索发送失败");
    }
    return YES;
}

#pragma mark - 删除历史记录
-(void)delegateHistory{
    [_historyArray removeAllObjects];
    [_dataArray removeAllObjects];
    NSUserDefaults*user=[[NSUserDefaults alloc]init];
    [user setObject:_historyArray forKey:@"history"];
    [NSUserDefaults resetStandardUserDefaults];
    [_tableView reloadData];
}

#pragma mark - 取消按钮
- (IBAction)cancleButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
