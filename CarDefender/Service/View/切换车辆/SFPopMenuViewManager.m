//
//  SFPopMenuViewManager.m
//  SFPopMenuView
//
//  Created by sicnu_ifox on 16/6/1.
//  Copyright © 2016年 sicnu_ifox. All rights reserved.
//

#import "SFPopMenuViewManager.h"
#import "SFPopMenuView.h"

@interface SFPopMenuViewManager()
@property (nonatomic, strong) SFPopMenuView *popMenuView;
@end

@implementation SFPopMenuViewManager

+ (instancetype)manager {
    static SFPopMenuViewManager *popMenuManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        popMenuManager = [[SFPopMenuViewManager alloc] init];
    });
    return popMenuManager;
}

- (void)showPopMenuViewWithFrame:(CGRect)frame
                            item:(NSArray *)item
                     didSelected:(void (^)(NSInteger))didSelected {
    
    __weak __typeof(&*self)weakSelf = self;
    if (self.popMenuView != nil) {
        [weakSelf remove];
    }
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    self.popMenuView = [[SFPopMenuView alloc] initWithContentFrame:frame
                                                      items:item
                                                didSelected:^(NSInteger index) {
                                                    didSelected(index);
                                                    [weakSelf remove];
                                                }];
    
    self.popMenuView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [window addSubview:self.popMenuView];
    [UIView animateWithDuration:0.3 animations:^{
        self.popMenuView.tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];

}
- (void)remove {
    [UIView animateWithDuration:0.2 animations:^{
        [self.popMenuView.tableView removeFromSuperview];
        [self.popMenuView removeFromSuperview];
        self.popMenuView.tableView = nil;
        self.popMenuView = nil;
    }];
}
@end
