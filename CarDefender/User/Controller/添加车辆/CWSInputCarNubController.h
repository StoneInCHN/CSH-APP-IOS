//
//  CWSInputCarNubController.h
//  CarDefender
//
//  Created by 李散 on 15/4/9.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSInputCarNubController : UIViewController
- (IBAction)chooseSimpleNub:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *carNubText;
@property (weak, nonatomic) IBOutlet UILabel *simpleCarNubLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *upDownImage;
@property (weak, nonatomic) IBOutlet UIView *carNubView;
@property(strong,nonatomic)NSString*shortString;
@property(strong,nonatomic)NSString*carNubAllString;
@end
