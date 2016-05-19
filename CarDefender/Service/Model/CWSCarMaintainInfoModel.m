//
//  CWSCarMaintainInfoModel.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/7.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSCarMaintainInfoModel.h"

@implementation CWSCarMaintainInfoModel


-(instancetype)init{

    if(self = [super init]){
    
        self.realDataArray = @[].mutableCopy;
        self.cellHeightArray = @[].mutableCopy;
    }
    
    return self;
}

@end
