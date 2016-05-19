//
//  CWSAdView.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/15.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWSAdViewDelegate.h"

@interface CWSAdView : UIView<UIScrollViewDelegate>

@property (nonatomic,strong) id<CWSAdViewDelegate> delegate;
@property (nonatomic,strong) NSArray* adImagesDataArray;


@end
