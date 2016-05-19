//
//  CWSCarMaintainDetailViewController.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/6.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSCarMaintainDetailViewController.h"
#import "CWSTableViewButtonCellDelegate.h"

#import "CarMaintainDetailHeaderView.h"
#import "CWSCarMaintainInfoModel.h"

#import "CWSCarMaintainDetailContentView.h"
#import "CWSCarMaintainComfirmAlertView.h"

#import "CarServiceDeclarationTableViewCell.h"
#import "MaintainReviewTableViewCell.h"

#define TITILEHEADERVIEW_HEIGHT 342.0f
@interface CWSCarMaintainDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CWSTableViewButtonCellDelegate>{

    UITableView* myTableView;
    
    NSMutableArray* dataArray;
    
    UIView* footerView;
    
    UIView* alertView;
    CWSCarMaintainComfirmAlertView* alertViewContent;
}

@end

@implementation CWSCarMaintainDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"保养详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    self.view.backgroundColor = [UIColor whiteColor];
    
    


    
    
    

    [self createTableView];
    [self initialData];
}


#pragma mark -======================================InitialData
-(void)initialData{
    
    if(!dataArray){
        dataArray = @[].mutableCopy;
    }
    
    
    [self loadData];
}
-(void)loadData{
    
    //保养项目
    for(int i=0; i<5; i++){
        CWSCarMaintainInfoModel* model = [CWSCarMaintainInfoModel new];
        model.sectionName = @"更换机油";
        model.priceLabelText = @"￥230";
        model.sectionDetailName = @"美孚一号 （进口）全合成...";
        model.isNeedShow = YES;
        for(int j=0; j<5; j++){
            [model.realDataArray addObject:[NSString stringWithFormat:@"%c-%d",i,j]];
        }
        [dataArray addObject:model];
    }
    
    //服务说明（以后要换成model）
    CWSCarMaintainInfoModel* modelService = [CWSCarMaintainInfoModel new];
    modelService.sectionName = @"服务说明";
    modelService.isShow = YES;
    [modelService.realDataArray addObject:@"这是服务说明，说明，说明！！！"];
    [dataArray addObject:modelService];
    
    
    //用户评价
    CWSCarMaintainInfoModel* modelReview = [CWSCarMaintainInfoModel new];
    modelReview.sectionName = @"用户评价";
    modelReview.isShow = YES;
    for(int i=0; i<2; i++){
        [modelReview.realDataArray addObject:@"这是用户的评论！"]; //这里添加评论model
    }
    [dataArray addObject:modelReview];
    
    
    
    
    [self createFooterView];
}



#pragma mark -======================================CreateUI
-(void)createTableView{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-kDockHeight-45) style:UITableViewStyleGrouped];
    myTableView.backgroundColor = KGrayColor3;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.bounces = YES;
    myTableView.showsHorizontalScrollIndicator = NO;
    myTableView.showsVerticalScrollIndicator = NO;
    [myTableView registerNib:[UINib nibWithNibName:@"CarServiceDeclarationTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CarServiceDeclarationCell"];
    [myTableView registerNib:[UINib nibWithNibName:@"MaintainReviewTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MaintainReviewCell"];
    [self.view addSubview:myTableView];

}

-(void)createFooterView{
    
    footerView = [[UIView alloc]initWithFrame:CGRectMake(0, kSizeOfScreen.height-89, kSizeOfScreen.width, 45)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:0.910f green:0.910f blue:0.910f alpha:1.00f];
    [footerView addSubview:lineView];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lineView.frame)+10, 65, 17)];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"参考价格";
    [footerView addSubview:titleLabel];
    [titleLabel sizeToFit];
    
    UILabel* footerPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+8, 10, 60, 17)];
    footerPriceLabel.textAlignment = NSTextAlignmentLeft;
    footerPriceLabel.textColor = kCOLOR(249, 98, 104);
    footerPriceLabel.text = @"￥400";
    footerPriceLabel.font = [UIFont systemFontOfSize:16.0f];
    [footerView addSubview:footerPriceLabel];
    
    UIButton* comfimButton = [UIButton buttonWithType:UIButtonTypeSystem];
    comfimButton.frame = CGRectMake(kSizeOfScreen.width-124, 0, 124, footerView.frame.size.height);
    comfimButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [comfimButton setTitle:@"预约服务" forState:UIControlStateNormal];
    [comfimButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [comfimButton setBackgroundColor:kCOLOR(255, 179, 89)];
    [comfimButton addTarget:self action:@selector(comfimButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:comfimButton];
    
    [self.view addSubview:footerView];
}



#pragma mark -======================================TableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{


    return dataArray.count+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(!section){
        return 0;
    }else{
        CWSCarMaintainInfoModel* model = dataArray[section-1];
        if(model.isShow){
            return model.realDataArray.count;
        }else{
            return 0;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = nil;
    
   
    
    if(indexPath.section !=0 && indexPath.section < dataArray.count-1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CarMaintainDetailCell"];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CarMaintainDetailCell"];
        CWSCarMaintainInfoModel* model = dataArray[indexPath.section-1];
        if(model.realDataArray.count){
            NSString* dataString = model.realDataArray[indexPath.row];
            cell.textLabel.text = dataString;
        }
     
    }else if(indexPath.section == dataArray.count-1){
    
        cell = [tableView dequeueReusableCellWithIdentifier:@"CarServiceDeclarationCell"];

    }else{
    
        cell = [tableView dequeueReusableCellWithIdentifier:@"MaintainReviewCell"];
        MaintainReviewTableViewCell* reviewCell = (MaintainReviewTableViewCell*)cell;
        CWSCarMaintainInfoModel* model = dataArray[indexPath.section-1];
        if(model.realDataArray.count){
            [reviewCell setReviewModel:model];
        }
        
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}




#pragma mark -======================================TableViewDelegate


/**设置section header的视图*/
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(!section){
        CarMaintainDetailHeaderView* maintainDetailView = [[CarMaintainDetailHeaderView alloc]init];;
        maintainDetailView.frame = CGRectMake(0, 0, kSizeOfScreen.width, TITILEHEADERVIEW_HEIGHT);
        return maintainDetailView;
    }else if(section < dataArray.count-1){
        
        //定义每组需要展开的标题的视图
        CWSCarMaintainInfoModel* model = dataArray[section-1];
        //底部view
        UIView* sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 44)];
        sectionView.backgroundColor = [UIColor orangeColor];
        
        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 1)];
        lineView.backgroundColor = KGrayColor3;
        [sectionView addSubview:lineView];
        
        //内容view
        CWSCarMaintainDetailContentView* contentView = [[CWSCarMaintainDetailContentView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), kSizeOfScreen.width, 43)];
        contentView.backgroundColor = [UIColor whiteColor];
        [contentView setThyModel:model];
        [sectionView addSubview:contentView];

        
        UIButton* selectSectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectSectionButton.frame = contentView.frame;
        selectSectionButton.tag = 200 + (section-1);
//        [selectSectionButton setTitle:@"" forState:UIControlStateNormal];
//        [selectSectionButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [selectSectionButton addTarget:self action:@selector(selectSectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:selectSectionButton];
        

        return sectionView;
    }else{
        
        CWSCarMaintainInfoModel* model = dataArray[section-1];
        UIView* sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 50)];
        sectionView.backgroundColor = [UIColor whiteColor];
        
        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, 16)];
        lineView.backgroundColor = KGrayColor3;
        [sectionView addSubview:lineView];
        
        UILabel* sectionNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame)+8, kSizeOfScreen.width, 15)];
        sectionNameLabel.font = [UIFont systemFontOfSize:17.0f];
        sectionNameLabel.text = model.sectionName;
        sectionNameLabel.textColor = [UIColor colorWithRed:0.220f green:0.706f blue:0.902f alpha:1.00f];
        sectionNameLabel.textAlignment = NSTextAlignmentLeft;
        [sectionView addSubview:sectionNameLabel];
        
        
//        UIView* lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, sectionView.frame.size.height-1, kSizeOfScreen.width, 1)];
//        lineView2.backgroundColor = [UIColor colorWithRed:0.910f green:0.910f blue:0.910f alpha:1.00f];
//        [sectionView addSubview:lineView2];
        
        return sectionView;
    }
}


/**设置section header的高度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(!section){
        return TITILEHEADERVIEW_HEIGHT;
    }else if(section < dataArray.count-1){
        return 44.0f;
    }else{
        return 50.0f;
    }
}


/**设置行高*/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat eachRowHeight = 30.0f;
    if(!indexPath.section){
        eachRowHeight = 0.0f;
    }
    
    if(indexPath.section == dataArray.count-1){
        eachRowHeight = 270.0f;
    }
    
    if(indexPath.section == dataArray.count){
        eachRowHeight = 64.0f;
    }
    
    return eachRowHeight;
}

/**设置footer的高度*/
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


#pragma mark -===============================================OtherCallBack
-(void)selectSectionButtonClicked:(UIButton*)sender{
    
    NSLog(@"selectedThySection!");
    
    CWSCarMaintainInfoModel* model = dataArray[sender.tag - 200];
    if(model.isShow){
        model.isShow = NO;
    }else{
        model.isShow = YES;
        if((sender.tag-200)==dataArray.count-1){
            
            myTableView.contentOffset = CGPointMake(0, CGRectGetMaxY(myTableView.frame)+model.realDataArray.count * 30.0f);
        }
    }
    
    [myTableView reloadSections:[NSIndexSet indexSetWithIndex:(sender.tag - 200+1)] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)comfimButtonClicked:(UIButton*)sender{
    alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height)];
    alertView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.view addSubview:alertView];
    
    alertViewContent = [[[NSBundle mainBundle]loadNibNamed:@"CWSCarMaintainComfirmAlertView" owner:self options:nil] lastObject];
    alertViewContent.delegate = self;
    alertViewContent.layer.masksToBounds = YES;
    alertViewContent.layer.cornerRadius = 5;
    alertViewContent.frame = CGRectMake(0, 0, kSizeOfScreen.width-60, 170);
    alertViewContent.center = CGPointMake(kSizeOfScreen.width/2, (kSizeOfScreen.height-kSTATUS_BAR-kDockHeight-kSTATUS_BAR)/2);
    [self.view addSubview:alertViewContent];
    
    
}

/**alertview回调方法*/
-(void)selectTableViewButtonClicked:(UIButton *)sender{

    if([sender.titleLabel.text isEqualToString:@"取消"]){
        [alertView removeFromSuperview];
        [alertViewContent removeFromSuperview];
        alertView = nil;
        alertViewContent = nil;
    }else if([sender.titleLabel.text isEqualToString:@"确定"]){
        NSLog(@"我要push确认订单!");
        [alertView removeFromSuperview];
        [alertViewContent removeFromSuperview];
        alertView = nil;
        alertViewContent = nil;
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
