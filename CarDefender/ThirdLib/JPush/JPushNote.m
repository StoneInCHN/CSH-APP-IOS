//
//  JPushNote.m
//  JPush_Test
//
//  Created by 王泰莅 on 15/11/24.
//  Copyright © 2015年 王泰莅. All rights reserved.
//




#import "JPushNote.h"

static JPushNote* jpushNote;
@implementation JPushNote

+(JPushNote*)sharedInstance{
    
    if(!jpushNote){
        jpushNote = [[JPushNote alloc]init];
    }
    return jpushNote;
}

@end
