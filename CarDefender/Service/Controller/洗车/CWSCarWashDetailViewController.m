//
//  CWSCarWashDetailViewController.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/10.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSCarWashDetailViewController.h"
#import "CWSCarWashReviewViewController.h"
#import "CWSPayViewController.h"
#import "CWSCarWashDetileController.h"

#import "NewCarWashDetailHeaderView.h"
#import "CWSTableViewButtonCellDelegate.h"

//模型
#import "CWSCarMaintainInfoModel.h"
#import "CWSCellHeightModel.h"
#import "CWSCarWashDetailReviewModel.h"   //用户评论model
#import "CWSCarWashDiscountModel.h"       //含有打折信息的model

//cell
#import "NewCarWashDetailReviewCell.h"  //评论cell
#import "NewCarWashDiscountCell.h"     //打折cell
#import "CWSNewCarWashNormalCell.h"

#import "CWSYuYueViewController.h" //预约保养
#import "CWSTyreHomeController.h"
#import "ChoseDatePikerView.h"

#define HEADER_HEIGHT 33.0f
#define CELL_HEIGHT 40.f
#define REVIEWCELL_HEIGHT_NOIMG 64.0f
#define REVIEWCELL_HEIGHT_IMG 114.0f
#define DISCOUNTCELL_HEIGHT_NOINFO 40.0f
#define DISCOUNTCELL_HEIGHT_INFO 52.0f
@interface CWSCarWashDetailViewController ()<UITableViewDataSource,UITableViewDelegate,CWSTableViewButtonCellDelegate,ChoseDatePikerViewDelegate>{

    UITableView* myTableView;
    
    NSMutableArray* dataArray;
    NSMutableArray* reviewDataArray;
    NSMutableArray* rowsHeightArray;
    
    //换接口后数据源
    NSMutableDictionary *_dataDic;
    NSMutableArray *_goodsListArray;
    NSMutableArray *_sectionNameArray; //分段的名称
    
    NSMutableArray *_commentsArray;
    NSMutableArray *_normolWashArray;
    NSMutableArray *_fineWashArray;
    NSMutableArray *_BeautyArray;
    NSMutableArray *_maintenanceArray;
    NSMutableArray *_images;
    
    NSString* _currentStoreName;
    
    UserInfo *userInfo;
    
    UIView *chooseBgView;
}

@end

@implementation CWSCarWashDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.indexNumber = 0;
    [Utils changeBackBarButtonStyle:self];
    userInfo = [UserInfo userDefault];
    [self initialData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [ModelTool stopAllOperation];
}
#pragma mark -================================InitialData
-(void)initialData{
    if(!dataArray){
        dataArray = @[].mutableCopy;
        reviewDataArray = @[].mutableCopy;
        rowsHeightArray = @[].mutableCopy;
        
        _dataDic = [NSMutableDictionary dictionary];
        _goodsListArray = [NSMutableArray array];
        _sectionNameArray = [NSMutableArray array];

        _commentsArray = [NSMutableArray array];
        _normolWashArray= [NSMutableArray array];
        _fineWashArray= [NSMutableArray array];
        _BeautyArray= [NSMutableArray array];
        _maintenanceArray= [NSMutableArray array];
    }
    
    [self getData];
}

-(void)getData{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
    [HttpHelper getTenantDetailsWithUserId:userInfo.desc
                                     token:userInfo.token
                                  tenantId:[NSString stringWithFormat:@"%ld", (long)_idNumber]
                                   success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                       NSLog(@"租户详情:%@",responseObjcet);
                                       NSDictionary *dict = (NSDictionary *)responseObjcet;
                                       NSString *code = dict[@"code"];
                                       userInfo.token = dict[@"token"];
                                       if ([code isEqualToString:SERVICE_SUCCESS]) {
                                           _dataDic = [dict[@"msg"] mutableCopy];
                                           _currentStoreName = _dataDic[@"tenantName"];
                                           _goodsListArray = [_dataDic[@"carServices"] mutableCopy];
                                           NSArray *tenantImages = _dataDic[@"tenantImages"];
                                           _images = [NSMutableArray array];
                                           for (NSDictionary *imageDict in tenantImages) {
                                               [_images addObject:imageDict[@"image"]];
                                           }
                                           //分别添加数据源
                                           NSMutableArray *sectionNameArray = [NSMutableArray array];
                                           for (NSDictionary *dic in _goodsListArray) {
                                               [sectionNameArray addObject:dic[@"categoryName"]];
                                               if ([dic[@"categoryName"] isEqualToString:@"保险"]) {
                                                   _commentsArray = dic[@"subServices"];
                                               }else if ([dic[@"categoryName"] isEqualToString:@"保养"]){
                                                   _normolWashArray = dic[@"subServices"];
                                                   NSLog(@"%@",_normolWashArray);
                                               }else if ([dic[@"categoryName"] isEqualToString:@"紧急救援"]){
                                                   _fineWashArray = dic[@"subServices"];
                                               }else if ([dic[@"categoryName"] isEqualToString:@"洗车"]){
                                                   _BeautyArray= dic[@"subServices"];
                                               }else if ([dic[@"categoryName"] isEqualToString:@"美容"]){
                                                   _maintenanceArray= dic[@"subServices"];
                                               }
                                           }
                           
                                           //将数据源添加进model
                                           for (int i = 0; i<sectionNameArray.count; i++) {
                                               CWSCarMaintainInfoModel* model = [CWSCarMaintainInfoModel new];
                                               model.sectionName = sectionNameArray[i];
                                               if([model.sectionName isEqualToString:@"保险"]){
                                                   for(int j=0; j<_commentsArray.count; j++){
                                                       NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_commentsArray[j]];
                                                       [dic setValue:model.sectionName forKey:@"type"];
                                                       CWSCarWashDiscountModel* discountModel = [[CWSCarWashDiscountModel alloc]initWithDic:dic];
                                                       discountModel.merchantsName = _currentStoreName;
                                                       [model.realDataArray addObject:discountModel];
                                                       
                                                       CWSCellHeightModel* cellHeightModel = [[CWSCellHeightModel alloc]init];
                                                       cellHeightModel.currentCellHeight =   [NSString stringWithFormat:@"%f",discountModel.productDetailName ? DISCOUNTCELL_HEIGHT_INFO : DISCOUNTCELL_HEIGHT_NOINFO];
                                                       [model.cellHeightArray addObject:cellHeightModel];
                                                   }
                           
                                               }else if([model.sectionName isEqualToString:@"保养"]){
                           
                                                   for(int j=0; j<_normolWashArray.count; j++){
                                                       NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_normolWashArray[j]];
                                                       [dic setValue:model.sectionName forKey:@"type"];
                                                       CWSCarWashDiscountModel* discountModel = [[CWSCarWashDiscountModel alloc]initWithDic:dic];
                                                       discountModel.merchantsName = _currentStoreName;
                                                       [model.realDataArray addObject:discountModel];
                           
                                                       CWSCellHeightModel* cellHeightModel = [[CWSCellHeightModel alloc]init];
                                                       cellHeightModel.currentCellHeight =   [NSString stringWithFormat:@"%f",discountModel.productDetailName ? DISCOUNTCELL_HEIGHT_INFO : DISCOUNTCELL_HEIGHT_NOINFO];
                                                       [model.cellHeightArray addObject:cellHeightModel];
                                                   }
                                               }else if([model.sectionName isEqualToString:@"紧急救援"]){
                                                   for(int j=0; j<_fineWashArray.count; j++){
                                                       NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_fineWashArray[j]];
                                                       [dic setValue:model.sectionName forKey:@"type"];
                                                       CWSCarWashDiscountModel* discountModel = [[CWSCarWashDiscountModel alloc]initWithDic:dic];
                                                       discountModel.merchantsName = _currentStoreName;
                                                       [model.realDataArray addObject:discountModel];
                                                       CWSCellHeightModel* cellHeightModel = [[CWSCellHeightModel alloc]init];
                                                       cellHeightModel.currentCellHeight =   [NSString stringWithFormat:@"%f",discountModel.productDetailName ? DISCOUNTCELL_HEIGHT_INFO : DISCOUNTCELL_HEIGHT_NOINFO];
                                                       [model.cellHeightArray addObject:cellHeightModel];
                                                   }
                                               }else if([model.sectionName isEqualToString:@"美容"]){
                                                   for(int j=0; j<_maintenanceArray.count; j++){
                                                       NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_maintenanceArray[j]];
                                                       [dic setValue:model.sectionName forKey:@"type"];
                                                       CWSCarWashDiscountModel* discountModel = [[CWSCarWashDiscountModel alloc]initWithDic:dic];
                                                       discountModel.merchantsName = _currentStoreName;
                                                       [model.realDataArray addObject:discountModel];
                                                       CWSCellHeightModel* cellHeightModel = [[CWSCellHeightModel alloc]init];
                                                       cellHeightModel.currentCellHeight =   [NSString stringWithFormat:@"%f",discountModel.productDetailName ? DISCOUNTCELL_HEIGHT_INFO : DISCOUNTCELL_HEIGHT_NOINFO];
                                                       [model.cellHeightArray addObject:cellHeightModel];
                                                   }
                                               }else if([model.sectionName isEqualToString:@"洗车"]){
                                                   for(int j=0; j<_BeautyArray.count; j++){
                                                       NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_BeautyArray[j]];
                                                       [dic setValue:model.sectionName forKey:@"type"];
                                                       
                                                       CWSCarWashDiscountModel* discountModel = [[CWSCarWashDiscountModel alloc]initWithDic:dic];
                                                       discountModel.merchantsName = _currentStoreName;
                                                       [model.realDataArray addObject:discountModel];
                                                       CWSCellHeightModel* cellHeightModel = [[CWSCellHeightModel alloc]init];
                                                       cellHeightModel.currentCellHeight =   [NSString stringWithFormat:@"%f",discountModel.productDetailName ? DISCOUNTCELL_HEIGHT_INFO : DISCOUNTCELL_HEIGHT_NOINFO];
                                                       [model.cellHeightArray addObject:cellHeightModel];
                                                   }
                                               }
                                               
                                               [dataArray addObject:model];
                                              
                                           }
                                           if (dataArray.count >=  1) {
                                               [self createTableView];
                                           }
                                           
                                       }else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                       } else {
                                           [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                       }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }];
}


#pragma mark -================================CreateUI
-(void)createTableView{
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-kDockHeight) style:UITableViewStyleGrouped];
    myTableView.backgroundColor = kCOLOR(245, 245, 245);
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.bounces = YES;
    myTableView.showsHorizontalScrollIndicator = NO;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.estimatedRowHeight = 2.0f;
    myTableView.rowHeight = UITableViewAutomaticDimension;
    
//    [myTableView registerNib:[UINib nibWithNibName:@"NewCarWashDetailReviewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ThyReviewCell"];
//    [myTableView registerNib:[UINib nibWithNibName:@"NewCarWashDiscountCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DiscountCell"];
//    [myTableView registerNib:[UINib nibWithNibName:@"CWSNewCarWashNormalCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"NormalCell"];
    [self.view addSubview:myTableView];
}


#pragma mark -================================TableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArray.count + 1;
//    return _sectionNameArray.count + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(!section){
        return 0;
    }
//    else if (section == 1){
//        return 0;
//    }
    else{
    
        CWSCarMaintainInfoModel* model = dataArray[section-1];
        return model.realDataArray.count;
//        NSDictionary* dataDict = dataArray[section-1];
//        NSMutableArray* currentDataDictArr = dataDict[_sectionNameArray[section-1]];
//        return currentDataDictArr.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if(!indexPath.section){
//        return nil;
//    }
//        else if(indexPath.section == 1){
//        //添加评论
//        
//        return nil;
//    }
//    else{
//        
//        NSDictionary* currentDataDict = dataArray[indexPath.section-1];
//        NSMutableDictionary* dataDict = currentDataDict[_sectionNameArray[indexPath.section-1]][indexPath.row];
//        [dataDict setObject:_currentStoreName forKeyedSubscript:@"tenantName"];
//        CWSCarWashDiscountModel* model = [[CWSCarWashDiscountModel alloc]initWithDic:dataDict];
//        NewCarWashDiscountCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"NewCarWashDiscountCell" owner:self options:nil] lastObject];
//        cell.delegate = self;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell setDiscountModel:model];
//        return cell;
//    }
    
    NSLog(@"indexPath.section is %ld", (long)indexPath.section);
    NSInteger index = indexPath.section;
//    if (indexPath.section == 4) {
//        self.indexNumber = self.indexNumber + 1;
//    }
//    if (indexPath.section == 5) {
//        index = 1;
//    }
//    if (self.indexNumber == 2) {
//        index = index + 1;
//        self.indexNumber = self.indexNumber + 1;
//    }
    if(!indexPath.section){
        return nil;
    }else if([[dataArray[index-1] sectionName] isEqualToString:@"保险"]){
        CWSNewCarWashNormalCell* cell = [[[NSBundle mainBundle]loadNibNamed:@"CWSNewCarWashNormalCell" owner:self options:nil] lastObject];
        cell.productNameLabel.text = @"";
        [cell.payButton setTitle:@"咨询" forState:UIControlStateNormal];
        cell.priceLabel.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if([[dataArray[index-1] sectionName] isEqualToString:@"保养"]){
        CWSNewCarWashNormalCell* cell = [[[NSBundle mainBundle]loadNibNamed:@"CWSNewCarWashNormalCell" owner:self options:nil] lastObject];
        cell.productNameLabel.text = @"";
        [cell.payButton setTitle:@"预约" forState:UIControlStateNormal];
        cell.indexPath = indexPath;
        //保养预约与美容预约不同 需要设置tag区分
        cell.payButton.tag = 201;
        cell.priceLabel.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        NSArray *baoyaoArr =(NSArray *)_goodsListArray[indexPath.section-2][@"subServices"];
        NSDictionary *dic = (NSDictionary *)baoyaoArr[indexPath.row];
        NSLog(@"%@",dic);
//        NSLog(@"mingzi =%@",(NSArray *)_goodsListArray[indexPath.section][@"subServices"]);
        CWSCarWashDiscountModel * discount = [[CWSCarWashDiscountModel alloc]initWithDic:dic];
        cell.discountModel = discount;
        cell.delegate =self;
        return cell;
    }else if([[dataArray[index-1] sectionName] isEqualToString:@"紧急救援"]){
        CWSNewCarWashNormalCell* cell = [[[NSBundle mainBundle]loadNibNamed:@"CWSNewCarWashNormalCell" owner:self options:nil] lastObject];
        cell.productNameLabel.text = @"";
        [cell.payButton setTitle:@"救援" forState:UIControlStateNormal];
        [cell.payButton addTarget:self action:@selector(emergencyRescueEvent) forControlEvents:UIControlEventTouchUpInside];
        cell.priceLabel.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if([[dataArray[index-1] sectionName] isEqualToString:@"洗车"]){
        CWSCarMaintainInfoModel* model = dataArray[indexPath.section-1];
        NewCarWashDiscountCell* cell = [[[NSBundle mainBundle]loadNibNamed:@"NewCarWashDiscountCell" owner:self options:nil] lastObject];
        cell.delegate = self;
        [cell setDiscountModel:model.realDataArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if([[dataArray[index-1] sectionName] isEqualToString:@"美容"]){
        CWSNewCarWashNormalCell* cell = [[[NSBundle mainBundle]loadNibNamed:@"CWSNewCarWashNormalCell" owner:self options:nil] lastObject];
        cell.productNameLabel.text = @"";
        [cell.payButton setTitle:@"预约" forState:UIControlStateNormal];
        cell.priceLabel.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        return nil;
    }
}
- (void)emergencyRescueEvent {
    CWSTyreHomeController *emergencyRescue = [[CWSTyreHomeController alloc] init];
    [self.navigationController pushViewController:emergencyRescue animated:YES];
}
- (void)selectTableViewButtonClicked:(UIButton *)sender andDiscountModel:(CWSCarWashDiscountModel *)thyModel
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:thyModel.discountPrice forKey:@"discount_price"];
    [dict setObject:[NSNumber numberWithInteger:thyModel.productID] forKey:@"goods_id"];
    [dict setObject:thyModel.productName forKey:@"goods_name"];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:@"is_discount_price"];
    [dict setObject:[NSNumber numberWithInteger:thyModel.merchantsID] forKey:@"store_id"];
    [dict setObject:thyModel.merchantsName forKey:@"store_name"];
    [dict setObject:thyModel.originalPrice forKey:@"price"];
    [dict setObject:thyModel.discountPrice forKey:@"discount_price"];
    
    CWSPayViewController* payVc = [CWSPayViewController new];
    payVc.dataDict = dict;
    [self.navigationController pushViewController:payVc animated:YES];
}

#pragma mark -================================TableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat thyRowHeight;
    
    if(!indexPath.section){
        thyRowHeight = 0.0f;
    }
//    else  if(indexPath.section == 1){
//        return 0;
//    }
    else{
        CWSCellHeightModel* heightModel = [dataArray[indexPath.section-1] cellHeightArray][indexPath.row];
        thyRowHeight = [heightModel.currentCellHeight floatValue];
//        NSDictionary* currentDict = dataArray[indexPath.section-1];
//        NSArray* currentArray = [currentDict valueForKey:_sectionNameArray[indexPath.section-1]];
//        return [currentArray[indexPath.row][@"currentCellHeight"] floatValue];
    }
    
    return thyRowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(!section){
        return 98.0f;
    }
    return HEADER_HEIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(!section){
        return 0.01;
    }else if(section == 1){
        return 0.01;
    }
    return 15.0f;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView* eachHeaderView = nil;
    
    if(!section){
        
        eachHeaderView = [[NewCarWashDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 98) Data:_dataDic images:_images controller:self];
    }
//    else if (section == 1){
//        return nil;
//    }
    else{
        
        eachHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width,HEADER_HEIGHT)];
        eachHeaderView.backgroundColor = [UIColor whiteColor];
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, kSizeOfScreen.width, 15)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:17.0f];
        titleLabel.textColor = KBlueColor;
        titleLabel.text = [dataArray[section-1] sectionName];
//        titleLabel.text = _sectionNameArray[section-1];
        [eachHeaderView addSubview:titleLabel];
        [titleLabel sizeToFit];
        
//        if([[dataArray[section-1] sectionName] isEqualToString:@"商家评价"]){
//            UIImageView* leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kSizeOfScreen.width-18, 10, 8, 12)];
//            leftImageView.image = [UIImage imageNamed:@"infor_jiantou"];
//            [eachHeaderView addSubview:leftImageView];
//            
//            NSString* sectionDetailString = [dataArray[section-1] sectionDetailName];
//            CGFloat sectionDetailWidth = [Utils strSize:sectionDetailString withMaxSize:CGSizeMake(0, 15) withFont:[UIFont systemFontOfSize:17.0f] withLineBreakMode:NSLineBreakByWordWrapping].width;
//            
//            UILabel* sectionDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(leftImageView.frame)-sectionDetailWidth-5, 8, sectionDetailWidth, 15)];
//            sectionDetailLabel.textAlignment = NSTextAlignmentRight;
//            sectionDetailLabel.textColor = [UIColor darkGrayColor];
//            sectionDetailLabel.font = [UIFont systemFontOfSize:17.0f];
//            sectionDetailLabel.text = sectionDetailString;
//            [eachHeaderView addSubview:sectionDetailLabel];
//            
//            UIButton* headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            headerButton.frame = CGRectMake(CGRectGetMinX(sectionDetailLabel.frame), 0, kSizeOfScreen.width-CGRectGetMinX(sectionDetailLabel.frame), eachHeaderView.frame.size.height);
//            [headerButton addTarget:self action:@selector(headerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//            [eachHeaderView addSubview:headerButton];
//        
//        }
        
    }
    
    return eachHeaderView;
}


#pragma mark -=========================================OtherCallBack
-(void)headerButtonClicked:(UIButton*)sender{
    
    MyLog(@"查看更多用户评论");
    
    CWSCarWashReviewViewController* reviewVc = [CWSCarWashReviewViewController new];
    [self.navigationController pushViewController:reviewVc animated:YES];
}


-(void)selectTableViewButtonClicked:(UIButton *)sender andDiscountModel:(CWSCarWashDiscountModel *)thyModel cellForRowAtIndexPath:(NSIndexPath*)indexPath{
    
    CWSCarWashDiscountModel* selectedModel = thyModel;
    
    NSMutableDictionary *dic = selectedModel.dataDic.mutableCopy;
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)selectedModel.merchantsID ] forKey:@"store_id"];
    [dic setValue:KUserManager.uid forKey:@"uid"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)selectedModel.productID ] forKey:@"goods_id"];
    [dic setValue:[NSString stringWithFormat:@"%@",selectedModel.productName] forKey:@"goods_name"];
    [dic setValue:[NSString stringWithFormat:@"%@",selectedModel.discountPrice] forKey:@"discount_price"];
//    [dic setValue:[NSString stringWithFormat:@"%d",selectedModel.isDiscount] forKey:@"is_discount_price"];
    [dic setValue:[NSString stringWithFormat:@"%d",YES] forKey:@"is_discount_price"];
    [dic setValue:[NSString stringWithFormat:@"%@",selectedModel.merchantsName] forKey:@"store_name"];
    
    
    
    //判断是否有优惠
    if(selectedModel.isDiscount){

            [dic setValue:selectedModel.discountPrice forKey:@"price"];

    }else {
            [dic setValue:selectedModel.originalPrice forKey:@"price"];
    }
    NSLog(@"%@",dic);
    
    //支付
    if([sender.titleLabel.text isEqualToString:@"支付"]){
        //生成订单
//        [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//        [ModelTool getGenerateOrderWithParameter:dic andSuccess:^(id object) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if ([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]) {
//                    MyLog(@"-----------支付订单信息--------%@",object);
//                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    CWSPayViewController* appointmentVc = [[CWSPayViewController alloc] init];
                    appointmentVc.washDiscountModel = thyModel;
                    appointmentVc.isRedpackageUseable = YES;
                    [appointmentVc setDataDict:dic];
                    appointmentVc.serviceId = [NSString stringWithFormat:@"%ld",(long)selectedModel.productID ];
                    [self.navigationController pushViewController:appointmentVc animated:YES];
//
//                }
//                else {
//                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                    [alert show];
//                }
//            });
//        } andFail:^(NSError *err) {
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
//        }];
        if(selectedModel.isRedPackageUseable){
            //可用红包
            CWSPayViewController* payVc = [CWSPayViewController new];
            payVc.isRedpackageUseable = YES;
            [payVc setDataDict:dic];
            [self.navigationController pushViewController:payVc animated:YES];
        
        }else{
            
            //不可用红包
            
        }
        
    }
    
    //预约
    if([sender.titleLabel.text isEqualToString:@"预约"]){
        //生成订单
        //时间选择器
        if (sender.tag==201) {
            //保养预约
            //获取商品id
            NSDictionary *dic = _normolWashArray[indexPath.row];
            NSDictionary *goodDic = @{@"service_id":dic[@"id"]};
            CWSYuYueViewController *yueyue = [[CWSYuYueViewController alloc]init];
            
            yueyue.goodDic = goodDic;
            [self.navigationController pushViewController:yueyue animated:YES];
        }else{
            //美容预约
            myTableView.userInteractionEnabled = YES;
            chooseBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            chooseBgView.backgroundColor = [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:.5];
            [self.view addSubview:chooseBgView];
            ChoseDatePikerView *chooseDate = [[ChoseDatePikerView alloc]initWithFrame:CGRectMake(20, 70, self.view.frame.size.width-40, 280)];
            chooseDate.delegate = self;
            chooseDate.layer.cornerRadius = 5;
            chooseDate.goodDic = dic;
            
            
            [chooseBgView addSubview:chooseDate];
        }
    }
}
#pragma ChoseDatePikerViewDelegate
-(void)sureBtnCommitOrderButton:(UIButton*)button goodDic:(NSDictionary*)goodDic{
    NSLog(@"%@",goodDic);
    [chooseBgView removeFromSuperview];
    if(button.tag == 102){
        if (goodDic[@"id"]&&goodDic[@"price"]) {
            NSDictionary *dic = @{@"userId":KUserInfo.desc,@"token":KUserInfo.token,@"serviceId":goodDic[@"id"],@"price":goodDic[@"price"]};
            NSLog(@"%@\n%@",goodDic[@"id"],goodDic[@"price"]);
            [MBProgressHUD showMessag:@"正在预约" toView:self.view];
            [HttpHelper insertVehicleSubscribeServiceWithUserDic:dic success:^(AFHTTPRequestOperation *operation,id object){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSDictionary *dataDictionary = (NSDictionary *)object;
                NSLog(@"dataDictionary=%@",dataDictionary);
                
                if ([dataDictionary[@"code"] isEqualToString:SERVICE_SUCCESS]) {
                    CWSCarWashDetileController* carWashDetailVc = [CWSCarWashDetileController new];
                    [carWashDetailVc setDataDict:object[@"data"]];
                    carWashDetailVc.orderID = dataDictionary[@"desc"];
                    //订单详情
                    
                    [self.navigationController pushViewController:carWashDetailVc animated:YES];
                    
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:object[@"desc"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }
                
            } failure:^(AFHTTPRequestOperation *operation,NSError *error){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
    
}


@end
