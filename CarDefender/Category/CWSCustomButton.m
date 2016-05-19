//
//  CWSCustomButton.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/3.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSCustomButton.h"

@implementation CWSCustomButton

-(CGRect)imageRectForContentRect:(CGRect)contentRect{

    return CGRectMake((contentRect.size.width-30)/2, 0, 30, 30);
}


//-(CGRect)titleRectForContentRect:(CGRect)contentRect{
//
//    return CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
//}


@end
