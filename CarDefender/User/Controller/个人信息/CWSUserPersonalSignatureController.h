//
//  CWSUserPersonalSignatureController.h
//  CarDefender
//
//  Created by 李散 on 15/4/14.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSUserPersonalSignatureController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *personalTextView;
@property (weak, nonatomic) IBOutlet UILabel *textNubLabel;
@property (nonatomic, strong) NSString*noteString;
@end
