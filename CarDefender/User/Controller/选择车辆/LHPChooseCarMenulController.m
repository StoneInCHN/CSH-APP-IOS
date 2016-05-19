//
//  LHPChooseCarMenulController.m
//  云车宝选车Demo
//
//  Created by pan on 14/12/18.
//  Copyright (c) 2014年 pan. All rights reserved.
//

#import "LHPChooseCarMenulController.h"
#import "TableViewCell.h"
#import "UIImageView+WebCache.h"
#import "LHPCarModelView.h"
#import "LHPTCarStyleView.h"
#import "YCBJuhuaVew.h"

#import "LHPShaheObject.h"

@interface LHPChooseCarMenulController ()<UITableViewDataSource,UITableViewDelegate,LHPCarModelViewDelegate,LHPTCarStyleViewDelegate,UIAlertViewDelegate>
{
    NSArray*_arrayZiMu;
    NSMutableArray*_dicCarMsg;
    NSMutableDictionary*_allMsgDic;
    UITableView*_tableView;
    NSString*_styleViewTopString;
    LHPCarModelView*_modelView;
    LHPTCarStyleView*_styleView;
    NSMutableDictionary*_allDicMg;
    UIButton*_backBtn;
    YCBJuhuaVew*_juhuaView;
}
@end

@implementation LHPChooseCarMenulController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"车型选择";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    _dicCarMsg=[NSMutableArray array];
    _allMsgDic=[NSMutableDictionary dictionary];
    _allDicMg=[NSMutableDictionary dictionary];
    [self getData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [ModelTool stopAllOperation];
}

#pragma mark - 获取数据
-(void)getData{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];

#if USENEWVERSION
    [ModelTool getVehicleBrandWithParameter:@{@"grade":@"1",@"parent":@"0"} andSuccess:^(id object) {
        MyLog(@"%@",object);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]){
                for (NSDictionary* tempDict in object[@"data"]) {
                    [_allDicMg setObject:tempDict[@"list"] forKey:tempDict[@"type"]];
                }
                _arrayZiMu = [[NSArray arrayWithArray:[_allDicMg allKeys]] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
                [self buildTableView];
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        });
    } andFail:^(NSError *err) {
        MyLog(@"%@",err);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
#else
    [ModelTool httpAppGainBSMWithParameter:@{@"grade":@"brand",@"parent":@"0"} success:^(id object) {
        MyLog(@"%@",object);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                _dicCarMsg=object[@"data"][@"list"];
                NSMutableArray*array2=[NSMutableArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
                NSMutableArray*all=[NSMutableArray array];
                for (NSString*string in array2) {
                    BOOL zimuYN=NO;
                    for (int i=0; i<_dicCarMsg.count; i++) {
                        if ([string isEqualToString:_dicCarMsg[i][@"type"]]) {
                            zimuYN=YES;
                            [_allDicMg setObject:_dicCarMsg[i] forKey:string];
                            break;
                        }
                    }
                    if (!zimuYN) {
                        [all addObject:string];
                    }
                }
                for (NSString *string in all) {
                    [array2 removeObject:string];
                }
                NSLog(@"%@",array2);
                _arrayZiMu=[NSArray arrayWithArray:(NSArray*)array2];
                [self buildTableView];
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        });
        
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
#endif
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10) {
        if (buttonIndex==1) {
            [self getData];
        }
    }
}
#pragma mark - 创建列表
-(void)buildTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-kDockHeight) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"UITableViewCell"];
}
#pragma mark - 创建二级列表
-(void)buildModelViewWithDic:(NSDictionary*)dic
{
    if (_modelView==nil) {
        _modelView = [[LHPCarModelView alloc]initWithFrame:CGRectMake(kSizeOfScreen.width*0.25, 0, kSizeOfScreen.width*0.75, _tableView.frame.size.height)];
        _modelView.delegate=self;
        _modelView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_modelView];
    }else{
        [self.view addSubview:_modelView];
    }
    _modelView.modelCarDic=dic;
}
#pragma mark - 创建三级列表
-(void)buildStyleViewWithDic:(NSDictionary*)dic
{
    if (_styleView==nil) {
        _styleView = [[LHPTCarStyleView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, _tableView.frame.size.height)];
        _styleView.delegate=self;
        _styleView.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:_styleView];
    }else{
        [self.view addSubview:_styleView];
    }
    _styleView.topString=_styleViewTopString;
    _styleView.carModelDicMsg=dic;
    if (_backBtn==nil) {
        [self buildBackBtn];
    }else{
        [self.navigationController.view addSubview:_backBtn];
    }
}
-(void)buildBackBtn
{
    _backBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 100, 44)];
    [_backBtn addTarget:self action:@selector(navGobackEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_backBtn];
    NSLog(@"%@",_tableView);
}

-(void)navGobackEvent:(UIButton*)sender
{
    NSLog(@"%@",_tableView);
    [_styleView removeFromSuperview];
    [_backBtn removeFromSuperview];
}
#pragma mark - 类表代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

#if USENEWVERSION
    return [[_allDicMg valueForKey:_arrayZiMu[section]] count];
#else
    NSArray*array=_allDicMg[_arrayZiMu[section]][@"list"];
    return  [array count];
#endif
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_arrayZiMu count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;//section头部高度
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_arrayZiMu objectAtIndex:section];//key值（每个姓）就是组名
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    tableView.sectionIndexBackgroundColor=[UIColor clearColor];
    tableView.sectionIndexColor=KBlackMainColor;
    return _arrayZiMu;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    NSString * cellName = @"UITableViewCell";
    TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
#if USENEWVERSION
    
    NSDictionary* dict = [[_allDicMg valueForKey:_arrayZiMu[indexPath.section]] objectAtIndex:indexPath.row];
    cell.dicMsg = dict;
    
#else
    NSDictionary*dic=[_allDicMg[_arrayZiMu[indexPath.section]][@"list"] objectAtIndex:indexPath.row];
    cell.dicMsg=dic;
#endif

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
#if USENEWVERSION
    NSDictionary* dict = [[_allDicMg valueForKey:_arrayZiMu[indexPath.section]] objectAtIndex:indexPath.row];
    [_allMsgDic setObject:dict forKey:@"brandCar"];
    [self buildModelViewWithDic:dict];
    _styleViewTopString=[NSString stringWithFormat:@"%@   %@",_arrayZiMu[indexPath.section],dict[@"name"]];
#else
    NSDictionary*dic=[_allDicMg[_arrayZiMu[indexPath.section]][@"list"] objectAtIndex:indexPath.row];
    [_allMsgDic setObject:dic forKey:@"brandCar"];
    [self buildModelViewWithDic:dic];
    _styleViewTopString=[NSString stringWithFormat:@"%@   %@",_arrayZiMu[indexPath.section],dic[@"name"]];
#endif
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    MyLog(@"tableview 滑动了%@",_modelView);
    if (_modelView!=nil) {
        [_modelView removeFromSuperview];
        _modelView=nil;
    }
}
#pragma mark - 第二试图代理方法
-(void)carModelViewCellSelect:(NSDictionary *)dic
{
    [_allMsgDic setObject:dic forKey:@"modelCar"];
    [self buildStyleViewWithDic:dic];

}
-(void)carStyleViewCellSelectDic:(NSDictionary *)dic
{
    
    [_backBtn removeFromSuperview];
    [_allMsgDic setObject:dic forKey:@"styleCar"];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:self.notiKey object:_allMsgDic];
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
