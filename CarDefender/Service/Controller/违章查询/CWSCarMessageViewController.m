//
//  CWSCarMessageViewController.m
//  CarDefender
//
//  Created by 万茜 on 15/12/9.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSCarMessageViewController.h"
#import "CWSSelectCarAreaController.h"
#import "LHPChooseCarMenulController.h"
#import "CWSIllegalCheckViewController.h"
#import "UIImageView+WebCache.h"

@interface CWSCarMessageViewController ()

{
    NSArray* areaArray;
    NSDictionary*simpleDic;
    UIView *helpBackView;
    UIView *helpPhotoView;
}
- (IBAction)helpButton:(UIButton *)sender;
- (IBAction)helpDeleteButtonClick:(UIButton *)sender;

@end

@implementation CWSCarMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    self.title = @"车辆信息";
    [self initalizeUserInterface];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chooseCarMsgBack:) name:@"chooseCarBack" object:nil];//选车返回
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chooseCarBack" object:nil];
}

#pragma mark - 界面
- (void)initalizeUserInterface
{
    self.scrollView.scrollEnabled = NO;
    [self.scrollView addSubview:self.groundView];
    [self.groundView setFrame:CGRectMake(0, 0, kSizeOfScreen.width, self.groundView.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake(0, self.groundView.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator=NO;
    
    [self.carBrandField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    //选择品牌
    self.chooseBrandButton = (UIButton *)[self.view viewWithTag:1];
    [self.chooseBrandButton addTarget:self action:@selector(chooseBrandButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //选择车城市
    self.chooseCarCityButton = (UIButton *)[self.view viewWithTag:2];
    [self.chooseCarCityButton addTarget:self action:@selector(chooseCarCityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //选择字母
    self.chooseNumberButton = (UIButton *)[self.view viewWithTag:3];
    [self.chooseNumberButton addTarget:self action:@selector(chooseNumberButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //查询城市
    self.checkCityButton = (UIButton *)[self.view viewWithTag:4];
    [self.checkCityButton addTarget:self action:@selector(checkCityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //保存
    self.saveButton = (UIButton *)[self.view viewWithTag:5];
    [self.saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 车辆信息返回通知事件

-(void)chooseCarMsgBack:(NSNotification*)sender
{
    
    
    NSDictionary*dic=sender.object;
//    [_bodyDic setObject:dic[@"brandCar"][@"id"] forKey:@"brand"];//车辆品牌
//    [_bodyDic setObject:dic[@"modelCar"][@"id"] forKey:@"series"];//车系
//    [_bodyDic setObject:dic[@"styleCar"][@"id"] forKey:@"module"];//车型
    
    CGRect backViewFrame=self.groundView.frame;
    backViewFrame.origin.y=self.addCarHeadView.frame.size.height;
    self.groundView.frame=backViewFrame;
    
    self.scrollView.contentSize=CGSizeMake(self.view.frame.size.width, self.groundView.frame.size.height+self.groundView.frame.origin.y);
    
    self.carBrandField.text=[NSString stringWithFormat:@"%@-%@",dic[@"brandCar"][@"name"],dic[@"modelCar"][@"type"]];
    NSString*url=[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"baseUrl"],dic[@"brandCar"][@"logo"]];
    NSURL*logoImgUrl=[NSURL URLWithString:url];
    [self.carImage setImageWithURL:logoImgUrl placeholderImage:[UIImage imageNamed:@"normal_car_brand"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
}

#pragma mark - 选择品牌
- (void)chooseBrandButtonClick:(UIButton *)sender
{
    LHPChooseCarMenulController*chooseCarVC=[[LHPChooseCarMenulController alloc]initWithNibName:@"LHPChooseCarMenulController" bundle:nil];
    chooseCarVC.notiKey=@"chooseCarBack";
    [self.navigationController pushViewController:chooseCarVC animated:YES];
}

#pragma mark - 选择车城市
- (void)chooseCarCityButtonClick:(UIButton *)sender
{
    //选择地区
    areaArray = @[@"京(北京)",@"沪(上海)",@"粤(广东)",@"浙(浙江)",@"津(天津)",@"渝(重庆)",@"川(四川)",@"黑(黑龙江)",@"吉(吉林)",@"辽(辽宁)",@"鲁(山东)",@"湘(湖南)",@"蒙(内蒙古)",@"冀(河北)",@"新(新疆)",@"甘(甘肃)",@"青(青海)",@"陕(陕西)",@"宁(宁夏)",@"豫(河南)",@"晋(山西)",@"皖(安徽)",@"鄂(湖北)",@"苏(江苏)",@"贵(贵州)",@"黔(贵州)",@"云(云南)",@"桂(广西)",@"藏(西藏)",@"赣(江西)",@"闽(福建)",@"琼(海南)",@"使(大使馆)",];
    
    CWSSelectCarAreaController* selectVc = [CWSSelectCarAreaController new];
    selectVc.selectWhat = @"选择地区";
    selectVc.dataArray = areaArray;
    selectVc.selectedAreaOrLetter = ^(NSString* thySelectedArea){
        self.carAreaLabel.text = thySelectedArea;
    };
    [self.navigationController pushViewController:selectVc animated:YES];
    areaArray = nil;
}

#pragma mark - 选择字母
- (void)chooseNumberButtonClick:(UIButton *)sender
{
    //选择字母
    areaArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    CWSSelectCarAreaController* selectVc = [CWSSelectCarAreaController new];
    selectVc.selectWhat = @"选择字母";
    selectVc.dataArray = areaArray;
    selectVc.selectedAreaOrLetter = ^(NSString* thySelectedLetter){
        self.carLetterLabel.text = thySelectedLetter;
    };
    [self.navigationController pushViewController:selectVc animated:YES];
    areaArray = nil;
}

#pragma mark - 查询城市
- (void)checkCityButtonClick:(UIButton *)sender
{
    //选择地区
    areaArray = @[@"京(北京)",@"沪(上海)",@"粤(广东)",@"浙(浙江)",@"津(天津)",@"渝(重庆)",@"川(四川)",@"黑(黑龙江)",@"吉(吉林)",@"辽(辽宁)",@"鲁(山东)",@"湘(湖南)",@"蒙(内蒙古)",@"冀(河北)",@"新(新疆)",@"甘(甘肃)",@"青(青海)",@"陕(陕西)",@"宁(宁夏)",@"豫(河南)",@"晋(山西)",@"皖(安徽)",@"鄂(湖北)",@"苏(江苏)",@"贵(贵州)",@"黔(贵州)",@"云(云南)",@"桂(广西)",@"藏(西藏)",@"赣(江西)",@"闽(福建)",@"琼(海南)",@"使(大使馆)",];
    
    CWSSelectCarAreaController* selectVc = [CWSSelectCarAreaController new];
    selectVc.selectWhat = @"选择地区";
    selectVc.dataArray = areaArray;
    selectVc.selectedAreaOrLetter = ^(NSString* thySelectedArea){
        self.checkCityLabel.text = thySelectedArea;
    };
    [self.navigationController pushViewController:selectVc animated:YES];
    areaArray = nil;
}

#pragma mark - 保存
- (void)saveButtonClick:(UIButton *)sender
{

        
    if (!self.carBrandField.text.length) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择品牌车系" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    if (!self.carNumberField.text.length) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入车牌号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    if (!self.checkCityLabel.text.length) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入查询城市" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    if (!self.carFrameField.text.length) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入车架号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    
    
    CWSIllegalCheckViewController *vc = [[CWSIllegalCheckViewController alloc] init];
    vc.title = @"违章查询";
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


#pragma mark - 帮助按钮
- (IBAction)helpButton:(UIButton *)sender {
    
    
    helpBackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    helpBackView.backgroundColor = KBlackMainColor;
    helpBackView.alpha = 0.2;
    helpPhotoView = [[[NSBundle mainBundle] loadNibNamed:@"HelpView" owner:self options:nil] lastObject];
   
    [self.view addSubview:helpBackView];
    [self.view addSubview:helpPhotoView];
    

}

#pragma mark - 帮助删除
- (IBAction)helpDeleteButtonClick:(UIButton *)sender {
    [helpBackView removeFromSuperview];
    [helpPhotoView removeFromSuperview];
}
@end
