//
//  SFTableViewDelegate.m
//  SFPopMenuView
//
//  Created by sicnu_ifox on 16/6/1.
//  Copyright © 2016年 sicnu_ifox. All rights reserved.
//

#import "SFTableViewDelegate.h"
@interface SFTableViewDelegate()
@property (nonatomic,copy) TableViewDidSelectedRowAtIndexPath tableViewDidSelectedRowAtIndexPath;
@end

@implementation SFTableViewDelegate

- (instancetype)initWithDidSelectedRowAtIndexPath:(TableViewDidSelectedRowAtIndexPath)tableViewDidSelectedRowAtIndexPath {
    
    self = [super init];
    if (self) {
        self.tableViewDidSelectedRowAtIndexPath = [tableViewDidSelectedRowAtIndexPath copy];
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.tableViewDidSelectedRowAtIndexPath) {
        self.tableViewDidSelectedRowAtIndexPath(indexPath.row);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
