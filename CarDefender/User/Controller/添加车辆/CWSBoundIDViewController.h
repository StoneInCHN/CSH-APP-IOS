//
//  CWSBoundIDViewController.h
//  CarDefender
//
//  Created by 万茜 on 16/1/7.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSBoundIDViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *idField;
@property (nonatomic,strong)NSString *idString;//车辆ID
@property (nonatomic,strong)NSString *boundIdString;//车辆ID
@end
