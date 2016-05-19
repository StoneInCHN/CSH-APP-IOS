//
//  LHPTCarStyleView.m
//  云车宝选车Demo
//
//  Created by pan on 14/12/19.
//  Copyright (c) 2014年 pan. All rights reserved.
//

#import "LHPTCarStyleView.h"
#import "UIImageView+WebCache.h"
#import "DetailCarMsgCell.h"

@implementation LHPTCarStyleView

-(void)buildJuhua
{
    if (_juhuaView==nil) {
        _juhuaView = [[YCBJuhuaVew alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _juhuaView.backgroundColor=[UIColor whiteColor];
    }
    [self addSubview:_juhuaView];
}

- (void)dealloc
{
    [ModelTool stopAllOperation];
}

-(void)setCarModelDicMsg:(NSDictionary *)carModelDicMsg
{
    _dicMsg=carModelDicMsg;
    [self getdataWithDic:carModelDicMsg];
}
-(void)getdataWithDic:(NSDictionary*)dic
{
    [self buildJuhua];
    
#if USENEWVERSION
    [ModelTool getVehicleBrandWithParameter:@{@"grade":@"3",@"parent":dic[@"id"]} andSuccess:^(id object) {
        MyLog(@"三级汽车信息:%@",object);
        [_juhuaView removeFromSuperview];
        if([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]){
            _styleArray = object[@"data"];
            if (_styleTableView==nil) {
                [self buildTableViewWithDic:dic];
            }else{
                _topLabel.text=self.topString;
                _carName.text=dic[@"name"];
                [_styleTableView reloadData];
            }
        }
        
    } andFail:^(NSError *err) {
        [_juhuaView removeFromSuperview];
    }];
    
#else
    [ModelTool httpAppGainBSMWithParameter:@{@"grade":@"model",@"parent":dic[@"id"]} success:^(id object) {
        MyLog(@"%@",object);
        [_juhuaView removeFromSuperview];
        if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
            _styleArray=object[@"data"][@"list"];
            if (_styleTableView==nil) {
                [self buildTableViewWithDic:dic];
            }else{
                _topLabel.text=self.topString;
                _carName.text=dic[@"name"];
                NSString*url=[NSString stringWithFormat:@"http://115.28.161.11:8080/XAI/appDownLoad/downLoadPhoto?path=%@",dic[@"logo"]];
                NSURL*logoImgUrl=[NSURL URLWithString:url];
                [_carImg setImageWithURL:logoImgUrl placeholderImage:[UIImage imageNamed:@"normal_car_type"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
                [_styleTableView reloadData];
            }
            
        }
    } faile:^(NSError *err) {
        [_juhuaView removeFromSuperview];
    }];
#endif
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==12) {
        if (buttonIndex==1) {
            [self getdataWithDic:_dicMsg];
        }
    }
}
-(void)buildTableViewWithDic:(NSDictionary*)dic
{
    
    _styleTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
    _styleTableView.delegate=self;
    _styleTableView.dataSource=self;
    [_styleTableView registerNib:[UINib nibWithNibName:@"DetailCarMsgCell" bundle:nil] forCellReuseIdentifier:@"UITableViewCell2"];
    [self addSubview:_styleTableView];
    
    
    UIView*headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 65)];
    headView.backgroundColor=[UIColor whiteColor];
    UIView*viewFirst=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 25)];
    
    viewFirst.backgroundColor=[UIColor lightGrayColor];
    _topLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 1.5, 290, 22)];
    _topLabel.text=self.topString;
    _topLabel.textColor=KBlackMainColor;
    _topLabel.textAlignment = NSTextAlignmentLeft;
    [viewFirst addSubview:_topLabel];
    [headView addSubview:viewFirst];
    
    _carImg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 25, 60, 40)];
    NSString*url=[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"baseUrl"],dic[@"logo"]];
    NSURL*logoImgUrl=[NSURL URLWithString:url];
    [_carImg setImageWithURL:logoImgUrl placeholderImage:[UIImage imageNamed:@"normal_car_type"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
    [headView addSubview:_carImg];
    
    _carName=[[UILabel alloc]initWithFrame:CGRectMake(80, 25, kSizeOfScreen.width-90, 40)];
    _carName.text=dic[@"name"];
    _carName.textColor=KBlackMainColor;
    _carName.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:_carName];
    
    _styleTableView.tableHeaderView=headView;
}
#pragma mark - 类表代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
#if USENEWVERSION
    return _styleArray.count;
#else
    return  [_styleArray[section][@"list"] count];
#endif
}

#if USENEWVERSION

#else
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_styleArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;//section头部高度
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[_styleArray objectAtIndex:section] objectForKey:@"type"];//key值（每个姓）就是组名
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*myView=[[UIView alloc]init];
    //    myView.backgroundColor=[UIColor colorWithRed:yHeadTitleColor green:yHeadTitleColor blue:yHeadTitleColor alpha:1];
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 7, 180, 22)];
    titleLabel.textColor=KBlackMainColor;
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=[[_styleArray objectAtIndex:section] objectForKey:@"type"];
    [myView addSubview:titleLabel];
    
    UILabel*carModel=[[UILabel alloc]initWithFrame:CGRectMake(219, 7, 100, 22)];
    carModel.textColor=KBlackMainColor;
    carModel.text=@"变速箱";
    carModel.textAlignment=NSTextAlignmentLeft;
    
    [myView addSubview:carModel];
    
    return myView;
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
    NSString * cellName = @"UITableViewCell2";
    DetailCarMsgCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[DetailCarMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
#if USENEWVERSION
    NSDictionary* dict = _styleArray[indexPath.row];
    cell.styleDic = dict;
#else
    NSDictionary*dic=[[_styleArray[indexPath.section] objectForKey:@"list"] objectAtIndex:indexPath.row];
    cell.styleDic=dic;
#endif
        if (_selectPath==indexPath) {
            cell.imageview.hidden=NO;
        }else{
            cell.imageview.hidden=YES;
        }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCarMsgCell*cellOld;
    if (_selectPath!=nil) {
        cellOld=(DetailCarMsgCell*)[tableView cellForRowAtIndexPath:_selectPath];
        cellOld.imageview.hidden=YES;
    }
    _selectPath=indexPath;
    DetailCarMsgCell*cell=(DetailCarMsgCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.imageview.hidden=NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

#if USENEWVERSION
    NSDictionary* dic = _styleArray[indexPath.row];
#else
     NSDictionary*dic=[[_styleArray[indexPath.section] objectForKey:@"list"] objectAtIndex:indexPath.row];
#endif
    

    
    [self.delegate carStyleViewCellSelectDic:dic];
}

@end
