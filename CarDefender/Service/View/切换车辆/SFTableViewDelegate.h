//
//  SFTableViewDelegate.h
//  SFPopMenuView
//
//  Created by sicnu_ifox on 16/6/1.
//  Copyright © 2016年 sicnu_ifox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef  void(^TableViewDidSelectedRowAtIndexPath)(NSInteger indexRow);

@interface SFTableViewDelegate : NSObject <UITableViewDelegate>
- (instancetype)initWithDidSelectedRowAtIndexPath:(TableViewDidSelectedRowAtIndexPath)tableViewDidSelectedRowAtIndexPath;

@end
