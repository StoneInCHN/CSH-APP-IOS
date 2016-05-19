//
//  CWSCheckMessageCenterDetailViewController.h
//  CarDefender
//
//  Created by 万茜 on 16/1/12.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSCheckMessageCenterDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (nonatomic,copy) NSString* messageContent;
@end
