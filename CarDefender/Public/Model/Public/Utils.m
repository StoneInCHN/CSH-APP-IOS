//
//  Utils.m
//  CarDefender
//
//  Created by 周子涵 on 15/7/2.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "Utils.h"
#import <BaiduMapAPI/BMapKit.h>

@implementation Utils
#pragma mark - 控件快速创建 ------------------------------------------------ 控件快速创建
+ (UILabel *)labelWithOrigin:(CGPoint)point withHeight:(CGFloat)height withTitle:(NSString *)title titleFontSize:(UIFont *)font textColor:(UIColor *)color backgroundColor:(UIColor *)bgColor alignment:(NSTextAlignment)textAlignment hidden:(BOOL)yOrN{
    CGSize size = [Utils takeTheSizeOfString:title withFont:font];
    UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(point.x, point.y, size.width, height)];
    label.text = title;
    label.font = font;
    label.textColor = color;
    label.backgroundColor = bgColor;
    label.textAlignment = textAlignment;
    label.hidden = yOrN;
    return label;
}
+ (UILabel *)labelWithFrame:(CGRect)frame withTitle:(NSString *)title titleFontSize:(UIFont *)font textColor:(UIColor *)color alignment:(NSTextAlignment)textAlignment{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.font = font;
    label.textColor = color;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = textAlignment;
    label.hidden=NO;
    return label;
}
#pragma mark - 设置控件 ---------------------------------------------------------- 设置控件



#pragma mark - 获取数据 ---------------------------------------------------------- 获取数据


//获取当前时间并保存在数组里面
+(NSArray*)getTime
{
    NSDate *now = [NSDate date];
    MyLog(@"%@",now);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int year = (int)[dateComponent year];
    NSString*year1=[NSString stringWithFormat:@"%d",year];
    int month = (int)[dateComponent month];
    NSString*month1;
    if (month<9) {
        month1=[NSString stringWithFormat:@"0%d",month];
    }else{
        month1=[NSString stringWithFormat:@"%d",month];
    }
    int day = (int)[dateComponent day];
    NSString*day1;
    if (day<9) {
        day1=[NSString stringWithFormat:@"0%d",day];
    }else{
        day1=[NSString stringWithFormat:@"%d",day];
    }
    int hour = (int)[dateComponent hour];
    NSString*hour1=[NSString stringWithFormat:@"%d",hour];
    int minute = (int)[dateComponent minute];
    NSString*minute1=[NSString stringWithFormat:@"%d",minute];
    int second = (int)[dateComponent second];
    NSString*second1=[NSString stringWithFormat:@"%d",second];
    NSArray*array=@[year1,month1,day1,hour1,minute1,second1];
    return array;
}
// 获取两坐标之间的距离
+(CLLocationDistance)getMetersBefore:(CLLocation *)before Current:(CLLocation*)current
{
    CLLocationDistance meters=[current distanceFromLocation:before];
    return meters;
}
//获取deviceToken
+(NSString*)deviceTokenBack
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString*token;
    if ([userDefaults objectForKey:@"deviceToken"]!=nil) {
        NSString*string1 = [NSString stringWithString:[userDefaults objectForKey:@"deviceToken"]];
        token=string1;
    }else{//1489aa4723c9e13c7cc18cd9a1acb0ba9f55582529cb522a12c4b59a183edd4e
        token=@"no_device_token";
    }
    return token;
}

//获取设备信息。软件版本信息。设备硬件信息
+(NSArray*)getModelOrAppMsg
{
    NSArray*msgArray;
    
    NSString*phoneOs=[[UIDevice currentDevice] systemVersion];//手机系统
    
    NSString*phoneSystem=[self correspondVersion];//手机设备硬件信息
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];//app版本
    
    msgArray = [NSArray arrayWithObjects:phoneOs,phoneSystem,app_Version, nil];
    
    return msgArray;
}

//获取设备信息。软件版本信息。设备硬件信息
+(NSDictionary*)getPhoneSystemInfo{
    
    NSString* phoneOs=[[UIDevice currentDevice] systemVersion];//手机系统
    
    NSString* phoneSystem=[self correspondVersion];//手机设备硬件信息
    
    NSString* app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];//app版本
    
    return @{@"appVersion":app_Version,@"mobileVersion":phoneSystem,@"mobileSystem":phoneOs};
}


// 获取当前时间
+(NSString*)getStartTime:(NSString*)startTime currentTime:(NSString*)currentTime{
    
    long dd = [self getTimeDifference:startTime currentTime:currentTime];
    
    long hours = 0;
    long minute = 0;
    long second = 0;
    if (dd >= 3600) {
        hours = dd/3600;
    }
    if (dd%3600 >= 60) {
        minute = dd%3600/60;
    }
    second = dd%3600%60;
    NSString* timeStr = [NSString stringWithFormat:@"%02li:%02li:%02li",hours,minute,second];
    return timeStr;
}

#pragma mark - 判断数据 ---------------------------------------------------------- 判断数据

//判断是否为标准Email格式
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//手机号码验证
+(BOOL)isValidateMobile:(NSString *)mobile
{
    NSString *phoneRegex = @"^(1[34578])\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
//座机号码验证
+(BOOL)isValidateTellphone:(NSString *)tellphone
{
    NSString *phoneRegex = @"^0\\d{2,3}\\d{7,8}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:tellphone];
}
//是否是纯数字
+ (BOOL)isNumText:(NSString *)str{
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(str.length > 0)
    {//不是数字
        return NO;
    }
    else
    {//都是数字
        return YES;
    }
}
// 正则表达式判断密码是否符合标准
+(BOOL)zhengZhe:(NSString*)string
{
    [NSCharacterSet decimalDigitCharacterSet];
    if ([string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length>0) {
        NSString * regex = @"^[A-Za-z]{6,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:string];
        if (isMatch) {//纯字母
            return NO;
        }else{
            NSString * regex = @"^[A-Za-z0-9]{6,16}$";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            BOOL isMatch = [pred evaluateWithObject:string];
            if (isMatch) {//合法
                return YES;
            }else{//含有不能识别的字符
                return NO;
            }
        }
    }else{//纯数字
        return NO;
    }
    return NO;
}
//检查是否是字母和数字
+(BOOL)checkNubOrLetter:(NSString*)lStr
{
    NSString * regex = @"^[A-Za-z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [predicate evaluateWithObject:lStr];
    
    if (isMatch == YES) {
        return YES;
    }else{
        return NO;
    }
}
// 判断是否含有表情，yes为含有
+(BOOL)isContainsEmoji:(NSString *)string {
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const NSInteger uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    return isEomji;
}
//// 判断手机号码是否含有空格、+86、17951、横线、等情况
//+(NSString*)checkPhoneNubAndRemoveIllegalCharacters:(NSString *)phoneNub
//{
//    NSString*legalPhone = [phoneNub stringByReplacingOccurrencesOfString:@" " withString:@""];
//    legalPhone = [legalPhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
//    legalPhone = [legalPhone stringByReplacingOccurrencesOfString:@")" withString:@""];
//    legalPhone = [legalPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    legalPhone = [legalPhone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
//    legalPhone = [legalPhone stringByReplacingOccurrencesOfString:@"17951" withString:@""];
//
//    return legalPhone;
//}

#pragma mark - 数据转换  --------------------------------------------------------- 数据转换

//获取修改时间
+(long)getTimeDifference:(NSString*)startTime currentTime:(NSString*)currentTime{
    NSMutableString *datestring1 = [NSMutableString stringWithFormat:@"%@",startTime];
    
    NSDateFormatter * dm1 = [[NSDateFormatter alloc]init];
    //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
    [dm1 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate * newdate = [dm1 dateFromString:datestring1];
    
    NSMutableString *datestring2 = [NSMutableString stringWithFormat:@"%@",currentTime];
    
    NSDateFormatter * dm2 = [[NSDateFormatter alloc]init];
    //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
    [dm2 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate * datenow = [dm2 dateFromString:datestring2];
    
    long dd = (long)[datenow timeIntervalSinceNow] - [newdate timeIntervalSinceNow];
    return dd;
}


+(CGSize)strSize:(NSString *)currentString withMaxSize:(CGSize)maxSize withFont:(UIFont *)font withLineBreakMode:(NSLineBreakMode)mode{
    
    CGSize adaptSize;
    adaptSize = (IOS7 ? [currentString boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size : [currentString sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode]);
    return adaptSize;
}

#pragma mark - 其他  ------------------------------------------------------------ 其他


#pragma mark - 私有方法  --------------------------------------------------------- 私有方法

//获取设备信息。软件版本信息。设备硬件信息
+(NSString *)correspondVersion
{
    NSString  *correspondVersion=[[UIDevice currentDevice]model];
    //    NSString *correspondVersion = [self getDeviceVersionInfo];
    
    if ([correspondVersion isEqualToString:@"i386"])        return@"Simulator";
    if ([correspondVersion isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([correspondVersion isEqualToString:@"iPhone1,1"])   return@"iPhone 1";
    if ([correspondVersion isEqualToString:@"iPhone1,2"])   return@"iPhone 3";
    if ([correspondVersion isEqualToString:@"iPhone2,1"])   return@"iPhone 3S";
    if ([correspondVersion isEqualToString:@"iPhone3,1"] || [correspondVersion isEqualToString:@"iPhone3,2"])   return@"iPhone 4";
    if ([correspondVersion isEqualToString:@"iPhone4,1"])   return@"iPhone 4S";
    if ([correspondVersion isEqualToString:@"iPhone5,1"] || [correspondVersion isEqualToString:@"iPhone5,2"])   return @"iPhone 5";
    if ([correspondVersion isEqualToString:@"iPhone5,3"] || [correspondVersion isEqualToString:@"iPhone5,4"])   return @"iPhone 5C";
    if ([correspondVersion isEqualToString:@"iPhone6,1"] || [correspondVersion isEqualToString:@"iPhone6,2"])   return @"iPhone 5S";
    
    if ([correspondVersion isEqualToString:@"iPod1,1"])     return@"iPod Touch 1";
    if ([correspondVersion isEqualToString:@"iPod2,1"])     return@"iPod Touch 2";
    if ([correspondVersion isEqualToString:@"iPod3,1"])     return@"iPod Touch 3";
    if ([correspondVersion isEqualToString:@"iPod4,1"])     return@"iPod Touch 4";
    if ([correspondVersion isEqualToString:@"iPod5,1"])     return@"iPod Touch 5";
    
    if ([correspondVersion isEqualToString:@"iPad1,1"])     return@"iPad 1";
    if ([correspondVersion isEqualToString:@"iPad2,1"] || [correspondVersion isEqualToString:@"iPad2,2"] || [correspondVersion isEqualToString:@"iPad2,3"] || [correspondVersion isEqualToString:@"iPad2,4"])     return@"iPad 2";
    if ([correspondVersion isEqualToString:@"iPad2,5"] || [correspondVersion isEqualToString:@"iPad2,6"] || [correspondVersion isEqualToString:@"iPad2,7"] )      return @"iPad Mini";
    if ([correspondVersion isEqualToString:@"iPad3,1"] || [correspondVersion isEqualToString:@"iPad3,2"] || [correspondVersion isEqualToString:@"iPad3,3"] || [correspondVersion isEqualToString:@"iPad3,4"] || [correspondVersion isEqualToString:@"iPad3,5"] || [correspondVersion isEqualToString:@"iPad3,6"])      return @"iPad 3";
    
    return correspondVersion;
}
//通过颜色来生成一个纯色图片
+(UIImage *)creatImageFromColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 10, 10);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}

+ (void)chargeNetWork

{
    
    NSURL *baseURL = [NSURL URLWithString:@"http://www.baidu.com/"];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        static AFNetworkReachabilityStatus lastStatus = AFNetworkReachabilityStatusReachableViaWiFi;
        
        switch (status) {
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
                [operationQueue setSuspended:NO];
                
                if ( lastStatus == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                    return;
                }
                else if (lastStatus == -1){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未知网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                return;
            }
            default:
                
                [operationQueue setSuspended:YES];
                
                if (lastStatus == 1 || lastStatus == 2) {
                    
                }
                
                break;
                
        }
        
        lastStatus = status;
        
    }];
    
    
    //        BOOL isExistenceNetwork = YES;
    //        Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    //        switch ([reach currentReachabilityStatus]) {
    //            case NotReachable:
    //            {
    //                isExistenceNetwork = NO;
    //
    //                NSLog(@"notReachable");
    //
    //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    //                [alert show];
    //            }
    //                break;
    //            case ReachableViaWiFi:
    //                isExistenceNetwork = YES;
    //                NSLog(@"WIFI");
    //                break;
    //            case ReachableViaWWAN:
    //                isExistenceNetwork = YES;
    //                NSLog(@"3G");
    //                break;
    //        }
    
    
}


@end
