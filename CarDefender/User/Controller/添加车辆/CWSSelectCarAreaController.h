//
//  CWSSelectCarAreaController.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/4.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^selectInfoBlock)(NSString*);
@interface CWSSelectCarAreaController : UIViewController


@property (nonatomic,copy) NSString* selectWhat;
@property (nonatomic,strong) NSArray* dataArray;


@property (nonatomic,strong) selectInfoBlock selectedAreaOrLetter;

@end
