//
//  SFPopMenuViewManager.h
//  SFPopMenuView
//
//  Created by sicnu_ifox on 16/6/1.
//  Copyright © 2016年 sicnu_ifox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SFPopMenuView;

@interface SFPopMenuViewManager : NSObject

+ (instancetype)manager;
- (void)showPopMenuViewWithFrame:(CGRect)frame
                            item:(NSArray *)item
                     didSelected:(void(^)(NSInteger index))didSelected;
- (void)remove;

@end
