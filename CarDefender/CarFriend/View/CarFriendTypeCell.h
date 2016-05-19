//
//  CarFriendTypeCell.h
//  CarDefender
//
//  Created by 李散 on 15/5/13.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarFriendTypeCell : UITableViewCell
@property(strong,nonatomic)NSDictionary*typeDic;
+ (CGFloat)heightForCellWithContentForCellDict:(NSDictionary*)typeDic;
@end
