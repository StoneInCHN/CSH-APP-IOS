//
//  CWSWeatherController.m
//  weather
//
//  Created by 周子涵 on 15/7/6.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSWeatherController.h"
#import "UIImageView+WebCache.h"
#import "CWSWeatherCell.h"
#import "Weather.h"
#import "FutureWeather.h"

#import "Define.h"

@interface CWSWeatherController ()<UITableViewDataSource,UITableViewDelegate>
{
    Weather*     _weather;
    NSArray*     _dataArray;
    UITableView* _tableView;
}
//头部View
@property (strong, nonatomic) IBOutlet UIView *headView;         //头部View
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;         //城市Label
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;         //日期Label
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;      //天气Label
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;         //当前温度Label
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;  //当日温度
@property (weak, nonatomic) IBOutlet UILabel *PMLabel;           //pm2.5值Label
@property (weak, nonatomic) IBOutlet UILabel *PMStateLabel;      //pm2.5状态Label
@property (weak, nonatomic) IBOutlet UILabel *carWashStateLabel; //洗车指数LabeL
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView; //天气图片


- (IBAction)backBtnClick;
@end

@implementation CWSWeatherController
-(void)getData{
    NSDictionary* lDic1 = @{@"carName":@"渝A99999",
                           @"carImage":@"weather_carlogo",
                           @"markImage":@"weather_car",
                           @"mark":@"行"};
    NSDictionary* lDic2 = @{@"carName":@"渝A88888",
                            @"carImage":@"weather_carlogo",
                            @"markImage":@"weather_car",
                            @"mark":@"行"};
    NSDictionary* lDic3 = @{@"carName":@"渝A11111",
                            @"carImage":@"weather_carlogo",
                            @"markImage":@"weather_xiancar",
                            @"mark":@"限"};
    _dataArray = @[lDic1,lDic2,lDic3];
    NSDictionary* dic = @{
                          @"resultcode": @"200",
                          @"reason": @"查询成功!",
                          @"data": @{
                                  @"updateTime": @"14:25",	/*更新时间*/
                                  @"today": @{
                                          @"imageURL":@"weather_bigimg.png",
                                          @"city": @"天津",
                                          @"date": @"2014年03月21日 星期五",
                                          @"temp": @"21°",	/*当前温度*/
                                          @"temperature": @"8°~20°",	/*今日温度*/
                                          @"weather": @"晴转霾",	/*今日天气*/
                                          @"wash_index": @"较适宜",	/*洗车指数*/
                                          @"pm2_5":@"28",
                                          @"pm2_5State":@"较差",
                                          },
                                  @"future": @[	/*未来几天天气*/
                                          @{
                                              @"temperature": @"28°~36°",
                                              @"weather": @"晴转多云",
                                              @"imageUrl":@"weather_smallimg",
                                              @"week": @"星期一",
                                              },
                                          @{
                                              @"temperature": @"28°~36°",
                                              @"weather": @"晴转多云",
                                              @"imageUrl":@"weather_smallimg",
                                              @"week": @"星期二",
                                              },
                                          @{
                                              @"temperature": @"27°~35°",
                                              @"weather": @"晴转多云",
                                              @"imageUrl":@"weather_smallimg",
                                              @"week": @"星期三",
                                              },
                                          @{
                                              @"temperature": @"27°~34°",
                                              @"weather": @"多云",
                                              @"imageUrl":@"weather_smallimg",
                                              @"week": @"星期四",
                                              },
                                          @{
                                              @"temperature": @"27°~33°",
                                              @"weather": @"多云",
                                              @"imageUrl":@"weather_smallimg",
                                              @"week": @"星期五",
                                              }
                                          ]
                                  },
                          @"error_code": @"0",
                          };
    _weather = [[Weather alloc] initWithDic:dic[@"data"]];
    [self setHeadView];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    [self getData];
    [self creatTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)setHeadView{
    self.cityLabel.text = _weather.city;
    self.dateLabel.text = _weather.date;
    self.tempLabel.text = _weather.temp;
    self.temperatureLabel.text = _weather.temperature;
    self.weatherLabel.text = _weather.weather;
    self.carWashStateLabel.text = _weather.washIndex;
    self.PMLabel.text = _weather.pm2_5;
    self.PMStateLabel.text = _weather.pm2_5_State;
    self.weatherImageView.image = [UIImage imageNamed:_weather.imageURL];
    for (int i = 0; i < _weather.furtureArray.count; i++) {
        FutureWeather* futherWeather = _weather.furtureArray[i];
        
        UILabel* weekLabel = (UILabel*)[self.headView viewWithTag:i + 10];
        weekLabel.text = futherWeather.week;
        
        UILabel* temperatureLabel = (UILabel*)[self.headView viewWithTag:i + 30];
        temperatureLabel.text = futherWeather.temperature;
        
        UIImageView* imageView = (UIImageView*)[self.headView viewWithTag:i + 20];
        imageView.image = [UIImage imageNamed:futherWeather.imageUrl];
    }
}
-(void)creatTableView{
    [self.headView setFrame:CGRectMake(0, 0, self.headView.frame.size.width, self.headView.frame.size.height)];
    [self.headView setBackgroundColor:kCOLOR(118, 174, 232)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height + kSTATUS_BAR) style:UITableViewStylePlain];
    _tableView.backgroundColor = kCOLOR(118, 174, 232);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.headView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"weatherCell";
    CWSWeatherCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CWSWeatherCell" owner:self options:nil][0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSDictionary* dataDic = _dataArray[indexPath.row];
    cell.dataDic = dataDic;
    return cell;
}
#pragma mark - tableView代理协议
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}
- (IBAction)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
