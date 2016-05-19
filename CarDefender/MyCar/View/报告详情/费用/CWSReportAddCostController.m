//
//  CWSReportAddCostController.m
//  报告动画
//
//  Created by 李散 on 15/5/18.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSReportAddCostController.h"
#import "AddCurrentCell.h"

@interface CWSReportAddCostController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
{
    UITableView*_tableView;
    NSArray*_modelArray;
    NSIndexPath *_chooseIndexPath;
    UITapGestureRecognizer*_singleRecognizer;//点击手势
    NSMutableDictionary*_bodyDic;
}
@end

@implementation CWSReportAddCostController

- (void)viewDidLoad {
    [super viewDidLoad];
    _bodyDic=[NSMutableDictionary dictionary];
    [_bodyDic setObject:KUserManager.uid forKey:@"uid"];
    [_bodyDic setObject:KUserManager.key forKey:@"key"];
    if (self.menuDic.count) {
        [_bodyDic setObject:self.menuDic[@"value"] forKey:@"value"];
        [_bodyDic setObject:self.menuDic[@"type"] forKey:@"type"];
    }else{
        [_bodyDic setObject:self.currentCostDic[@"id"] forKey:@"id"];
        [_bodyDic setObject:KUserManager.car.cid forKey:@"cid"];
        [_bodyDic setObject:[self.currentCostDic[@"recordDate"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"time"];
        [_bodyDic setObject:self.reportRid forKey:@"rid"];
    }
    
    [self.costText addTarget:self action:@selector(costEditingChange:) forControlEvents:UIControlEventEditingChanged];
    
//    UIBarButtonItem*leftBtn=[[UIBarButtonItem alloc]initWithTitle:@"    返回" style:UIBarButtonItemStylePlain target:self action:@selector(backEvent)];
//    self.navigationItem.leftBarButtonItem=leftBtn;
    
    if (self.menuDic) {
        if ([self.menuDic[@"type"] isEqualToString:@"cost"]) {
            self.oilCost.userInteractionEnabled=NO;
            [self buildTableView];
            _tableView.tableHeaderView=self.oilBaseView;
            _tableView.tableFooterView=[[UIView alloc]init];
            self.oilCost.text=[NSString stringWithFormat:@"%@",self.menuDic[@"value"]];
        }else{
            [_bodyDic setObject:self.menuDic[@"id"] forKey:@"id"];
            
            UIBarButtonItem*rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveCarCostMsg)];
            self.navigationItem.rightBarButtonItem=rightBtn;
            _modelArray=[NSArray arrayWithObjects:
                                                    @{@"title":@"停车",@"img":@"feiyong_tingche@2x",@"type":@"park"},
                                                    @{@"title":@"洗车",@"img":@"feiyong_xiche@2x",@"type":@"clean"},
                                                    @{@"title":@"路桥",@"img":@"feiyong_luqiao@2x",@"type":@"road"},
                                                    @{@"title":@"保养",@"img":@"feiyong_baoyang@2x",@"type":@"maintain"},
                                                    @{@"title":@"保险",@"img":@"feiyong_baoxian@2x",@"type":@"insurance"},
                                                    @{@"title":@"罚款",@"img":@"feiyong_fakuan@2x",@"type":@"fine"}
                                                      ,nil];
            [self buildTableView];
            if ([self.menuDic[@"time"] length]) {
                self.timeLabel.text=self.menuDic[@"time"];
            }
        }
        self.costText.text=[NSString stringWithFormat:@"%@",self.menuDic[@"value"]];
        
    }else{
        UIBarButtonItem*rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(saveCarCostMsg)];
        self.navigationItem.rightBarButtonItem=rightBtn;
        _modelArray=[NSArray arrayWithObjects:
                     @{@"title":@"停车",@"img":@"feiyong_tingche@2x",@"type":@"park"},
                     @{@"title":@"洗车",@"img":@"feiyong_xiche@2x",@"type":@"clean"},
                     @{@"title":@"路桥",@"img":@"feiyong_luqiao@2x",@"type":@"road"},
                     @{@"title":@"保养",@"img":@"feiyong_baoyang@2x",@"type":@"maintain"},
                     @{@"title":@"保险",@"img":@"feiyong_baoxian@2x",@"type":@"insurance"},
                     @{@"title":@"罚款",@"img":@"feiyong_fakuan@2x",@"type":@"fine"}
                     ,nil];
        [self buildTableView];
        //获取当前时间
        NSDate *timeDate=[NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH点mm分"];//修改时区为东8区
        NSString *destDateString = [dateFormatter stringFromDate:timeDate];
        self.timeLabel.text=destDateString;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [ModelTool stopAllOperation];
}

-(void)costEditingChange:(UITextField*)sender
{
    if (sender.text.length>6) {
        sender.text=[sender.text substringWithRange:NSMakeRange(0, 6)];
    }
}
-(void)buildTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]applicationFrame].size.width, [[UIScreen mainScreen]applicationFrame].size.height)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"AddCurrentCell" bundle:nil] forCellReuseIdentifier:@"addcurrentexpence"];
    _tableView.backgroundColor=kCOLOR(242, 242, 242);
    _tableView.tableHeaderView=self.headView;
    if (self.menuDic) {
        if ([self.menuDic[@"type"] isEqualToString:@"cost"]) {
        }else{
            self.footView.frame=CGRectMake(0, 0, self.footView.frame.size.width, self.footView.frame.size.height);
            _tableView.tableFooterView=self.footView;
        }
    }else{
        _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];
    }
    [self.view addSubview:_tableView];
    MyLog(@"%@",_tableView);
}
//-(void)backEvent
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
-(void)saveCarCostMsg
{
    if (!self.costText.text.length) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入费用金额" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
        return;
    }
    if (![Utils isNumText:self.costText.text]) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"输入费用金额包含非法字符，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
        return;
    }
    if (_chooseIndexPath==nil) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择费用类型" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
        return;
    }
    if ([self.costText.text floatValue]>10000000) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"输入费用必须小于1千万，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
        return;
    }
    
    [_bodyDic setObject:self.costText.text forKey:@"value"];
    [_bodyDic setObject:[self.timeLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"date"];
    [_bodyDic setObject:@"" forKey:@"latlng"];
    [_bodyDic setObject:@"" forKey:@"addr"];
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    if (self.menuDic.count) {
        [ModelTool httpAppUpReportFeeWithParameter:_bodyDic success:^(id object) {
            MyLog(@"%@",object);
            dispatch_async(dispatch_get_main_queue(), ^{
               [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReoirtCostBack" object:nil];
                }else{
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                }
            });
        } faile:^(NSError *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
        return;
    }
    
    [ModelTool httpAppAddReportFeeWithParameter:_bodyDic success:^(id object) {
        MyLog(@"%@",object);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ReoirtCostBack" object:nil];
            }else{
                [[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
        });
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        NSArray*array=@[@[@"feiyong_tingche@2x",@"feiyong_xiche@2x"],@[@"feiyong_luqiao@2x",@"feiyong_baoyang@2x",@"feiyong_baoxian@2x"],@[@"feiyong_fakuan@2x"]];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"ReoirtCostBack" object:@[[NSString stringWithFormat:@"￥%@",self.costText.text],_modelArray[_chooseIndexPath.section][_chooseIndexPath.row],array[_chooseIndexPath.section][_chooseIndexPath.row],self.timeLabel.text]];
//    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_modelArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellID=@"addcurrentexpence";
    AddCurrentCell*cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[AddCurrentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.text=_modelArray[indexPath.row][@"title"];
    cell.textLabel.textColor=[UIColor lightGrayColor];
    cell.contentView.backgroundColor=[UIColor whiteColor];
    if (self.menuDic) {
        if ([_modelArray[indexPath.row][@"type"] isEqualToString:self.menuDic[@"type"]]) {
            cell.chooseImg.hidden=NO;
            _chooseIndexPath = indexPath;
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.costText isFirstResponder]) {
        [self.costText resignFirstResponder];
    }

   // [tableView deselectRowAtIndexPath:indexPath animated:YES];

//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    if (_chooseIndexPath==nil) {
        _chooseIndexPath=indexPath;
    }else{
        AddCurrentCell*cell=(AddCurrentCell*)[tableView cellForRowAtIndexPath:_chooseIndexPath];
        cell.chooseImg.hidden=YES;
        _chooseIndexPath=indexPath;
    }
    [_bodyDic setObject:_modelArray[indexPath.row][@"type"] forKey:@"type"];
    AddCurrentCell*cell=(AddCurrentCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.chooseImg.hidden=NO;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.costText resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)chooseTimeClick:(UIButton *)sender {
    [self buildChooseTimeView];
    if ([self.costText isFirstResponder]) {
        [self.costText resignFirstResponder];
    }
}
-(void)buildChooseTimeView
{
    self.chooseTimeView.frame=CGRectMake(0, 0, _tableView.frame.size.width, _tableView.frame.size.height);
    [self.view addSubview:self.chooseTimeView];
    _singleRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTimeViewTouchDown:)];
    //点击的次数
    _singleRecognizer.numberOfTapsRequired = 1; //单击
    [self.chooseTimeView addGestureRecognizer:_singleRecognizer];
    
}
-(void)chooseTimeViewTouchDown:(UITapGestureRecognizer*)sender
{
    [self.chooseTimeView removeFromSuperview];
}
- (IBAction)cancelClick:(UIButton *)sender {
    [self.chooseTimeView removeFromSuperview];
}
- (IBAction)sureClick:(UIButton *)sender {
    NSDate *timeDate=[self.timePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSArray*arrayDate=[Utils getTime];
    NSString *nowYMD=[NSString stringWithFormat:@"%@-%@-%@",arrayDate[0],arrayDate[1],arrayDate[2]];
    if ([nowYMD isEqualToString:self.reportTime]) {
        NSTimeInterval timeNow=[[NSDate date] timeIntervalSince1970];
        NSTimeInterval timeChoose=[timeDate timeIntervalSince1970];
        if (timeChoose>timeNow) {
            [self.timePicker setDate:[NSDate date] animated:YES];
            return;
        }else{
            [dateFormatter setDateFormat:@"HH点mm分"];//修改时区为东8区
            NSString *destDateString = [dateFormatter stringFromDate:timeDate];
            self.timeLabel.text=destDateString;
            [self.chooseTimeView removeFromSuperview];
        }
    }else{
        [dateFormatter setDateFormat:@"HH点mm分"];//修改时区为东8区
        NSString *destDateString = [dateFormatter stringFromDate:timeDate];
        self.timeLabel.text=destDateString;
        [self.chooseTimeView removeFromSuperview];
    }
}
- (IBAction)delegateClick:(id)sender {
    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil] show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [MBProgressHUD showMessag:@"删除中..." toView:self.view];
        [ModelTool httpAppUpReportFeeDelReportFeeWithParameter:@{@"uid":_bodyDic[@"uid"],@"key":_bodyDic[@"key"],@"id":_bodyDic[@"id"]} success:^(id object) {
            MyLog(@"%@",object);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if ([object[@"operationState"] isEqualToString:@"SUCCESS"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReoirtCostBack" object:nil];
                }else{
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                }
            });
        } faile:^(NSError *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
}
@end
