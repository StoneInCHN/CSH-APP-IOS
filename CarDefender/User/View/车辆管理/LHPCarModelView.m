//
//  LHPCarModelView.m
//  云车宝选车Demo
//
//  Created by pan on 14/12/19.
//  Copyright (c) 2014年 pan. All rights reserved.
//

#import "LHPCarModelView.h"
#import "LHPModelCarViewCell.h"

#define yWight 3
@implementation LHPCarModelView

- (void)viewWillDisappear:(BOOL)animated
{
    [ModelTool stopAllOperation];
}

-(void)setModelCarDic:(NSDictionary *)modelCarDic
{
    _dicMsg=modelCarDic;
    [self getdataWithDic:modelCarDic];
}
-(void)getdataWithDic:(NSDictionary*)dic
{
    [self buildJuhua];
    
/*#if USENEWVERSION
    [ModelTool getVehicleBrandWithParameter:@{@"grade":@"2",@"parent":dic[@"id"]} andSuccess:^(id object) {
        MyLog(@"二级车系信息：%@",object);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_juhuaView removeFromSuperview];
            if ([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
                _modelArray=object[@"data"];
                if (_modelTableView==nil) {
                    [self buildTabelView];
                }else{
                    [_modelTableView reloadData];
                }
            }
        });
        
    } andFail:^(NSError *err) {
        [_juhuaView removeFromSuperview];
    }];
    
#else
    [ModelTool httpAppGainBSMWithParameter:@{@"grade":@"series",@"parent":dic[@"id"]} success:^(id object) {
        MyLog(@"%@",object);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_juhuaView removeFromSuperview];
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                _modelArray=object[@"data"][@"list"];
                if (_modelTableView==nil) {
                    [self buildTabelView];
                }else{
                    [_modelTableView reloadData];
                }
            }
        });
        
    } faile:^(NSError *err) {
        [_juhuaView removeFromSuperview];
    }];
#endif*/
    
    [HttpHelper searchVehicleLineByBrandWithUserID:KUserInfo.desc token:KUserInfo.token brankId:dic[@"id"] success:^(AFHTTPRequestOperation *operation,id object){
        [_juhuaView removeFromSuperview];
        
        NSDictionary *dataDic = (NSDictionary *)object;
        NSLog(@"datadic===%@",dataDic);
        if ([dataDic[@"code"] isEqualToString:SERVICE_SUCCESS]) {
            _modelArray=dataDic[@"msg"];
            //NSLog(@"modelarray===%@",_modelArray);
            if (_modelTableView==nil) {
                [self buildTabelView];
            }else{
                [_modelTableView reloadData];
            }
        }else{
            
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"desc"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }

    
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
    
    
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==11) {
        if (buttonIndex==1) {
            [self getdataWithDic:_dicMsg];
        }
    }
}
-(void)buildJuhua
{
    if (_juhuaView==nil) {
        _juhuaView=[[YCBJuhuaVew alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _juhuaView.backgroundColor=[UIColor whiteColor];
    }
    [self addSubview:_juhuaView];
}
-(void)buildTabelView
{
    _modelTableView = [[UITableView alloc]initWithFrame:CGRectMake(yWight, 0, self.frame.size.width-yWight, self.frame.size.height) style:UITableViewStyleGrouped];
    _modelTableView.delegate=self;
    _modelTableView.dataSource=self;
    [_modelTableView registerNib:[UINib nibWithNibName:@"LHPModelCarViewCell" bundle:nil] forCellReuseIdentifier:@"UITableViewCell1"];
    [self addSubview:_modelTableView];
    
    UIView*vie=[[UIView alloc]initWithFrame:CGRectMake(0, 0, yWight, self.frame.size.height)];
    vie.backgroundColor=kMainColor;
    [self addSubview:vie];
    
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(0, self.frame.size.height/2-30, 20, 60)];
    [btn setBackgroundImage:[UIImage imageNamed:@"car_btn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:btn];
}
-(void)change:(UIButton*)sender
{
    NSLog(@"yichu");
    [self removeFromSuperview];
}
#pragma mark - 类表代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

#if USENEWVERSION
    NSDictionary *childDic = _modelArray[section];
    NSArray * chileArray = childDic[@"childLine"];
    return chileArray.count;
#else
    return  [[_modelArray[section] objectForKey:@"list"] count];
#endif
}

#if USENEWVERSION
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_modelArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;//section头部高度
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[_modelArray objectAtIndex:section] objectForKey:@"name"];//key值（每个姓）就是组名
}
#else
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_modelArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;//section头部高度
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[_modelArray objectAtIndex:section] objectForKey:@"name"];//key值（每个姓）就是组名
}
#endif

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    NSString * cellName = @"UITableViewCell1";
    LHPModelCarViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[LHPModelCarViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }

#if USENEWVERSION
    
    NSDictionary* dict = _modelArray[indexPath.section];
    NSArray* carArr = dict[@"childLine"];
    cell.modelDicMsg = [carArr objectAtIndex:indexPath.row];
    
#else
    NSDictionary*dic=[[_modelArray[indexPath.section] objectForKey:@"list"] objectAtIndex:indexPath.row];
    cell.modelDicMsg=dic;
#endif
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
#if USENEWVERSION
    
    NSDictionary* dict = _modelArray[indexPath.section];
    NSArray *childArr = dict[@"childLine"];
    NSDictionary *dataDic = childArr[indexPath.row];
    [self.delegate carModelViewCellSelect:dataDic];
    
#else
    NSDictionary*dic=[[_modelArray[indexPath.section] objectForKey:@"list"] objectAtIndex:indexPath.row];
    int parent = [dic[@"parent"] intValue];
    if (parent>0) {
        [self.delegate carModelViewCellSelect:dic];
    }else{
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有该车辆的详细数据。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
#endif
}
@end
