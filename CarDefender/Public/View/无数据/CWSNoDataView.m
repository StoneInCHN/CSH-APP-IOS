//
//  CWSNoDataView.m
//  CarDefender
//
//  Created by 周子涵 on 15/7/9.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSNoDataView.h"

@implementation CWSNoDataView{

    
}


#warning =================================不同的控制器、提示不同
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.noDataImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 83, 90)];
        self.noDataImageView.image = [UIImage imageNamed:@"dingdanwu_icon"];
        self.noDataImageView.center = CGPointMake(frame.size.width/2, frame.size.height/2 - 117);
        [self addSubview:self.noDataImageView];
        
        self.noDataTitleLabel = [Utils labelWithFrame:CGRectMake(0, 0, frame.size.width, 15) withTitle:@"没有符合条件的记录" titleFontSize:kFontOfSize(15) textColor:[UIColor darkGrayColor] alignment:NSTextAlignmentCenter];
        self.noDataTitleLabel.center = CGPointMake(frame.size.width/2, self.noDataImageView.frame.origin.y + self.noDataImageView.frame.size.height + 27);
        self.noDataTitleLabel.textColor = [UIColor colorWithRed:0.733f green:0.733f blue:0.733f alpha:1.00f];
        [self addSubview:self.noDataTitleLabel];
        
        
    }
    return self;
}






@end
