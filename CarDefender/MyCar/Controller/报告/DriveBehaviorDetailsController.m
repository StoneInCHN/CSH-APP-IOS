//
//  DriveBehaviorDetailsController.m
//  CarDefender

//  行为详情
//
//  Created by 周子涵 on 15/5/23.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "DriveBehaviorDetailsController.h"
#import "CWSFootprintDetailsController.h"
#import "CWSDriveBenaviorMapController.h"
#import "MJRefresh.h"
#import "DrivBehaviorCell.h"

@interface DriveBehaviorDetailsController ()
{
    NSArray* _dataArray;
    UITableView* _tableView;
}
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *headTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *headContentLabel;

@end

@implementation DriveBehaviorDetailsController
-(void)getData{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    [ModelTool httpGetDayDataDesWithParameter:self.dataDic success:^(id object) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary* dic = object;
        MyLog(@"%@",dic);
        if ([dic[@"operationState"] isEqualToString:@"SUCCESS"]) {
            _dataArray = dic[@"data"][@"list"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        }
        else  {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"data"][@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    } faile:^(NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错,请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    MyLog(@"%@",self.dataDic);
    switch ([self.dataDic[@"type"] intValue]) {
        case 1:
        {
            self.headImageView.image = [UIImage imageNamed:@"xiangqing_jijiasu"];
            self.headTitleLable.text = @"急加速";
            self.headContentLabel.text = @"急加速容易造成追尾、碰撞等事故；行车时应注意避免加速过急。";
        }
            break;
        case 2:
        {
            self.headImageView.image = [UIImage imageNamed:@"xiangqing_jizhuanwan"];
            self.headTitleLable.text = @"急转弯";
            self.headContentLabel.text = @"转弯过急容易发生碰撞、侧翻等事故；行车时应注意避免急转弯行为。";
        }
            break;
        case 3:
        {
            self.headImageView.image = [UIImage imageNamed:@"xiangqing_jishache"];
            self.headTitleLable.text = @"急刹车";
            self.headContentLabel.text = @"急刹车易导致后车追尾等事故，行车时应注意避免急刹车行为。";
        }
            break;
        case 4:
        {
            self.headImageView.image = [UIImage imageNamed:@"xiangqing_pilaojiashi"];
            self.headTitleLable.text = @"疲劳驾驶";
            self.headContentLabel.text = @"疲劳驾驶往往伴随着重大事故的发生，珍惜生命，请绝疲劳驾驶！";
        }
            break;
            
        default:
            break;
    }
    [self.headView setFrame:CGRectMake(0, 0, kSizeOfScreen.width, 147)];
    [self creatTableView];
    [self getData];
}
-(void)creatTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height - kDockHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.headView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
#pragma mark - tableView数据源协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *drivBehaviorCell=@"DrivBehaviorCell";
    DrivBehaviorCell* cell = [tableView dequeueReusableCellWithIdentifier:drivBehaviorCell];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DrivBehaviorCell" owner:self options:nil][0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSDictionary* dic = _dataArray[indexPath.row];
    cell.timeLabel.text = dic[@"time"];
    cell.addressLabel.text = dic[@"addr"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dic = _dataArray[indexPath.row];
    MyLog(@"%@",dic);
    CWSDriveBenaviorMapController* lController = [[CWSDriveBenaviorMapController alloc] init];
//    lController.type = @"0";
    lController.lon = dic[@"lon"];
    lController.lat = dic[@"lat"];
    lController.address = dic[@"addr"];
    lController.title = @"详细位置";
    [self.navigationController pushViewController:lController animated:YES];
}
@end
