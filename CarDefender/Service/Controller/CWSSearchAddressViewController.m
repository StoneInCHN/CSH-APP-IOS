//
//  CWSSearchAddressViewController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/8.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSSearchAddressViewController.h"
#import "FindParkSearchCell.h"

@interface CWSSearchAddressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,BMKSuggestionSearchDelegate>
{
    NSMutableArray*             _dataArray;
    UITableView*                _tableView;
    BMKSuggestionSearch*        _searcher;
    BMKSuggestionSearchOption*  _option;
    
}
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
- (IBAction)cancleButton:(UIButton *)sender;

@end

@implementation CWSSearchAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
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
    
    
    //设置百度搜索类
    _searcher =[[BMKSuggestionSearch alloc]init];
    _searcher.delegate = self;
    
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.searchView.endY+1, kSizeOfScreen.width, 1)];
    [self.view addSubview:lineView];
    
    
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
//    if (_tableView.tableHeaderView == nil) {
//        cell.imageView.image = [UIImage imageNamed:@"zhaochewei_sousuo.png"];
//    }else{
//        cell.imageView.image = [UIImage imageNamed:@"zhaochewei_time"];
//    }
    if (indexPath.row == 0) {
        cell.cellImageView.image = [UIImage imageNamed:@"jiuyuan_location"];
    }
    else {
        cell.cellImageView.image = [UIImage imageNamed:@"jiuyuan_shijian"];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    
    return cell;
}
#pragma mark - tableView代理协议
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 30;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view = [[NSBundle mainBundle] loadNibNamed:@"" owner:self options:nil];
//    return view;
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchTextField resignFirstResponder];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.searchTextField resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectCityName" object:nil userInfo:_dataArray[indexPath.row]];
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
        }
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchView.endY, kSizeOfScreen.width, kSizeOfScreen.height - self.searchView.endY+20) style:UITableViewStylePlain];
        _tableView.backgroundColor = kCOLOR(245, 245, 245);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;;
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_tableView];
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


#pragma mark - 取消按钮
- (IBAction)cancleButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
