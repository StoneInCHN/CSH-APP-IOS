//
//  TSLocateView.h
//  选着城市
//
//  Created by 李散 on 15/4/9.
//  Copyright (c) 2015年 Mr Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSLocation.h"
@interface TSLocateView : UIActionSheet<UIPickerViewDelegate, UIPickerViewDataSource> {
@private
    NSArray *provinces;
    NSArray	*cities;
}
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)save:(id)sender;
- (IBAction)cacel:(id)sender;
@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (strong, nonatomic) TSLocation *locate;
- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate;

- (void)showInView:(UIView *)view;
@end
