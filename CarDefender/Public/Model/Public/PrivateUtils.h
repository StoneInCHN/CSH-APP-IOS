//
//  PrivateUtils.h
//  CarDefender
//
//  Created by 周子涵 on 15/6/16.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "Utils.h"

@interface PrivateUtils : Utils
#pragma mark - 控件快速创建 ------------------------------------------------ 控件快速创建
/**
 *  快速创建uilabel
 *
 *  @param frame         frame值
 *  @param title         标题
 *  @param font          字体
 *  @param color         颜色
 *  @param bgColor       背景颜色
 *  @param textAlignment 位置（靠左、靠右、居中）
 *
 *  @return 返回uilabel
 */
+ (UILabel *)labelWithOrigin:(CGPoint)point withHeight:(CGFloat)height withTitle:(NSString *)title titleFontSize:(UIFont *)font textColor:(UIColor *)color backgroundColor:(UIColor *)bgColor alignment:(NSTextAlignment)textAlignment hidden:(BOOL)yOrN;
+ (UILabel *)labelWithFrame:(CGRect)frame withTitle:(NSString *)title titleFontSize:(UIFont *)font textColor:(UIColor *)color alignment:(NSTextAlignment)textAlignment;
#pragma mark - 设置控件 ----------------------------------------------------- 设置控件


#pragma mark - 获取数据 ----------------------------------------------------- 获取数据

/**
 *  获取当前时间并保存在数组里面
 */
+(NSArray*)getTime;
/**
 *  获取当前时间
 */
+(NSString*)getStartTime:(NSString*)startTime currentTime:(NSString*)currentTime;
/**
 *  获取两个坐标之间的距离
 */
+(CLLocationDistance)getMetersBefore:(CLLocation *)before Current:(CLLocation*)current;
/**
 *  返回deviceToken
 */
+(NSString*)deviceTokenBack;
/**
 *  获取设备信息。软件版本信息。设备硬件信息
 */
+(NSArray*)getModelOrAppMsg;

#pragma mark - 判断数据 ----------------------------------------------------- 判断数据
/**
 *  判断是否为标准Email格式
 *
 *  @param email Email字符串
 *
 *  @return 正确返回1反之返回0
 */
+(BOOL)isValidateEmail:(NSString *)email;
/**
 *  手机号码验证
 *
 *  @param mobile 手机号码
 *
 *  @return 正确返回1反之返回0
 */
+(BOOL)isValidateMobile:(NSString *)mobile;
/**
 *  座机号码验证
 *
 *  @param tellphone 座机号码
 *
 *  @return 正确返回1反之返回0
 */
+(BOOL)isValidateTellphone:(NSString *)tellphone;
/**
 *  判断是否是纯数字
 *
 *  @param str 传入的字符串
 *
 *  @return 返回yes为纯数字反之为no
 */
+ (BOOL)isNumText:(NSString *)str;
/**
 *  判断密码是否符合要求
 *
 *  @param string 传入要检测的字符串
 */
+(BOOL)zhengZhe:(NSString*)string;
/**
 *  检查是否是字母和数字
 */
+(BOOL)checkNubOrLetter:(NSString*)lStr;
/**
 *  判断是否含有表情，yes为含有
 */
+(BOOL)isContainsEmoji:(NSString *)string;
///**
// *  判断手机号码是否含有空格、+86、17951、横线、等情况
// */
//+(NSString*)checkPhoneNubAndRemoveIllegalCharacters:(NSString *)phoneNub;


#pragma mark - 数据转换  -------------------------------------------------------- 数据转换

/**
 *  获取修改时间
 */
+(long)getTimeDifference:(NSString*)startTime currentTime:(NSString*)currentTime;


#pragma mark - 其他  ------------------------------------------------------------ 其他

//通过颜色来生成一个纯色图片
+(UIImage *)creatImageFromColor:(UIColor *)color;
@end
