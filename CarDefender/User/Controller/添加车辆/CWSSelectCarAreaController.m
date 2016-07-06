//
//  CWSSelectCarAreaController.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/4.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSSelectCarAreaController.h"


#define NUM_OF_EACHROWS 3
@interface CWSSelectCarAreaController()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation CWSSelectCarAreaController{

    UITableView* myTableView;
    
    int rowsCount;
    
    CGFloat eachButtonWidth;
    CGFloat trimWidth;
    CGFloat trimSpace;
    
    int startIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.selectWhat;
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    NSString* str = [self.dataArray firstObject];
    
    rowsCount = (int)((float)self.dataArray.count / NUM_OF_EACHROWS + 0.9);
    eachButtonWidth = [Utils strSize:str withMaxSize:CGSizeMake(0, 20) withFont:[UIFont systemFontOfSize:16.0] withLineBreakMode:NSLineBreakByCharWrapping].width;
    
    if([self.selectWhat isEqualToString:@"选择地区"]){
        eachButtonWidth += 20;
        trimWidth = 15.0f;
        trimSpace = (kSizeOfScreen.width-eachButtonWidth*NUM_OF_EACHROWS-2*trimWidth) / (NUM_OF_EACHROWS-1);
    }else{
        eachButtonWidth += 20;
        trimWidth = 30.f;
        trimSpace = (kSizeOfScreen.width-eachButtonWidth*NUM_OF_EACHROWS-2*trimWidth) / (NUM_OF_EACHROWS-1);
    }
    
    [self createTableView];
}


#pragma mark -========================creatUI
-(void)createTableView{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-kDockHeight) style:UITableViewStylePlain];
    myTableView.rowHeight = 50.0f;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.showsHorizontalScrollIndicator = NO;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.bounces = NO;
    [self setExtraCellLineHidden:myTableView];
    [self.view addSubview:myTableView];
}


#pragma mark -===============================TableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (NSInteger)rowsCount ? rowsCount : 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellUsedString = @"SelectCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellUsedString];
    
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellUsedString];
    }
    
    UIView* thyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 50)];
    thyView.backgroundColor = [UIColor clearColor];
    
    for(int i=0; i<NUM_OF_EACHROWS; i++){
        if(startIndex<self.dataArray.count){
            UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(trimWidth + (i*(trimSpace+eachButtonWidth)), 15, eachButtonWidth, 20);
            button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            [button setTitle:self.dataArray[startIndex] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(selectedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [thyView addSubview:button];
            startIndex++;
        }
    }
  
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:thyView];
    return cell;
}




#pragma mark -===============================TableViewDelegate








#pragma mark -===============================OtherCallBack
-(void)selectedButtonClicked:(UIButton*)sender{
    if(self.selectedAreaOrLetter){
        self.selectedAreaOrLetter([[sender.titleLabel.text componentsSeparatedByString:@"("] firstObject]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


+(NSString*)getUserLocationCityProvince{
    
    NSString *province= [NSString string];
    NSString *city = [NSString stringWithFormat:@"%@",KUserInfo.currentCity];
    if ([city isEqualToString:@"北京市"]) {
        province = @"京";
        return province;
    }else if ([city isEqualToString:@"天津市"]){
        province = @"津";
        return province;
    }else if ([city isEqualToString:@"河北省"]){
        province = @"冀";
        return province;
    }else if ([city isEqualToString:@"山西省"]){
        province = @"晋";
        return province;
    }else if ([city isEqualToString:@"内蒙古自治区"]){
        province = @"蒙";
        return province;
    }else if ([city isEqualToString:@"辽宁省"]){
        province = @"辽";
        return province;
    }else if ([city isEqualToString:@"吉林省"]){
        province = @"吉";
        return province;
    }else if ([city isEqualToString:@"黑龙江省"]){
        province = @"黑";
        return province;
    }else if ([city isEqualToString:@"上海市"]){
        province = @"沪";
        return province;
    }else if ([city isEqualToString:@"江苏省"]){
        province = @"苏";
        return province;
    }else if ([city isEqualToString:@"浙江省"]){
        province = @"浙";
        return province;
    }else if ([city isEqualToString:@"安徽省"]){
        province = @"皖";
        return province;
    }else if ([city isEqualToString:@"福建省"]){
        province = @"闽";
        return province;
    }else if ([city isEqualToString:@"江西省"]){
        province = @"赣";
        return province;
    }else if ([city isEqualToString:@"山东省"]){
        province = @"鲁";
        return province;
    }else if ([city isEqualToString:@"河南省"]){
        province = @"豫";
        return province;
    }else if ([city isEqualToString:@"湖北省"]){
        province = @"鄂";
        return province;
    }else if ([city isEqualToString:@"湖南省"]){
        province = @"湘";
        return province;
    }else if ([city isEqualToString:@"广东省"]){
        province = @"粤";
        return province;
    }else if ([city isEqualToString:@"广西壮族自治区"]){
        province = @"桂";
        return province;
    }else if ([city isEqualToString:@"海南省"]){
        province = @"琼";
        return province;
    }else if ([city isEqualToString:@"重庆市"]){
        province = @"渝";
        return province;
    }else if ([city isEqualToString:@"四川省"]){
        province = @"川";
        return province;
    }else if ([city isEqualToString:@"贵州省"]){
        province = @"贵";
        return province;
    }else if ([city isEqualToString:@"云南省"]){
        province = @"云";
        return province;
    }else if ([city isEqualToString:@"西藏自治区"]){
        province = @"藏";
        return province;
    }else if ([city isEqualToString:@"陕西省"]){
        province = @"陕";
        return province;
    }else if ([city isEqualToString:@"甘肃省"]){
        province = @"甘";
        return province;
    }else if ([city isEqualToString:@"青海省"]){
        province = @"青";
        return province;
    }else if ([city isEqualToString:@"宁夏回族自治区"]){
        province = @"宁";
        return province;
    }else if ([city isEqualToString:@"新疆维吾尔自治区"]){
        province = @"新";
        return province;
    }else{
        return @"渝";
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
