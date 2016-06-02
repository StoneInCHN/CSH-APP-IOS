//
//  PublicUtils.m
//  CarDefender
//
//  Created by 周子涵 on 15/7/2.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "PublicUtils.h"

@implementation PublicUtils
#pragma mark - 控件快速创建 ------------------------------------------------------- 控件快速创建
// 快速创建imageview
+(UIImageView *)imageViewWithFrame:(CGRect)frame withImage:(UIImage *)image{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    return imageView;
}
//快速创建uilabel
+ (UILabel *)labelWithFrame:(CGRect)frame withTitle:(NSString *)title titleFontSize:(UIFont *)font textColor:(UIColor *)color backgroundColor:(UIColor *)bgColor alignment:(NSTextAlignment)textAlignment hidden:(BOOL)yOrN{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.font = font;
    label.textColor = color;
    label.backgroundColor = bgColor;
    label.textAlignment = textAlignment;
    label.hidden=yOrN;
    return label;
}
//快速创建按钮
+(UIButton *)buttonWithFrame:(CGRect)btnFrame title:(NSString*)title titleColor:(UIColor*)titleColor font:(UIFont*)font{
    UIButton *btn=[[UIButton alloc]initWithFrame:btnFrame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font=font;
    return btn;
}
//将View转换成UIImage
+(UIImage*)imageFromView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
#pragma mark - 设置控件 ---------------------------------------------------------- 设置控件

// 设置边框
+(void)setBianKuang:(UIColor *)coler Wide:(CGFloat)wide view:(UIView *)view
{
    view.layer.borderColor = [coler CGColor];
    view.layer.borderWidth = wide;
}
// 设置弧度
+(void)setViewRiders:(UIView *)view riders:(CGFloat)riders
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = riders;
}
//当前试图中得按钮只可以点击一次
+(void)viewsBtnTouchOnceWithView:(UIView*)view
{
    MyLog(@"%@",view);
    for (UIView*view1 in view.subviews) {
        if ([view1 isKindOfClass:[UIButton class]]) {
            [view1 setExclusiveTouch:YES];
            MyLog(@"%@",view);
        }
    }
}
#pragma mark - 获取数据 ---------------------------------------------------------- 获取数据
// 计算字符串尺寸return 返回此存
+(CGSize)takeTheSizeOfString:(NSString*)string withFont:(UIFont*)font{
    CGSize stringOfSize=[string boundingRectWithSize:CGSizeMake(275, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
    return stringOfSize;
}
//固定宽度
+(CGSize)takeTheSizeOfString:(NSString*)string withFont:(UIFont*)font withWeight:(CGFloat)weight
{
    CGSize stringOfSize=[string boundingRectWithSize:CGSizeMake(weight, 1000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
    return stringOfSize;
}

#pragma mark - 判断数据 ---------------------------------------------------------- 判断数据
// 判断手机号码是否含有空格、+86、17951、横线、等情况
+(NSString*)checkPhoneNubAndRemoveIllegalCharacters:(NSString *)phoneNub
{
    NSString*legalPhone = [phoneNub stringByReplacingOccurrencesOfString:@" " withString:@""];
    legalPhone = [legalPhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    legalPhone = [legalPhone stringByReplacingOccurrencesOfString:@")" withString:@""];
    legalPhone = [legalPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    legalPhone = [legalPhone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    legalPhone = [legalPhone stringByReplacingOccurrencesOfString:@"17951" withString:@""];
    
    return legalPhone;
}
#pragma mark - 数据转换 ---------------------------------------------------------- 数据转换

//把null转换成@“”
+(NSString*)checkNSNullWithgetString:(NSObject*)lStr
{
    if (lStr == nil || [lStr isKindOfClass:[NSNull class]]) {
        return @"";
    }else{
        if ([lStr isEqual:@"null"]) {
            return @"0";
        }else
            return [NSString stringWithFormat:@"%@",lStr];
    }
}

#pragma mark - 转换时间戳  ----------------------------------------------------- 其他
+(NSString *)conversionTimeStamp:(NSString*)lStr{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd HH:MM"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[lStr doubleValue]/1000.0];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}
#pragma mark - 其他 ------------------------------------------------------------- 其他
// AppDelegate
+ (AppDelegate *)applicationDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
//设置导航栏返回键
+(void)changeBackBarButtonStyle:(UIViewController*)sender
{
    sender.navigationController.navigationBar.barStyle=UIStatusBarStyleDefault;
    sender.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [sender.navigationController.navigationBar setTintColor:[UIColor colorWithRed:119/255.0 green:119/255.0 blue:119/255.0 alpha:1]];
    sender.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    sender.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    sender.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                               initWithTitle:@"返回"
                                               style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(backBarButtonItemClick)];
    sender.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: KBlackMainColor,UITextAttributeFont : [UIFont systemFontOfSize:18]};
    
}

+(void)changeBackBarButtonStyle:(UIViewController *)sender andClickedMethod:(SEL)callBack{
    sender.navigationController.navigationBar.barStyle=UIStatusBarStyleDefault;
    sender.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [sender.navigationController.navigationBar setTintColor:[UIColor colorWithRed:119/255.0 green:119/255.0 blue:119/255.0 alpha:1]];
    sender.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    sender.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    sender.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                               initWithTitle:@"返回"
                                               style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(backRootViewControllerClick)];
    sender.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: KBlackMainColor,UITextAttributeFont : [UIFont systemFontOfSize:18]};
}

- (void)backBarButtonItemClick
{
    [[UIApplication sharedApplication].keyWindow.rootViewController.navigationController popViewControllerAnimated:YES];
}

-(void)backRootViewControllerClick{
    [[UIApplication sharedApplication].keyWindow.rootViewController.navigationController popToRootViewControllerAnimated:YES];
}

+(NSString*)showServiceReturnMessage:(NSString*)message{
    NSString* result;
    for(int i=0; i<message.length; i++){
        if([message characterAtIndex:i] < 48 || [message characterAtIndex:i] > 57){
            if(!i){
                result = message;
            }else{
                result = [message substringWithRange:NSMakeRange(i+1, message.length-i-1)];
            }
            break;
        }
    }
    return result;
}

/**
 *  判断多关键字符合与否
 */
+(BOOL)isMatchOneOfStringWithObject:(NSDictionary*)object andKey:(NSString*)key andRangeOfString:(NSString*)rangeOfString{
    NSArray* stringArray = [rangeOfString componentsSeparatedByString:@","];
    for (NSString* str in stringArray) {
        if([[object valueForKey:key] rangeOfString:str].location != NSNotFound){
            return YES;
        }
    }
    return NO;
}
@end
