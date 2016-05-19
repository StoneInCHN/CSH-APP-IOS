/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "RealtimeSearchUtil.h"
#import "PinYinForObjc.h"
#import "TongXunObject.h"
#import "ChineseInclude.h"
static RealtimeSearchUtil *defaultUtil = nil;

@interface RealtimeSearchUtil()

@property (strong, nonatomic) id source;

@property (nonatomic) SEL selector;

@property (copy, nonatomic) RealtimeSearchResultsBlock resultBlock;

/**
 *  当前搜索线程
 */
@property (strong, nonatomic) NSThread *searchThread;
/**
 *  搜索线程队列
 */
@property (strong, nonatomic) dispatch_queue_t searchQueue;

@end

@implementation RealtimeSearchUtil

@synthesize source = _source;
@synthesize selector = _selector;
@synthesize resultBlock = _resultBlock;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _asWholeSearch = YES;
        _searchQueue = dispatch_queue_create("cn.realtimeSearch.queue", NULL);
    }
    
    return self;
}

/**
 *  实时搜索单例实例化
 *
 *  @return 实时搜索单例
 */
+ (instancetype)currentUtil
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultUtil = [[RealtimeSearchUtil alloc] init];
    });
    
    return defaultUtil;
}

#pragma mark - private

- (void)realtimeSearch:(NSString *)string
{
    [self.searchThread cancel];
    
    //开启新线程
    self.searchThread = [[NSThread alloc] initWithTarget:self selector:@selector(searchBegin:) object:string];
    [self.searchThread start];
}

- (void)searchBegin:(NSString *)string
{
    MyLog(@"%@",string);
    __weak typeof(self) weakSelf = self;
    NSArray*array=(NSArray*)weakSelf.source;
    if (array.count) {
        if ([array[0] isKindOfClass:[TongXunObject class]]) {
            dispatch_async(self.searchQueue, ^{
                if (string.length == 0) {
                    weakSelf.resultBlock(weakSelf.source);
                }
                else{
                    NSMutableArray *results = [NSMutableArray array];
                    //                NSString *tmpString = @"";
                    
                    if (string>0&&![ChineseInclude isIncludeChineseInString:string]) {//判断输入的不是中文字符
                        
                        for (int i=0; i<array.count; i++) {
                            
                            //1、判断是数字
                            if ([self isPureInt:string]) {//纯数字
                                //                for (int i = 0; i<addressBookTemp.count; i++) {
                                TongXunObject*tongxun=array[i];
                                NSString*tellNub = [tongxun.tel stringByReplacingOccurrencesOfString:@" " withString:@""];
                                tellNub = [tellNub stringByReplacingOccurrencesOfString:@"-" withString:@""];
                                tellNub = [tellNub stringByReplacingOccurrencesOfString:@"(" withString:@""];
                                tellNub = [tellNub stringByReplacingOccurrencesOfString:@")" withString:@""];
                                tellNub = [tellNub stringByReplacingOccurrencesOfString:@"+86" withString:@""];
                                tellNub = [tellNub stringByReplacingOccurrencesOfString:@"17951" withString:@""];
                                
                                if (tellNub.length>=string.length) {
                                    
                                    NSRange range=NSMakeRange(0, string.length);
                                    NSString*string1 = [tellNub substringWithRange:range];
                                    if ([string isEqualToString:string1]) {
                                        [results addObject:tongxun];
                                    }
                                    //                    }
                                }
                            }else{//字母和数字
                                TongXunObject* tongxun = array[i];
                                if ([ChineseInclude isIncludeChineseInString:tongxun.name]) {//判断用户名是中文
                                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:tongxun.name];//转换为拼音
                                    NSRange titleResult=[tempPinYinStr rangeOfString:string options:NSCaseInsensitiveSearch];//不区分大小写搜索
                                    if (titleResult.length>0) {//判断长度
                                        [results addObject:tongxun];
                                    }
                                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:tongxun.name];
                                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:string options:NSCaseInsensitiveSearch];
                                    if (titleHeadResult.length>0) {
                                        [results addObject:tongxun];
                                    }
                                }
                                else {//不是中文字
                                    NSRange titleResult=[tongxun.name rangeOfString:string options:NSCaseInsensitiveSearch];
                                    if (titleResult.length>0) {
                                        [results addObject:tongxun];
                                    }
                                }
                            }
                            
                        }
                    } else if (string.length>0&&[ChineseInclude isIncludeChineseInString:string]) {//判断输入的是中文字符
                        for (TongXunObject *tempStr in array) {
                            NSRange titleResult=[tempStr.name rangeOfString:string options:NSCaseInsensitiveSearch];
                            if (titleResult.length>0) {
                                [results addObject:tempStr];
                            }
                        }
                    }
                    NSArray*array=[NSArray arrayWithArray:results];
                    
                    weakSelf.resultBlock(array);
                }
            });
        }else{
            dispatch_async(self.searchQueue, ^{
                if (string.length == 0) {
                    weakSelf.resultBlock(weakSelf.source);
                }
                else{
                    NSMutableArray *results = [NSMutableArray array];
                    NSString *subStr = [string lowercaseString];//小写字母转换
                    for (id object in weakSelf.source) {
                        NSString *tmpString = @"";
                        if (weakSelf.selector) {
                            if([object respondsToSelector:weakSelf.selector])//用来判断是否有以某个名字命名的方法(被封装在一个selector的对象里传递)
                            {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                                tmpString = [[object performSelector:weakSelf.selector] lowercaseString];
#pragma clang diagnostic pop
                            }
                        }
                        else if ([object isKindOfClass:[NSString class]])
                        {
                            tmpString = [object lowercaseString];
                        }
                        else{
                            continue;
                        }
                        
                        if([tmpString rangeOfString:subStr].location != NSNotFound)
                        {
                            [results addObject:object];
                        }
                    }
                    
                    weakSelf.resultBlock(results);
                }
            });
        }
    }else{
        dispatch_async(self.searchQueue, ^{
            if (string.length == 0) {
                weakSelf.resultBlock(weakSelf.source);
            }
            else{
                NSMutableArray *results = [NSMutableArray array];
                NSString *subStr = [string lowercaseString];//小写字母转换
                for (id object in weakSelf.source) {
                    NSString *tmpString = @"";
                    if (weakSelf.selector) {
                        if([object respondsToSelector:weakSelf.selector])//用来判断是否有以某个名字命名的方法(被封装在一个selector的对象里传递)
                        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                            tmpString = [[object performSelector:weakSelf.selector] lowercaseString];
#pragma clang diagnostic pop
                        }
                    }
                    else if ([object isKindOfClass:[NSString class]])
                    {
                        tmpString = [object lowercaseString];
                    }
                    else{
                        continue;
                    }
                    
                    if([tmpString rangeOfString:subStr].location != NSNotFound)
                    {
                        [results addObject:object];
                    }
                }
                
                weakSelf.resultBlock(results);
            }
        });
    }
    
}
//判断是否是数字
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
#pragma mark - public

/**
 *  开始搜索，只需要调用一次，与[realtimeSearchStop]配套使用
 *
 *  @param source      要搜索的数据源
 *  @param selector    获取元素中要比较的字段的方法
 *  @param resultBlock 回调方法，返回搜索结果
 */
- (void)realtimeSearchWithSource:(id)source searchText:(NSString *)searchText collationStringSelector:(SEL)selector resultBlock:(RealtimeSearchResultsBlock)resultBlock
{
    if (!source || !searchText || !resultBlock) {
        _resultBlock(source);
        return;
    }
    
    _source = source;
    _selector = selector;
    _resultBlock = resultBlock;
    [self realtimeSearch:searchText];
}

/**
 *  从fromString中搜索是否包含searchString
 *
 *  @param searchString 要搜索的字串
 *  @param fromString   从哪个字符串搜索
 *
 *  @return 是否包含字串
 */
- (BOOL)realtimeSearchString:(NSString *)searchString fromString:(NSString *)fromString
{
    if (!searchString || !fromString || (fromString.length == 0 && searchString.length != 0)) {
        return NO;
    }
    if (searchString.length == 0) {
        return YES;
    }
    
    NSUInteger location = [[fromString lowercaseString] rangeOfString:[searchString lowercaseString]].location;
    return (location == NSNotFound ? NO : YES);
}

/**
 * 结束搜索，只需要调用一次，在[realtimeSearchBeginWithSource:]之后使用，主要用于释放资源
 */
- (void)realtimeSearchStop
{
    [self.searchThread cancel];
}

@end
