//
//  CWSQueryResultCellCell.h
//  LHPTextDemo
//
//  Created by 李散 on 15/6/30.
//  Copyright (c) 2015年 Mr Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSQueryResultCellCell : UITableViewCell
@property(strong,nonatomic)NSDictionary*typeDic;
+ (CGFloat)heightForCellWithContentForCellDict:(NSDictionary*)typeDic;
@end
