//
//  CWSSlelectBaoYangViewController.m
//  fghfghf
//
//  Created by DRiPhion on 16/6/17.
//  Copyright © 2016年 sujinjiu. All rights reserved.
//

#import "CWSSlelectBaoYangViewController.h"
#import "CWSServiceBYTableViewCell.h"

@interface CWSSlelectBaoYangViewController ()<UITableViewDelegate,UITableViewDataSource>{
    CGFloat       price; // 计算合集价格
    NSMutableArray *saveCellArr; //储存选择的数组
    BOOL status;  //判断列表是否选择
    NSMutableArray *saveDataArr;
    UILabel *moneyLabel;
    UITableView *mytableView;
}

@end

@implementation CWSSlelectBaoYangViewController
-(void)viewWillAppear:(BOOL)animated{
    [mytableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    NSDictionary * backDic = @{@"saveDataArr1":saveDataArr,@"saveCellArr1":saveCellArr};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTabelView" object:nil userInfo:backDic];
}
-(void)viewDidDisappear:(BOOL)animated{
    [saveDataArr removeAllObjects];
    [saveCellArr removeAllObjects];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择配件";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
   
    if (self.byOptionDic==nil) {
        saveCellArr = [NSMutableArray array];
        saveDataArr = [NSMutableArray array];
    }else{
        saveCellArr = self.byOptionDic[@"saveCellArr1"];
        saveDataArr = self.byOptionDic[@"saveDataArr1"];
        price = [self calculationPrice:saveDataArr];
    }
    [self ctreatUI];
    [self ctreatTabelView];
    status = YES;
}

#pragma mark create tableView
-(void)ctreatUI{
    UIView * baoYangHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kSizeOfScreen.width , 64*kSizeOfScreen.height/677)];
    baoYangHeaderView.backgroundColor = kMainColor;
    baoYangHeaderView.tag = 103;
    [self.view addSubview:baoYangHeaderView];
    
    UILabel *baoyangLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, (baoYangHeaderView.frame.size.height-30)/2, kSizeOfScreen.width, 30)];
    
    baoyangLabel.text = @"常规保养";
    baoyangLabel.textColor = [UIColor whiteColor];
    baoyangLabel.font = [UIFont boldSystemFontOfSize:18];
    [baoYangHeaderView addSubview:baoyangLabel];
    
    //确定button
    
    UIView *moneyAndSureView = [[UIView alloc]initWithFrame:CGRectMake(0, kSizeOfScreen.height-64-60*kSizeOfScreen.height/667+20, kSizeOfScreen.width, 60*kSizeOfScreen.height/667)];
    moneyAndSureView.backgroundColor = [UIColor whiteColor];
    moneyAndSureView.tag = 104;
    [self.view addSubview:moneyAndSureView];
    //￥
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, (moneyAndSureView.frame.size.height-20)/2, 200, 20)];
    //price  = 0;
    NSString *money = [NSString stringWithFormat:@"合计:￥%.2f元",price];
    moneyLabel.text = money;
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    [moneyAndSureView addSubview:moneyLabel];
    
    UIButton * yuyueBtn = [[UIButton alloc]initWithFrame:CGRectMake(kSizeOfScreen.width-90, 0, 90, moneyAndSureView.frame.size.height)];
    [yuyueBtn setTitle:@"确定" forState:UIControlStateNormal];
    [yuyueBtn addTarget:self action:@selector(makeSureService:) forControlEvents:UIControlEventTouchUpInside];
    yuyueBtn.backgroundColor = kMainColor;
    
    [moneyAndSureView addSubview:yuyueBtn];
    
}

-(void)ctreatTabelView{
    
    UIView *bangyangHeaderView = [self.view viewWithTag:103];
    UIView *moneyAndSureView   = [self.view viewWithTag:104];
    mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, bangyangHeaderView.frame.origin.y+bangyangHeaderView.frame.size.height+10, kSizeOfScreen.width, moneyAndSureView.frame.origin.y-(bangyangHeaderView.frame.origin.y+bangyangHeaderView.frame.size.height+10))];
    mytableView.dataSource = self;
    mytableView.delegate   =self;
    mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mytableView.rowHeight = 45;
    
    [self.view addSubview:mytableView];
    
}

#pragma mark 确定选择保养的选项
-(void)makeSureService:(UIButton*)sender{
    
   
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark 计算价格
-(CGFloat)calculationPrice:(NSArray *)optionArray{
    
    CGFloat total;

    for(NSDictionary *dic in optionArray){
        NSString *priceStr = dic[@"price"];
        CGFloat i = [priceStr floatValue];
        total+=i;
    }
    
    return total;
}
#pragma mark tabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = self.byDataArr[section];
    NSArray *detailArr = dic[@"itemParts"];
    return detailArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    CWSServiceBYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[CWSServiceBYTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary *detailDic = self.byDataArr[indexPath.section];
    NSArray * detailArr = detailDic[@"itemParts"];
    NSDictionary *dataDic = detailArr[indexPath.row];
    cell.byName.text = [NSString stringWithFormat:@"%@",dataDic[@"serviceItemPartName"]];
    cell.byName.textColor = kTextlightGrayColor;
    NSString *priceStr = [NSString stringWithFormat:@"%@",dataDic[@"price"]];
    
    cell.byPrice.text = [NSString stringWithFormat:@"￥%.2f元",[priceStr doubleValue]];
    cell.byPrice.textColor = kTextlightGrayColor;
    
    cell.kuangView.layer.borderWidth = 0;
    if (saveCellArr.count>0) {
       
        NSInteger count = saveCellArr.count;
        for (int i=0; i<count; i++) {
            NSDictionary *cellIndexPathDic = saveCellArr[i];
            NSNumber *se = cellIndexPathDic[@"section"];
            NSNumber *ro = cellIndexPathDic[@"row"];
            NSInteger intSe = [se integerValue];
            NSInteger intRo = [ro integerValue];
            
            if (intSe==indexPath.section&&intRo==indexPath.row) {
                cell.kuangView.layer.borderWidth = 1.5;
                cell.kuangView.layer.borderColor = kMainColor.CGColor;
                
            }
        }
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return self.byDataArr.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary *dataDetailDic = self.byDataArr[section];
    NSString *sectionTitle = [NSString stringWithFormat:@"%@",dataDetailDic[@"serviceItemName"]];
    return sectionTitle;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    

    return nil;
}

#pragma mark tabelViewDataSourceDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //取出选择数据
    NSDictionary *detailDic = self.byDataArr[indexPath.section];
    NSArray * detailArr = detailDic[@"itemParts"];
    NSDictionary *dataDic = detailArr[indexPath.row];
    NSString *selectPrice1 = [NSString stringWithFormat:@"%@",dataDic[@"price"]];
    CGFloat selectPrice = [selectPrice1 floatValue];
    //取出选择行列
    NSNumber *section = [NSNumber numberWithInteger:indexPath.section];
    NSNumber *row     = [NSNumber numberWithInteger:indexPath.row];
    
    if(saveCellArr.count>0){
   
        NSInteger count =saveCellArr.count;
        for (int i=0; i<count; i++) {
            NSDictionary * saveDic = saveCellArr[i];
            NSNumber *se = saveDic[@"section"];
            NSNumber *ro = saveDic[@"row"];
            NSInteger intSe = [se integerValue];
            NSInteger intRo = [ro integerValue];
            if (intSe==indexPath.section&&intRo==indexPath.row) {
                [saveCellArr removeObjectAtIndex:i];
                status = NO;
                price-=selectPrice;
                [saveDataArr removeObjectAtIndex:i];
                break;
            }
            
        }
        
        if (status) {
            NSDictionary * indexDic = @{@"section":section,@"row":row};
            [saveCellArr addObject:indexDic];
            price+=selectPrice;
            [saveDataArr addObject:dataDic];
        }
        
        
    }else{
        
        NSDictionary *dic = @{@"section":section,@"row":row};
        [saveCellArr addObject:dic];
        price+=selectPrice;
        [saveDataArr addObject:dataDic];
    }
    NSLog(@"save=%@",saveCellArr);
    NSString *money = [NSString stringWithFormat:@"合计:￥%.2f元",price];
    moneyLabel.text = money;
    status = YES;
    
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
