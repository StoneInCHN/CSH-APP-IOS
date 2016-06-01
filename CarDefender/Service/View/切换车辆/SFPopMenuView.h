//
//  SFPopMenuView.h
//  SFPopMenuView
//
//  Created by sicnu_ifox on 16/6/1.
//  Copyright © 2016年 sicnu_ifox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFPopMenuView : UIView <UITableViewDataSource>

@property (nonatomic, copy) void(^didSelectd)(NSInteger index);
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UITableView *tableView;

- (instancetype)initWithContentFrame:(CGRect)frame
                        items:(NSArray *)items
                  didSelected:(void (^)(NSInteger index))didSelectd;

@end
