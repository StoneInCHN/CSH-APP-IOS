//
//  ChooseCarColorView.h
//  pickerView
//
//  Created by 李散 on 15/4/26.
//  Copyright (c) 2015年 Mr Li. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChooseCarColorViewDelegate <NSObject>

-(void)chooseCarColorWithColorTitle:(NSString*)colorString;
-(void)chooseCarColorViewTouch;
@end
@interface ChooseCarColorView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView*pickerVeiw;
    NSArray*pickerArray;
}
@property(nonatomic,retain)id<ChooseCarColorViewDelegate>delegate;
-(void)buildView;
@end
