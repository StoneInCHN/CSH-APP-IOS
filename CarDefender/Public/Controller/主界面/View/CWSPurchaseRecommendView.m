//
//  CWSPurchaseRecommendView.m
//  carLife
//
//  Created by MichaelFlynn on 12/2/15.
//  Copyright © 2015 王泰莅. All rights reserved.
//

#import "CWSPurchaseRecommendView.h"
#import "CWSMainViewController.h"

#import "CWSPurchaseRecomCell.h"
#import "CWSPurchaseRecomHeaderView.h"

#import "CWSPayViewController.h"
#import "CWSCarWashDetailViewController.h"

#define HEIGHT_HEADER 77.0f
#define HEIGHT_ROWS 38.0f
@implementation CWSPurchaseRecommendView{
    NSMutableArray* dataArray;
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
    
        _myTableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.bounces = NO;
        _myTableView.scrollEnabled = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.rowHeight = HEIGHT_ROWS;
        [_myTableView registerNib:[UINib nibWithNibName:@"CWSPurchaseRecomCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CWSPurchaseCell"];
        [self addSubview:_myTableView];
    
    }
    
    
    [self initialData];
    
    return self;
}


#pragma mark -==========================InitialData
-(void)initialData{
    if(!dataArray){
        dataArray = @[].mutableCopy;
    }
}

-(void)setStoreDataArray:(NSArray *)storeDataArray{
    _storeDataArray = storeDataArray;
    dataArray = [NSMutableArray arrayWithArray:storeDataArray];
    NSLog(@"dataArray leng:%lu", (unsigned long)dataArray.count);
    NSInteger totalNumOfRow = 0;
    
    for (NSDictionary* dict in dataArray) {

        NSArray* tempArray = dict[@"carService"];
        totalNumOfRow += tempArray.count;

    }
    
    CGRect thyRect = self.frame;
    thyRect.size.height = HEIGHT_HEADER * dataArray.count + HEIGHT_ROWS * totalNumOfRow + 15 * totalNumOfRow;
    self.frame = thyRect;
    _myTableView.frame = CGRectMake(0, 0, kSizeOfScreen.width, thyRect.size.height);
    
    [_myTableView reloadData];
}

#pragma mark -==========================TableViewData

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray* eachRowArray = dataArray[section][@"carService"];

    return eachRowArray.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CWSPurchaseRecomCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CWSPurchaseCell"];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    
    if(dataArray.count){
        
        NSArray* eachRowDataArray = dataArray[indexPath.section][@"carService"];
        
        if(eachRowDataArray.count){
            
            NSMutableDictionary* currentDataDict = [NSMutableDictionary dictionaryWithDictionary:eachRowDataArray[indexPath.row]];
            [currentDataDict setObject:[NSString stringWithFormat:@"%@",dataArray[indexPath.section][@"id"]] forKey:@"store_id"];
            [currentDataDict setObject:[NSString stringWithFormat:@"%@",dataArray[indexPath.section][@"tenantName"]] forKey:@"tenantName"];
            [currentDataDict setObject:[NSString stringWithFormat:@"%@",eachRowDataArray[indexPath.row][@"service_id"]] forKey:@"service_id"];
            [cell setThyCommodityDict:currentDataDict];
        }
    }

    return cell;
}


#pragma mark -==========================TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return HEIGHT_HEADER;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CWSPurchaseRecomHeaderView* headerView = [[[NSBundle mainBundle]loadNibNamed:@"CWSPurchaseRecomHeaderView" owner:self options:nil] lastObject];
    [headerView setRecomHeaderDataDict:dataArray[section]];
    headerView.delegate = self;
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 15)];
    view.backgroundColor = kCOLOR(245, 245, 245);
    return view;
}

-(void)selectTableViewButtonClicked:(UIButton *)sender Red:(NSInteger)red ID:(NSInteger)idNumber andDataDict:(NSDictionary *)thyDict{
    MyLog(@"-----支付商品信息---%@",thyDict);
    
 
    
    if([sender.titleLabel.text isEqualToString:@"支付"]){
        if(red){
            //tag为0表示红包标志为0，表示不能红包支付
            CWSPayViewController* payVc = [CWSPayViewController new];
            payVc.isRedpackageUseable = YES;
            [payVc setDataDict:thyDict];
            [self.rootVc.navigationController pushViewController:payVc animated:YES];
            
        }else{
            CWSPayViewController* payVc = [CWSPayViewController new];
            payVc.isRedpackageUseable = YES;
            [payVc setDataDict:thyDict];
            [self.rootVc.navigationController pushViewController:payVc animated:YES];
        }
    }else{
        
        CWSCarWashDetailViewController* carWashDetailVc = [CWSCarWashDetailViewController new];
        carWashDetailVc.idNumber = idNumber;
        [self.rootVc.navigationController pushViewController:carWashDetailVc animated:YES];
    }
}


@end
