//
//  CWSCarWashReviewViewController.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/11.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSCarWashReviewViewController.h"


#import "CWSCarWashDetailReviewModel.h"



#import "NewCarWashDetailReviewCell.h"


#define REVIEWCELL_HEIGHT_NOIMG 64.0f
#define REVIEWCELL_HEIGHT_IMG 114.0f

@interface CWSCarWashReviewViewController ()<UITableViewDataSource,UITableViewDelegate>{

    UITableView* myTableView;
    
    NSMutableArray* dataArray;
    NSMutableArray* eachRowHeightArray;
}

@end

@implementation CWSCarWashReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"全部评论";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
    [self initialData];
    [self createTableView];
}


#pragma mark -================================InitialData
-(void)initialData{
    if(!dataArray){
        dataArray = @[].mutableCopy;
        eachRowHeightArray = @[].mutableCopy;
    }
    
    [self loadData];
}

-(void)loadData{
    
    for(int i=0; i<20; i++){
        CWSCarWashDetailReviewModel* model = [CWSCarWashDetailReviewModel new];
        model.isHaveStarView = YES;
        model.isHaveImages = i % 2;
        model.userNickName = [NSString stringWithFormat:@"用户昵称%d",i+1];
        model.userReviewContent = [NSString stringWithFormat:@"用户评论%d",i+1];
       // model.userReviewStarCount = i % 2 ? 4.5f : 4.8f;
       // model.userReviewStarCount = (float)((arc4random() % 6) / 100); //0到5的随机小数
        model.userReviewStarCount = arc4random() % 6;

        model.reviewCellHeight = (model.isHaveImages ? REVIEWCELL_HEIGHT_IMG : REVIEWCELL_HEIGHT_NOIMG);
        [dataArray addObject:model];
    }
    
}


#pragma mark -================================CreateUI
-(void)createTableView{
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-kDockHeight) style:UITableViewStyleGrouped];
    myTableView.backgroundColor = KGrayColor3;
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.bounces = YES;
    myTableView.showsHorizontalScrollIndicator = NO;
    myTableView.showsVerticalScrollIndicator = NO;
    [myTableView registerNib:[UINib nibWithNibName:@"NewCarWashDetailReviewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DetailReviewCell"];
    [self.view addSubview:myTableView];
}




#pragma mark -================================TableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewCarWashDetailReviewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailReviewCell"];
    
    CWSCarWashDetailReviewModel* model = dataArray[indexPath.section];
    
    [cell setThyReviewModel:model];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark -================================TableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CWSCarWashDetailReviewModel* model = dataArray[indexPath.section];
    return model.reviewCellHeight;
}



@end
