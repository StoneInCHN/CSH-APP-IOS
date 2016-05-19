//
//  CWSServiceUIView.h
//  carLife
//
//  Created by 王泰莅 on 15/12/2.
//  Copyright © 2015年 王泰莅. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CWSMainViewController;

@interface CWSServiceUIView : UIView



@property (nonatomic,strong)CWSMainViewController* thyRootVc;

@property (nonatomic,strong) NSString* thyCityLocate; //定位的城市

@end
