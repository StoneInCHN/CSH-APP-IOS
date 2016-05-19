

#define USENEWVERSION 1
#define USENEWURL 0 //1为内网
#define SERVICE_STATE_SUCCESS @"200000"
#define SERVICE_STATE_WRONG @"200001"

#pragma mark modify by sifu
#define SERVICE_SUCCESS @"0000"
#define SERVICE_TIME_OUT @"0004"
#define REGISTER_CODE @"register"
#define MODIFY_PASSWD_CODE @"modify password"

//#define SERVICE_ERROR 

/**
 *  系统版本
 */
#define IOS7 [[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0
#define IOS8 [[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0

/**
 *  创建颜色的方法
 */
#define kCOLOR(a,b,c) [UIColor colorWithRed:(a)/255.0 green:(b)/255.0 blue:(c)/255.0 alpha:1]
#define kFONT_COLOR [UIColor colorWithRed:83.0/255.0 green:187.0/255.0 blue:31.0/255.0 alpha:1]
#define GRAYFONT_COLOR [UIColor colorWithRed:186.0/255.0 green:186.0/255.0 blue:186.0/255.0 alpha:1]
#define kBACKGROUND_COLOR [UIColor colorWithRed:21.0/255.0 green:25.0/255.0 blue:34.0/255.0 alpha:1]

//替代的主题黑色
#define KBlackMainColor [UIColor colorWithRed:72/255.0 green:72/255.0 blue:72/255.0 alpha:1]

//主题色 - 蓝色
#define kMainColor [UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1]
//红色插色：#fe6270  （254、98、112）
#define kInsertRedColor [UIColor colorWithRed:254/255.0 green:98/255.0 blue:112/255.0 alpha:1]
//橙色插色：#fdaa4c  （253、170、76）
#define kInsertOrangeColor [UIColor colorWithRed:253/255.0 green:170/255.0 blue:76/255.0 alpha:1]
//绿色插色：#62ce49  （98、206、73）
#define kInsertGreenColor [UIColor colorWithRed:98/255.0 green:206/255.0 blue:73/255.0 alpha:1]
////背景：#62ce49  （245、245、245）
#define KGroundColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]



/**深灰色*/
#define KGrayColor [UIColor colorWithRed:0.886f green:0.886f blue:0.886f alpha:1.00f]
/**轻灰色*/
#define KGrayColor2 [UIColor colorWithRed:0.918f green:0.918f blue:0.918f alpha:1.00f]
/**超轻灰色*/
#define KGrayColor3 [UIColor colorWithRed:0.961f green:0.961f blue:0.961f alpha:1.00f] 

/**蓝色*/
#define KBlueColor [UIColor colorWithRed:46/255.0 green:179/255.0 blue:232/255.0 alpha:1]


/**橙色*/
#define KOrangeColor [UIColor colorWithRed:0.992f green:0.698f blue:0.380f alpha:1.00f]


/**绿色*/
#define KGreenColor [UIColor colorWithRed:0.243f green:0.733f blue:0.600f alpha:1.00f]


/**红色*/
#define KRedColor [UIColor colorWithRed:0.965f green:0.388f blue:0.420f alpha:1.00f]



/**
 *  Dock的高度
 */
#define kDockHeight 44
/**
 *  卡片头部高度
 */
#define kCardHead_H 30
/**
 *  卡片底部高度
 */
#define kCardFoot_H 34
/**
 *  状态栏高度
 */
#define kSTATUS_BAR 20

/**
 *  屏幕的尺寸
 */
#define kSizeOfScreen   [[UIScreen mainScreen]applicationFrame].size

/**
 *  字体字号(大中小)
 */
#define kFontOfSize(a)     [UIFont fontWithName:@"Helvetica Neue" size:(a)]
#define kImageFontOfSize(a)     [UIFont fontWithName:@"icomoon" size:(a)]

/**
 *  定义输出宏
 */
#ifdef DEBUG
//#define MyLog(...)
#define MyLog(...) NSLog(__VA_ARGS__)
#else
#define MyLog(...)
#endif

/**
 *  字体字号(大中小)
 */
#define kFontOfLetterSmall      [UIFont fontWithName:@"Helvetica Neue" size:12]
#define kFontOfLetterMedium [UIFont fontWithName:@"Helvetica Neue" size:14]
#define kFontOfLetterBig         [UIFont fontWithName:@"Helvetica Neue" size:16]
/**
 *  调试用背景色
 */
#define kBackgroundColor   [UIColor lightGrayColor]
/**
 *  黑色字体
 */
#define kTextBlackColor    KBlackMainColor
/**
 *  浅灰色字体
 */
#define kTextlightGrayColor    [UIColor lightGrayColor]
/**
 *  无色背景
 */
#define kTextClearColor    [UIColor clearColor]
/**
 *  已图片色为背景颜色
 */
#define kColorGreenImg  [UIColor colorWithPatternImage:[UIImage imageNamed:@"repair_green"]]
/**
 *  已图片色为背景颜色
 */
#define kBackgroundImageColor(s, ... )  [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:(s)]]]

/**
 *  地图范围
 */
#define DISTANCE_FILTER 40
/**
 *  百度的KEY
 */
#define kBAIDUKEY @"KSCPxnVCnCFtUb4uihy3K9XH"
/**
 *  请求数据的URL
 */
#define kURL @"http://yunchebao.com.cn/index.php?m=api&c=v1"
#define kPHOTOURL @"http://yunchebao.com.cn"

/**
 *  城市地区选择 返回通知标识符
 */
#define k_AREA_CHOOSE_BACK   @"addressgoback"
/**
 *  用户设置
 */
#define KUserManager [UserManager shareUserManagerInfo].user
/**
 *  用户设置
 */
#define KManager [Manager shareManagerInfo]
/**
 *  视图圆角半径
 */
#define KRadius 6
#define KLightColor [UIColor colorWithRed:50.0/255.0 green:60.0/255.0 blue:77.0/255.0 alpha:1]
#define KDarkColor [UIColor colorWithRed:50.0/255.0 green:60.0/255.0 blue:77.0/255.0 alpha:1]
/**
 *  沙盒路径
 */
#define kShaHePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
/**
 *  绑定车辆保存沙盒命名
 */
#define kBangDingCar(a) [NSString stringWithFormat:@"bangding%d",(a)]
/**
 *  选择车辆保存沙盒命名
 */
#define kXuanzheCar @"xuanzhecar"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"

#define CHATVIEWBACKGROUNDCOLOR [UIColor colorWithRed:0.936 green:0.932 blue:0.907 alpha:1]
/**
 *  通话记录沙盒名
 */
#define kCallRecrd @"callRecords"

/**
 *  通话记录沙盒名
 */
#define kCallRecrdWithUid(d) [NSString stringWithFormat:@"callRecords%d",(p)]
/**
 *  存储联系人数据沙盒名
 */
#define kContactRecord @"contactMsgRecord"
/**
 *  记录账号密码
 */
#define kAccountMsg @"userAccountMsg"
/**
 *  后台进入车辆管理app 推送消息沙盒名
 */
#define kAppToActionNotification @"appToActionNotification"
/**
 *  后台进入车动态app 推送消息沙盒名
 */
#define kCarTrendAppToActionNotification @"appCarTrendToActionNotification"
/**
 *  距离顶部高度
 */
#define kTO_TOP_DISTANCE 0

