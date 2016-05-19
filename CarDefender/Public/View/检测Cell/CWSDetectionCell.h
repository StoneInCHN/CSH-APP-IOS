//
//  CWSDetectionCell.h
//  CarDefender
//
//  Created by 李散 on 15/6/29.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetectionCellDelegate <NSObject>
@optional
-(void)detectionCellClick:(NSDictionary*)dicMsg;
@end

@interface CWSDetectionCell : UITableViewCell
@property (assign, nonatomic) int mark;
@property (strong, nonatomic) NSDictionary *dicMsg;
@property (strong, nonatomic) NSArray *dicMsg1;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *markView;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailMsgLabel;

@property (assign, nonatomic) id<DetectionCellDelegate> delegate;

- (IBAction)markBtnClick;
-(void)reloadData:(NSDictionary*)dicMsg;
@end
