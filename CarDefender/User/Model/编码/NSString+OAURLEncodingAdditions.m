//
//  NSString+OAURLEncodingAdditions.m
//  HEICHE
//
//  Created by mac on 14-6-30.
//  Copyright (c) 2014年 farawei. All rights reserved.
//

#import "NSString+OAURLEncodingAdditions.h"

@implementation NSString (OAURLEncodingAdditions)

- (NSString *)qudiaodianN
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)self,
                                                                   NULL,
                                                                   CFSTR("\n"),
                                                                                             kCFStringEncodingUTF8));
    return result;
}

- (NSString *)URLEncodedString{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                            (CFStringRef)self,
                                                            NULL,
                                                            CFSTR("!*'();:@&=+$,/?%#[]"),
                                                            kCFStringEncodingUTF8));
    return result;
}


- (NSString*)URLDecodedString{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                           (CFStringRef)self,
                                                                                           CFSTR(""),
                                                                                           kCFStringEncodingUTF8));
    return result;
}


- (NSString *)replaceUnicode
{
    NSString *body = self;
    NSMutableString *mutableStr = [[NSMutableString alloc] initWithCapacity:1];
    NSScanner*scanner=[NSScanner scannerWithString:body];
    [scanner setCaseSensitive:YES]; // yes 区分大小写
    NSString *keyString01 = @"%";
    
    int lastPos = 0;  int pos = 0;
    
    while (lastPos < body.length) {
        pos = [self indexOf:body andPre:keyString01 andStartLocation:lastPos];
        
        if (pos == lastPos) {
            // 转为unicode 编码 再解码
            if ([body characterAtIndex:(pos + 1)] == 'u') {
                NSRange range = NSMakeRange(pos, 6);
                NSString *tempBody =[body substringWithRange:range];
                NSString *temp01 = [tempBody stringByReplacingOccurrencesOfString:@"%" withString:@"\\"];
                NSString *temp02 = [self replaceUnicode:temp01]; // 转为中文
                //                NSLog(@"--%@",temp02);
                [mutableStr appendString:temp02];
                lastPos = pos + 6;
            } else {
                NSRange range = NSMakeRange(pos, 3);
                NSString *tempBody =[body substringWithRange:range];
                NSString *temp01 = [tempBody stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                NSLog(@"--%@",temp01);
                if (temp01) {
                    [mutableStr appendString:temp01];
                }else {
                    [mutableStr appendString:@"●"];
                }
                
                lastPos = pos + 3;
            }
        }else if (pos == -1) {
            NSString *tempBody =[body substringFromIndex:lastPos];
            [mutableStr appendFormat:@"%@",tempBody];
            lastPos = (int)body.length;
        }else {
            NSRange range = NSMakeRange(lastPos, pos-lastPos);
            NSString *tempBody =[body substringWithRange:range];
            [mutableStr appendString:tempBody];
            lastPos = pos;
        }
        
        
    }
    
    return mutableStr;
}

// 转为中文
- (NSString *)replaceUnicode:(NSString *)msg
{
    NSString *tempStr1 = [msg stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF16StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}
// 查找有咩有百分号 并返回ta的位置
- (int)indexOf:(NSString *)allStr andPre:(NSString *)pre andStartLocation:(int)StartLocation
{
    NSString *body = [allStr substringFromIndex:StartLocation];
    NSScanner*scanner=[NSScanner scannerWithString:body];
    NSString *keyString01 = pre;
    [scanner setCaseSensitive:YES]; // yes 区分大小写
    
    BOOL b = NO;
    int returnInt = 0;
    while (![scanner isAtEnd]) {
        b = [scanner scanString:keyString01 intoString:NULL];
        if(b) {
            returnInt = StartLocation + (int)scanner.scanLocation - 1;
            break;
        }
        
        scanner.scanLocation++;
    }
    
    if (!b) {
        returnInt = -1;
    }
    
    return returnInt;
}


@end
