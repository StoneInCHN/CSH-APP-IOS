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
@end

@interface CWSFindParkSearchView : UIView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,BMKSuggestionSearchDelegate>
{
    NSArray*                    _dataArray;
    NSArray*                    _citysArray;
    NSArray*                    _districtArray;
    UITableView*                _tableView;
    BMKSuggestionSearch*        _searcher;
    BMKSuggestionSearchOption*  _option;
}
@property (strong, nonatomic) UIImageView* headImageView;     //头部ImageView
@property (strong, nonatomic) UILabel*     headLabel;         //头部Label
@property (strong, nonatomic) UIView*      normalSearchView;  //默认的搜索框
@property (strong, nonatomic) UIView*      searchView;        //搜索时的搜索框
@property (strong, nonatomic) UITextField* searchTextField;   //搜索TextField
@property (assign, nonatomic) id<FindParkSearchViewDelegate>delegate;
@end
