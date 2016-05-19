//
//  CWSFindParkSearchView.h
//  CarDefender
//
//  Created by 周子涵 on 15/7/31.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>


@protocol FindParkSearchViewDelegate <NSObject>
@optional
-(void)findParkSearchViewBtnClick:(int)tag;
//-(void)destinationClickWithCtiy:(NSString*)city Address:(NSString*)address;
-(void)destinationClickWithPt:(CLLocationCoordinate2D)pt City:(NSString*)city;
@end

@interface CWSFindParkSearchView : UIView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,BMKSuggestionSearchDelegate>
{
    NSMutableArray*             _dataArray;
    NSMutableArray*             _historyArray;    //历史记录数组
    UITableView*                _tableView;
    BMKSuggestionSearch*        _searcher;
    BMKSuggestionSearchOption*  _option;
}
@property (strong, nonatomic) UILabel*     normalLabel;       //搜索的值
@property (strong, nonatomic) UIImageView* headImageView;     //头部ImageView
@property (strong, nonatomic) UILabel*     headLabel;         //头部Label
@property (strong, nonatomic) UILabel*     headLeftLabel;     //返回Label
@property (strong, nonatomic) UIView*      normalSearchView;  //默认的搜索框
@property (strong, nonatomic) UIView*      searchView;        //搜索时的搜索框
@property (strong, nonatomic) UITextField* searchTextField;   //搜索TextField
@property (assign, nonatomic) id<FindParkSearchViewDelegate>delegate;
@end
