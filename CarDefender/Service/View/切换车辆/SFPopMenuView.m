//
//  SFPopMenuView.m
//  SFPopMenuView
//
//  Created by sicnu_ifox on 16/6/1.
//  Copyright © 2016年 sicnu_ifox. All rights reserved.
//

#import "SFPopMenuView.h"
#import "SFTableViewDelegate.h"
#import "SFPopMenuViewManager.h"

@interface SFPopMenuView()

@property (nonatomic, strong) SFTableViewDelegate   *tableViewDelegate;

@end
@implementation SFPopMenuView
- (instancetype)init {
    if ([super init]) {
        
    }
    return  self;
}
- (instancetype)initWithContentFrame:(CGRect)frame
                        items:(NSArray *)items
                  didSelected:(void (^)(NSInteger))didSelectd {
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    if (self = [super initWithFrame:window.frame]) {
        self.items = items;
        self.didSelectd = [didSelectd copy];
        
        self.tableViewDelegate = [[SFTableViewDelegate alloc] initWithDidSelectedRowAtIndexPath:^(NSInteger indexRow) {
            if (self.didSelectd) {
                self.didSelectd(indexRow);
            }
        }];
        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self.tableViewDelegate;
        self.tableView.layer.cornerRadius = 5.0f;
        self.tableView.layer.anchorPoint = CGPointMake(1.0, 0);
        self.tableView.rowHeight = 40;
        [self addSubview:self.tableView];
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return self;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[SFPopMenuViewManager manager] remove];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentify = @"popCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    
    cell.textLabel.text = _items[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}
@end
