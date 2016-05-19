//
//  TSLocateView.m
//  选着城市
//
//  Created by 李散 on 15/4/9.
//  Copyright (c) 2015年 Mr Li. All rights reserved.
//

#import "TSLocateView.h"

#define kDuration 0.3
@implementation TSLocateView
- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"TSLocateView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        
        //加载数据
        provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]];
        [Utils setViewRiders:self.cancelBtn riders:4];
        [Utils setViewRiders:self.sureBtn riders:4];
        [Utils setBianKuang:kMainColor Wide:1 view:self.cancelBtn];
        [Utils setBianKuang:kMainColor Wide:1 view:self.sureBtn];
        //初始化默认数据
        self.locate = [[TSLocation alloc] init];
        self.locate.state = [[[provinces objectAtIndex:0] allKeys] objectAtIndex:0];
        self.locate.city = [[[provinces objectAtIndex:0] objectForKey:@"正式车牌"] objectAtIndex:0];
    }
    return self;
}

- (void)showInView:(UIView *) view
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDLocateView"];
    
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    [view addSubview:self];
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [provinces count];
            break;
        case 1:
            return [[[provinces objectAtIndex:0] objectForKey:@"正式车牌"] count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0://[[provinces objectAtIndex:row] objectForKey:@"State"]
            return [[[provinces objectAtIndex:row] allKeys] objectAtIndex:0];
            break;
        case 1://[[cities objectAtIndex:row] objectForKey:@"city"]
            return [[[provinces objectAtIndex:0] objectForKey:@"正式车牌"] objectAtIndex:row];
            break;
        default:
            return nil;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            cities = [[provinces objectAtIndex:row] objectForKey:@"Cities"];
            [self.locatePicker selectRow:0 inComponent:1 animated:NO];
            [self.locatePicker reloadComponent:1];
            
            self.locate.state = [[[provinces objectAtIndex:row] allKeys] objectAtIndex:0];
            self.locate.city = [[[provinces objectAtIndex:0] objectForKey:@"正式车牌"] objectAtIndex:0];
            break;
        case 1:
            self.locate.city = [[[provinces objectAtIndex:0] objectForKey:@"正式车牌"] objectAtIndex:row];
            break;
        default:
            break;
    }
}
#pragma mark - Button lifecycle
- (IBAction)cacel:(id)sender {
//    [self removeFromSuperview];
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];

}
- (IBAction)save:(id)sender {
    
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:1];
    }
}

@end
