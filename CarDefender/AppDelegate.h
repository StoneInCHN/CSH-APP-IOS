//
//  AppDelegate.h
//  CarDefender
//
//  Created by 周子涵 on 15/3/24.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHPSideViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "EMChatManagerDelegate.h"
#import "IChatManagerDelegate.h"
#import "CWSCarFriendController.h"

#import "CWSMainViewController.h"

#import "WXApi.h"
#import "WXApiObject.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate,IChatManagerDelegate,WXApiDelegate,BMKLocationServiceDelegate>
{
    EMConnectionState _connectionState;
    BOOL backOrActive;
    NSDictionary*notiDic;//保存推送的消息
    BMKLocationService*      _locService;
}
@property (strong,nonatomic) LHPSideViewController *sideViewController;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CWSCarFriendController *mainController;
@property (strong, nonatomic) CWSMainViewController*cwsMainVC;
@property (nonatomic,strong)id lastViewController;

-(void)loginOterDeviceNoteWithString:(NSString*)msgString;
-(void)buildMainFrame;
@end

