//
//  CWSAdInfoViewController.h
//  CarDefender
//
//  Created by sicnu_ifox on 16/5/14.
//  Copyright © 2016年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSAdInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURL *url;
@end
