//
//  DetectionView.h
//  yijianjiance
//
//  Created by 周子涵 on 15/6/23.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetectionDefaultView.h"
#import "DetectingView.h"
#import "DetectionEndView.h"

@protocol DetectionDelegate <NSObject>
@optional
-(void)detectionBtnClick:(int)type dic:(NSDictionary*)dataDic;
-(void)noStart:(int)type;
@end

@interface DetectionView : UIView<DetectionDefaultDelegate,DetectingDelegate,DetectionEndDelegate>
{
    DetectionDefaultView*   _detectionDefaultView;    //默认View
    DetectingView*          _detectingView;           //检测中View
    DetectionEndView*       _detectionEndView;        //检测结束界面
}
@property (assign, nonatomic) id<DetectionDelegate> delegate;            //代理协议
@end
