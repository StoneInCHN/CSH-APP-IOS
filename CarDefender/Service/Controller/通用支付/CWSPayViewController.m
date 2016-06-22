//
//  CWSPayViewController.m
//  CarDefender
//
//  Created by 王泰莅 on 15/12/12.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "CWSPayViewController.h"
#import "CWSPaySuccessViewController.h"

#import "CWSPayInfoView.h"
#import "CWSPayMethodView.h"


#import "WXApi.h"
#import "WQPay.h"
#import "WXPay.h"
#import "WXUtil.h"
#import "WQAler.h"
#import "payRequsestHandler.h"

#define PAYMETHOD 3
@interface CWSPayViewController (){

    UIView* payMethodView;  //支付方式视图
    
    UIView* redPackageUsedView; //红包选择视图
    
    UIView* balanceUsedView;   //余额选择视图
    
    CWSPayInfoView* payInfoView;  //支付信息视图
    
    UILabel* redLabel;  //红包抵用金额标签
    
    UILabel* balanceLabel; // 余额抵用金额标签
    UIButton *zhifubaoButton;
    UIButton *weixinButton;
    UIButton *balanceButton;
    UIButton *couponButtton;
    UISwitch* redSwitch;
    UIView *discountCouponView; // 优惠劵实图
    CGFloat totalHeight;  //总高度
    
    CGFloat totalHeightCopy;
    
    float redMoney;   //红包钱数
    float balanceMoney; //余额钱数
    float settleMoney;  //结算金额
    float payMoney; //实际支付
    
    float tempRedMoney; //临时红包钱数
    float tempBalanceMoney;  //临时余额钱数
    
    BOOL isBalanceEnough; //余额够
    BOOL isAddHeight; //是否该添加高度
    BOOL isPaySuccess; //是否支付成功
    
    UILabel* totalCountLabel;  //合计总金额
    
    NSInteger payMethodNum; //0支付宝 1微信 2银联
    NSString* payMethodString;
    
    UserInfo *userInfo;
    NSMutableDictionary* wallertDict;//钱包数据
    NSMutableArray *_coupons;
    NSMutableArray *_couponsSelectedBtn;
}
@property (nonatomic,strong) UIScrollView* myScrollView;
@end

@implementation CWSPayViewController

-(instancetype)init{
    
    if(self = [super init]){
        _isRedpackageUseable = YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(isPaySuccess){
        [WCAlertView showAlertWithTitle:nil message:@"您已完成付款" customizationBlock:nil completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ModelTool stopAllOperation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = KGrayColor3;
    userInfo = [UserInfo userDefault];
    
    isAddHeight = YES;
    
    [PublicUtils changeBackBarButtonStyle:self];
    
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height-kDockHeight-50)];
    _myScrollView.backgroundColor = KGrayColor3;
    _myScrollView.bounces = YES;
    _myScrollView.showsHorizontalScrollIndicator = NO;
    _myScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_myScrollView];
    
    [self loadData];
    [self getCoupons];
    
    MyLog(@"------确认信息----%@",self.dataDict);
    NSLog(@"service id :%@",self.serviceId);
}


#pragma mark -=============================InitialData
-(void)loadData{
    [MBProgressHUD showMessag:@"正在加载..." toView:self.view];
//    [ModelTool getWalletInfoWithParameter:@{@"uid":KUserManager.uid,@"mobile":KUserManager.mobile} andSuccess:^(id object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            if([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]){
    [HttpHelper viewMyWalletWithUserId:userInfo.desc
                                 token:userInfo.token
                               success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
           if([responseObjcet[@"code"] isEqualToString:SERVICE_SUCCESS]){
    
                wallertDict = [NSMutableDictionary dictionaryWithDictionary:responseObjcet[@"msg"]];
                for (NSString* key in [wallertDict allKeys]) {
                    [wallertDict setObject:[PublicUtils checkNSNullWithgetString:[wallertDict valueForKey:key]] forKeyedSubscript:key];
                }
                MyLog(@"------------我的钱包信息------------%@",wallertDict);
    
//                NSDictionary* testDict = @{@"money":@"40",@"red":@"10"};
                
                KUserManager.userWalletInfo = wallertDict.mutableCopy;
               
                NSString* realPrice = [NSString stringWithFormat:@"%@",[self.dataDict[@"is_discount_price"] intValue] ? self.dataDict[@"discount_price"] : self.dataDict[@"price"]];
                settleMoney = [realPrice floatValue];
                payMethodString = @"";
                MyLog(@"原价%@-余额%@-红包%@",realPrice, wallertDict[@"balanceAmount"], wallertDict[@"giftAmount"]);
                MyLog(@"%f",settleMoney);
                /////////在这里进行判断//////////
                if(self.isRedpackageUseable){
#warning 把普洗的判断换成30
                    [self createUI];
//                    if([self.dataDict[@"goods_name"] isEqualToString:@"普洗"]){
//                        if([KUserManager.userWalletInfo[@"red"] floatValue] >= settleMoney){
//                            payMethodView.hidden = YES;
//                            balanceUsedView.hidden = YES;
//                            totalHeight = totalHeight - (payMethodView.frame.size.height+balanceUsedView.frame.size.height);
//                            redMoney = settleMoney;
//                        }else{
//                            balanceUsedView.hidden = NO;
//                            redMoney = [KUserManager.userWalletInfo[@"red"] floatValue];
//                            if([KUserManager.userWalletInfo[@"money"] floatValue] >= (settleMoney-redMoney)){
//                                payMethodView.hidden = YES;
//                                totalHeight = totalHeight - payMethodView.frame.size.height;
//                                balanceMoney = settleMoney-redMoney;
//                            }else{
//                                payMethodView.hidden = NO;
////                                totalHeight += payMethodView.frame.size.height;
//                                balanceMoney = [KUserManager.userWalletInfo[@"money"] floatValue];
//                            }
//                        }
//                    }else{
//                        NSString* resultPrice = [NSString stringWithFormat:@"%f",0.15 * [realPrice floatValue]];
//                        balanceUsedView.hidden = NO;
////                        totalHeight += balanceUsedView.frame.size.height;
//                        if([KUserManager.userWalletInfo[@"red"] floatValue] >= [resultPrice floatValue]){
//                            redMoney = [resultPrice floatValue];
//                        }else{
//                            redMoney = [KUserManager.userWalletInfo[@"red"] floatValue];
//                        }
//                        if([KUserManager.userWalletInfo[@"money"] floatValue] >= (settleMoney-redMoney)){
//                            payMethodView.hidden = YES;
//                            totalHeight -= payMethodView.frame.size.height;
//                            balanceMoney = settleMoney-redMoney;
//                        }else{
//                            payMethodView.hidden = NO;
////                            totalHeight += payMethodView.frame.size.height;
//                            balanceMoney = [KUserManager.userWalletInfo[@"money"] floatValue];
//                        }
//                    }
//                    if([self.dataDict[@"goods_name"] isEqualToString:@"普洗"]){
                        if([wallertDict[@"giftAmount"] floatValue] >= settleMoney){
                            payMethodView.hidden = YES;
                            balanceUsedView.hidden = YES;
                            totalHeight = totalHeight - (payMethodView.frame.size.height+balanceUsedView.frame.size.height);
                            redMoney = settleMoney;
                        }else{
                            redMoney = [wallertDict[@"giftAmount"] floatValue];
                            if([wallertDict[@"balanceAmount"] floatValue] >= (settleMoney-redMoney)){
                                balanceUsedView.hidden = NO;
                                payMethodView.hidden = YES;
                                totalHeight = totalHeight - payMethodView.frame.size.height;
                                balanceMoney = settleMoney-redMoney;
                            }else{
                                payMethodView.hidden = NO;
                                balanceUsedView.hidden = YES;
                                balanceMoney = 0.00f;
                            }
                        }
//                    }else{
//                        NSString* resultPrice = [NSString stringWithFormat:@"%f",0.15 * [realPrice floatValue]];
//                        if(tempRedMoney >= [resultPrice floatValue]){
//                            redMoney = [resultPrice floatValue];
//                        }else{
//                            redMoney = tempRedMoney;
//                        }
//                        if(tempBalanceMoney >= (settleMoney-redMoney)){
//                            balanceUsedView.hidden = NO;
//                            payMethodView.hidden = YES;
//                            totalHeight -= payMethodView.frame.size.height;
//                            balanceMoney = settleMoney-redMoney;
//                        }else{
//                            payMethodView.hidden = NO;
//                            balanceUsedView.hidden = YES;
//                            balanceMoney = 0.00f;
//                        }
//                    }


                }else{
//                    redMoney = 0;
//                    self.isBalanceUseable = YES;
//                    if([KUserManager.userWalletInfo[@"money"] floatValue] >= settleMoney){
//                        self.isPayUseable = NO;
//                        balanceMoney = settleMoney;
//                    }else{
//                        self.isPayUseable = YES;
//                        balanceMoney = [KUserManager.userWalletInfo[@"money"] floatValue];
//                    }
                }
                payMoney = settleMoney-redMoney-balanceMoney;
                [self updateUI];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:responseObjcet[@"desc"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
            }
//        });
//    } andFail:^(NSError *err) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请重新加载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
         [alert show];
         [self.navigationController popViewControllerAnimated:YES];
     }];
}


-(void)updateUI{
//    totalCountLabel.text = [NSString stringWithFormat:@"￥%.2f",payMoney];
//    redLabel.text = [NSString stringWithFormat:@"可使用红包抵用%.2f元",redMoney];
//    balanceLabel.text = [NSString stringWithFormat:@"可使用余额抵用%.2f元",balanceMoney];
    totalCountLabel.text = payInfoView.priceLabel.text;
    redLabel.text = [NSString stringWithFormat:@"使用优惠劵抵用%.2f元",redMoney];
    balanceLabel.text = [NSString stringWithFormat:@"使用账户余额抵用"];
    payMoney = [[payInfoView.priceLabel.text substringFromIndex:1] floatValue];
    

//    CGRectGetMaxY(payInfoView.frame)+payMethodView.frame.size.height
//    CGRectGetMaxY(payInfoView.frame)+payMethodView.frame.size.height+redPackageUsedView.frame.size.height+1
    CGRect redViewY = redPackageUsedView.frame;
    CGRect balanceViewY = balanceUsedView.frame;
    
//    if(payMethodView.hidden){
//        redViewY.origin.y = CGRectGetMaxY(payInfoView.frame);
//        balanceViewY.origin.y = CGRectGetMaxY(payInfoView.frame)+redPackageUsedView.frame.size.height+1;
//        if(!isAddHeight){
//            totalHeight -= payMethodView.frame.size.height;
//            isAddHeight = YES;
//        }
//    }else{
        redViewY.origin.y = CGRectGetMaxY(payInfoView.frame)+payMethodView.frame.size.height;
        balanceViewY.origin.y = CGRectGetMaxY(payInfoView.frame)+payMethodView.frame.size.height+redPackageUsedView.frame.size.height+1 + discountCouponView.frame.size.height;
        if(isAddHeight){
            totalHeight += payMethodView.frame.size.height;
            isAddHeight = NO;
        }
//    }
//    
    
    payMethodView.hidden = NO;
    redPackageUsedView.frame = redViewY;
    balanceUsedView.frame = balanceViewY;
    
    [self initialScrollView];
}

#pragma mark -=============================CreateUI
-(void)createUI{

    payInfoView = [[[NSBundle mainBundle]loadNibNamed:@"CWSPayInfoView" owner:self options:nil] lastObject];
    payInfoView.frame = CGRectMake(0, 0, kSizeOfScreen.width, 149);
    [payInfoView setDataDict:self.dataDict];
    totalHeight  += payInfoView.frame.size.height;
    [_myScrollView addSubview:payInfoView];
    
    //支付方式选择
    [self createPayMethodView];
    
    //红包抵用选择
    [self createRedPackageView];
    
    //余额抵用选择
    //[self createBalanceView];
    
    
    //合计确认
    UIView* totalCountView = [[UIView alloc]initWithFrame:CGRectMake(0, kSizeOfScreen.height-kDockHeight-45, kSizeOfScreen.width, 45)];
    totalCountView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:totalCountView];
    
    UIButton* comfimButton = [UIButton buttonWithType:UIButtonTypeCustom];
    comfimButton.frame = CGRectMake(kSizeOfScreen.width-88, 0, 88, 45);
    comfimButton.backgroundColor = KBlueColor;
    comfimButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [comfimButton setTitle:@"确认" forState:UIControlStateNormal];
    [comfimButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [comfimButton addTarget:self action:@selector(comfimButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [totalCountView addSubview:comfimButton];
    
    UILabel* totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 30, 15)];
    totalLabel.font = [UIFont systemFontOfSize:15.0f];
    totalLabel.text = @"合计:";
    totalLabel.textAlignment = NSTextAlignmentLeft;
    [totalCountView addSubview:totalLabel];
    [totalLabel sizeToFit];
    
    totalCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(totalLabel.frame), 15, kSizeOfScreen.width, 15)];
    totalCountLabel.font = [UIFont systemFontOfSize:14.0f];
    totalCountLabel.textColor = KRedColor;
    totalCountLabel.text = [NSString stringWithFormat:@"￥%.2f",payMoney];
    totalCountLabel.textAlignment = NSTextAlignmentLeft;
    [totalCountView addSubview:totalCountLabel];

    [self initialScrollView];
    
}


-(void)createPayMethodView{
        //支付页面
//        payMethodView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(payInfoView.frame), kSizeOfScreen.width, 230)];
        payMethodView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(payInfoView.frame), kSizeOfScreen.width, 232+58)];
        payMethodView.backgroundColor = KGrayColor3;
        totalHeight += payMethodView.frame.size.height;
        [_myScrollView addSubview:payMethodView];

        //标题view
        UIView* titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, kSizeOfScreen.width, 40)];
        titleView.backgroundColor = [UIColor whiteColor];
        [payMethodView addSubview:titleView];
        
        UILabel* label1 = [PublicUtils labelWithFrame:CGRectMake(10, 15, kSizeOfScreen.width, 16) withTitle:@"请选择支付方式" titleFontSize:[UIFont systemFontOfSize:15.0] textColor:KBlackMainColor backgroundColor:nil alignment:0 hidden:NO];
        [titleView addSubview:label1];
        [label1 sizeToFit];
        
        
        //支付宝view
        UIView* zhifubaoView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), kSizeOfScreen.width, 58)];
        zhifubaoView.backgroundColor = [UIColor whiteColor];
        [payMethodView addSubview:zhifubaoView];
        
        UIView* barrierLine1 = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kSizeOfScreen.width-20, 1)];
        barrierLine1.backgroundColor = KGrayColor3;
        [zhifubaoView addSubview:barrierLine1];
        
        UIImageView* viewImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 38, 38)];
        viewImg1.image = [UIImage imageNamed:@"zhufu"];
        [zhifubaoView addSubview:viewImg1];
        UILabel* viewImgLabel1 = [PublicUtils labelWithFrame:CGRectMake(CGRectGetMaxX(viewImg1.frame)+10, 12, kSizeOfScreen.width, 15) withTitle:@"支付宝支付" titleFontSize:[UIFont systemFontOfSize:13.0] textColor:KBlackMainColor backgroundColor:nil alignment:0 hidden:NO];
        [zhifubaoView addSubview:viewImgLabel1];
        [viewImgLabel1 sizeToFit];
        UILabel* viewImgLabel2 = [PublicUtils labelWithFrame:CGRectMake(CGRectGetMaxX(viewImg1.frame)+10, CGRectGetMaxY(viewImgLabel1.frame)+5, kSizeOfScreen.width, 14) withTitle:@"推荐有支付宝账号的用户使用" titleFontSize:[UIFont systemFontOfSize:11.0] textColor:[UIColor darkGrayColor] backgroundColor:nil alignment:0 hidden:NO];
        [zhifubaoView addSubview:viewImgLabel2];
        [viewImgLabel2 sizeToFit];
        
        zhifubaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        zhifubaoButton.frame = CGRectMake(0, 1, kSizeOfScreen.width, 58);
        zhifubaoButton.selected = YES;
        payMethodNum = 0; //默认为支付宝支付
        payMethodString = @"alipay";
        [zhifubaoButton setTitle:@"alipay" forState:UIControlStateNormal];
        [zhifubaoButton setImage:[UIImage imageNamed:@"mycar_noclick"] forState:UIControlStateNormal];
        [zhifubaoButton setImage:[UIImage imageNamed:@"mycar_click"] forState:UIControlStateSelected];
        [zhifubaoButton setImageEdgeInsets:UIEdgeInsetsMake(0, kSizeOfScreen.width-35, 0, 0)];
        [zhifubaoButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -100, 0)];
        [zhifubaoButton addTarget:self action:@selector(payButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        zhifubaoButton.tag = 200;
        [zhifubaoView addSubview:zhifubaoButton];
    
    //余额view
    UIView* balanceView;
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]){
    
        //微信view
        UIView* wxView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(zhifubaoView.frame), kSizeOfScreen.width, 58)];
        wxView.backgroundColor = [UIColor whiteColor];
        [payMethodView addSubview:wxView];
        
        UIView* barrierLine2 = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kSizeOfScreen.width-20, 1)];
        barrierLine2.backgroundColor = KGrayColor3;
        [wxView addSubview:barrierLine2];
        
        UIImageView* weixinImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 38, 38)];
        weixinImage.image = [UIImage imageNamed:@"weixin"];
        [wxView addSubview:weixinImage];
        UILabel* view2ImgLabel1 = [PublicUtils labelWithFrame:CGRectMake(CGRectGetMaxX(weixinImage.frame)+10, 12, kSizeOfScreen.width, 15) withTitle:@"微信支付" titleFontSize:[UIFont systemFontOfSize:13] textColor:KBlackMainColor backgroundColor:nil alignment:0 hidden:NO];
        [wxView addSubview:view2ImgLabel1];
        [view2ImgLabel1 sizeToFit];
        UILabel* view2ImgLabel2 = [PublicUtils labelWithFrame:CGRectMake(CGRectGetMaxX(weixinImage.frame)+10, CGRectGetMaxY(view2ImgLabel1.frame)+5, kSizeOfScreen.width, 14) withTitle:@"推荐安装微信5.0及以上版本的使用" titleFontSize:[UIFont systemFontOfSize:11.0] textColor:[UIColor darkGrayColor] backgroundColor:nil alignment:0 hidden:NO];
        [wxView addSubview:view2ImgLabel2];
        [view2ImgLabel2 sizeToFit];
        
        weixinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        weixinButton.frame = CGRectMake(0, 1, kSizeOfScreen.width, 58);
        [weixinButton setTitle:@"wx" forState:UIControlStateNormal];
        [weixinButton setImage:[UIImage imageNamed:@"mycar_noclick"] forState:UIControlStateNormal];
        [weixinButton setImage:[UIImage imageNamed:@"mycar_click"] forState:UIControlStateSelected];
        [weixinButton setImageEdgeInsets:UIEdgeInsetsMake(0, kSizeOfScreen.width-35, 0, 0)];
        [weixinButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -100, 0)];
        [weixinButton addTarget:self action:@selector(payButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        weixinButton.tag = 201;
        [wxView addSubview:weixinButton];
         balanceView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(wxView.frame), kSizeOfScreen.width, 58)];
    }else {
        payMethodView.frame = CGRectMake(0, CGRectGetMaxY(payInfoView.frame), kSizeOfScreen.width, 232);
         balanceView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(zhifubaoView.frame), kSizeOfScreen.width, 58)];
    }
    
    balanceView.backgroundColor = [UIColor whiteColor];
    [payMethodView addSubview:balanceView];
    
    UIView* barrierLine3 = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kSizeOfScreen.width-20, 1)];
    barrierLine3.backgroundColor = KGrayColor3;
    [balanceView addSubview:barrierLine3];
    
    UIImageView* yinlianImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 38, 38)];
    yinlianImage.image = [UIImage imageNamed:@"yinlian"];
    [balanceView addSubview:yinlianImage];

    UILabel* view3ImgLabel1 = [PublicUtils labelWithFrame:CGRectMake(CGRectGetMaxX(yinlianImage.frame)+10, 12, kSizeOfScreen.width, 15) withTitle:@"钱包支付" titleFontSize:[UIFont systemFontOfSize:13.0f] textColor:KBlackMainColor backgroundColor:nil alignment:0 hidden:NO];
    [balanceView addSubview:view3ImgLabel1];
    [view3ImgLabel1 sizeToFit];
    UILabel* view3ImgLabel2 = [PublicUtils labelWithFrame:CGRectMake(CGRectGetMaxX(yinlianImage.frame)+10, CGRectGetMaxY(view3ImgLabel1.frame)+5, kSizeOfScreen.width, 14) withTitle:@"推荐用户优先使用钱包余额" titleFontSize:[UIFont systemFontOfSize:11.0f] textColor:[UIColor darkGrayColor] backgroundColor:nil alignment:0 hidden:NO];
    [balanceView addSubview:view3ImgLabel2];
    [view3ImgLabel2 sizeToFit];
        
    balanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    balanceButton.tag = 202;
    balanceButton.frame = CGRectMake(0, 1, kSizeOfScreen.width, 58);
    [balanceButton setTitle:@"yue" forState:UIControlStateNormal];
    [balanceButton setImage:[UIImage imageNamed:@"mycar_noclick"] forState:UIControlStateNormal];
    [balanceButton setImage:[UIImage imageNamed:@"mycar_click"] forState:UIControlStateSelected];
    [balanceButton setImageEdgeInsets:UIEdgeInsetsMake(0, kSizeOfScreen.width-35, 0, 0)];
    [balanceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -100, 0)];
    [balanceButton addTarget:self action:@selector(payButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [balanceView addSubview:balanceButton];
    
        //优惠劵
    UIView *couponView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(balanceView.frame), kSizeOfScreen.width, 58)];
    couponView.backgroundColor = [UIColor whiteColor];
    [payMethodView addSubview:couponView];
    
    UIView* barrierLine4 = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kSizeOfScreen.width-20, 1)];
    barrierLine4.backgroundColor = KGrayColor3;
    [couponView addSubview:barrierLine4];
    
    UIImageView* balanceImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 38, 38)];
    balanceImage.image = [UIImage imageNamed:@"yinlian"];
    [couponView addSubview:balanceImage];
    UILabel* view4ImgLabel1 = [PublicUtils labelWithFrame:CGRectMake(CGRectGetMaxX(yinlianImage.frame)+10, 12, kSizeOfScreen.width, 15) withTitle:@"洗车劵支付" titleFontSize:[UIFont systemFontOfSize:13.0f] textColor:KBlackMainColor backgroundColor:nil alignment:0 hidden:NO];
    [couponView addSubview:view4ImgLabel1];
    [view4ImgLabel1 sizeToFit];
    UILabel* view4ImgLabel2 = [PublicUtils labelWithFrame:CGRectMake(CGRectGetMaxX(yinlianImage.frame)+10, CGRectGetMaxY(view3ImgLabel1.frame)+5, kSizeOfScreen.width, 14) withTitle:@"洗车劵可以抵扣当前洗车所需支付金额" titleFontSize:[UIFont systemFontOfSize:11.0f] textColor:[UIColor darkGrayColor] backgroundColor:nil alignment:0 hidden:NO];
    [couponView addSubview:view4ImgLabel2];
    [view4ImgLabel2 sizeToFit];
    
    couponButtton = [UIButton buttonWithType:UIButtonTypeCustom];
    couponButtton.tag = 203;
    couponButtton.frame = CGRectMake(0, 1, kSizeOfScreen.width, 58);
    [couponButtton setTitle:@"xichejuan" forState:UIControlStateNormal];
    [couponButtton setImage:[UIImage imageNamed:@"mycar_noclick"] forState:UIControlStateNormal];
    [couponButtton setImage:[UIImage imageNamed:@"mycar_click"] forState:UIControlStateSelected];
    [couponButtton setImageEdgeInsets:UIEdgeInsetsMake(0, kSizeOfScreen.width-35, 0, 0)];
    [couponButtton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -100, 0)];
    [couponButtton addTarget:self action:@selector(payButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [couponView addSubview:couponButtton]; 
}

-(void)createRedPackageView{
        redPackageUsedView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(payInfoView.frame)+payMethodView.frame.size.height, kSizeOfScreen.width, 60)];
        redPackageUsedView.backgroundColor = KGrayColor3;
        totalHeight += redPackageUsedView.frame.size.height;
        [_myScrollView addSubview:redPackageUsedView];
        
        UIView* selectedRedPackageView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, kSizeOfScreen.width, 45)];
        selectedRedPackageView.backgroundColor = [UIColor whiteColor];
        [redPackageUsedView addSubview:selectedRedPackageView];
        
        redLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 18, kSizeOfScreen.width, 15)];
        redLabel.textColor = KRedColor;
        redLabel.font = [UIFont systemFontOfSize:14.0f];
        redLabel.textAlignment = NSTextAlignmentLeft;
//        redLabel.text = [NSString stringWithFormat:@"可使用红包抵用%.2f元",redMoney];
        redLabel.text = [NSString stringWithFormat:@"使用优惠劵抵用"];
        [selectedRedPackageView addSubview:redLabel];
        
        redSwitch = [[UISwitch alloc]init];
        redSwitch.tag = 300;
        redSwitch.frame = CGRectMake(kSizeOfScreen.width-10-redSwitch.size.width, 10, redSwitch.size.width, redSwitch.size.height);
        redSwitch.on = NO;
        [redSwitch addTarget:self action:@selector(switchClicked:) forControlEvents:UIControlEventValueChanged];
        [selectedRedPackageView addSubview:redSwitch];
}

-(void)createBalanceView{
        balanceUsedView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(payInfoView.frame)+payMethodView.frame.size.height+redPackageUsedView.frame.size.height+1, kSizeOfScreen.width, 45)];
        balanceUsedView.backgroundColor = [UIColor whiteColor];
        totalHeight += balanceUsedView.frame.size.height;
        [_myScrollView addSubview:balanceUsedView];
        
        balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 18, kSizeOfScreen.width, 15)];
        balanceLabel.textColor = KRedColor;
        balanceLabel.font = [UIFont systemFontOfSize:14.0f];
        balanceLabel.textAlignment = NSTextAlignmentLeft;
//        balanceLabel.text = [NSString stringWithFormat:@"可使用余额抵用%.2f元",balanceMoney];
        balanceLabel.text = [NSString stringWithFormat:@"使用账户余额抵用"];
        [balanceUsedView addSubview:balanceLabel];
        
        UISwitch* balanceSwitch = [[UISwitch alloc]init];
        balanceSwitch.tag = 301;
        balanceSwitch.frame = CGRectMake(kSizeOfScreen.width-10-balanceSwitch.size.width, 10, balanceSwitch.size.width, balanceSwitch.size.height);
        balanceSwitch.on = NO;
        [balanceSwitch addTarget:self action:@selector(switchClicked:) forControlEvents:UIControlEventValueChanged];
        [balanceUsedView addSubview:balanceSwitch];
}
/**抵用按钮选择*/
-(void)switchClicked:(UISwitch*)sender{
    
    
    UISwitch* switchBalance = (UISwitch*)[self.view viewWithTag:301];
    
    
    //    if()
    
    //    switch(sender.tag-300){
    //        case 0:{
    //            MyLog(@"红包%@",sender.on ? @"开" : @"关");
    //            if(sender.on){
    //
    //                redMoney = tempRedMoney;
    //
    //                tempRedMoney = 0;
    //
    //                if(isBalanceEnough){
    //                    if(switchBalance.on){
    //                        balanceMoney -= redMoney;
    //                    }else{
    //                        tempBalanceMoney -= redMoney;
    //                        balanceMoney = 0;
    //                    }
    //                }
    //
    //            }else{
    //                tempRedMoney = redMoney;
    //                if([KUserManager.userWalletInfo[@"money"] floatValue] >= (balanceMoney+redMoney) && switchBalance.on){
    //                    if(balanceUsedView.hidden){
    //                        balanceUsedView.hidden  = NO;
    //                        totalHeight += balanceUsedView.frame.size.height;
    //                    }
    //                    balanceMoney += redMoney;
    //                    redMoney = 0;
    //                    isBalanceEnough = YES;
    //                }else{
    //                    isBalanceEnough = NO;
    //                    redMoney = 0;
    //                }
    //
    //            }
    //        }break;
    //        case 1:{
    //            MyLog(@"余额%@",sender.on ? @"开" : @"关");
    //            if(sender.on){
    //
    //                balanceMoney = tempBalanceMoney-tempRedMoney;
    //
    //                tempBalanceMoney = 0;
    //            }else{
    //                tempBalanceMoney = balanceMoney;
    //
    //                balanceMoney = 0;
    //            }
    //        }break;
    //        default:break;
    //    }
    
    switch(sender.tag-300){
        case 0:{
            MyLog(@"红包%@",sender.on ? @"开" : @"关");
            if (couponButtton.selected) {
                couponButtton.selected = NO;
                [self changePayBtnSelectedIcon:couponButtton];
            }
            if(sender.on){
                
                redMoney = tempRedMoney;
                
                tempRedMoney = 0;
                
                if(isBalanceEnough){
                    if(switchBalance.on){
                        balanceMoney -= redMoney;
                    }else{
                        tempBalanceMoney -= redMoney;
                        balanceMoney = 0;
                    }
                    
                    //                    if(balanceUsedView.hidden){
                    //                        balanceUsedView.hidden = NO;
                    //                        totalHeight += balanceUsedView.frame.size.height;
                    //                    }
                }
                [self useDiscountCoupon];
            }else{
                tempRedMoney = redMoney;
                if([wallertDict[@"balanceAmount"] floatValue] >= (balanceMoney+redMoney) && switchBalance.on && [wallertDict[@"balanceAmount"] floatValue] != 0){
                    //                    if(balanceUsedView.hidden){
                    //                        balanceUsedView.hidden  = NO;
                    //                        totalHeight += balanceUsedView.frame.size.height;
                    //                    }
                    balanceMoney += redMoney;
                    redMoney = 0;
                    isBalanceEnough = YES;
                }else{
                    isBalanceEnough = NO;
                    redMoney = 0;
                }
                [self nonUseDiscountCoupon];
                if(!(weixinButton.selected || balanceButton.selected)) {
                    zhifubaoButton.selected = YES;
                }
                //不使用优惠劵时，恢复现场
                [payInfoView setDataDict:self.dataDict];
                totalCountLabel.text = payInfoView.priceLabel.text;
                
            }
        }break;
        case 1:{
            MyLog(@"余额%@",sender.on ? @"开" : @"关");
            if(sender.on){
                weixinButton.selected = NO;
                [weixinButton setImage:[UIImage imageNamed:@"mycar_noclick"] forState:UIControlStateNormal];
                zhifubaoButton.selected = NO;
                [zhifubaoButton setImage:[UIImage imageNamed:@"mycar_noclick"] forState:UIControlStateNormal];
                balanceMoney = tempBalanceMoney-tempRedMoney;
                
                tempBalanceMoney = 0;
                payMethodString = @"yue";
            }else{
                weixinButton.selected = NO;
                [weixinButton setImage:[UIImage imageNamed:@"mycar_noclick"] forState:UIControlStateNormal];
                zhifubaoButton.selected = YES;
                [zhifubaoButton setImage:[UIImage imageNamed:@"mycar_click"] forState:UIControlStateNormal];
                tempBalanceMoney = balanceMoney;
                
                balanceMoney = 0;
                
                //                balanceUsedView.hidden = YES;
                //                totalHeight -= balanceUsedView.frame.size.height;
                isBalanceEnough = NO;
                //                sender.on = YES;
            }
        }break;
        default:break;
    }
    
    
    payMoney = settleMoney-redMoney-balanceMoney;
    
    //    if(payMoney != 0 && !isAddHeight){
    //        payMethodView.hidden = NO;
    //        totalHeight += payMethodView.frame.size.height;
    //        isAddHeight = YES;
    //    }
    //    if(payMoney == 0 && isAddHeight){
    //        payMethodView.hidden = YES;
    //        totalHeight -= payMethodView.frame.size.height;
    //        isAddHeight = NO;
    //    }
    
    //    if(payMoney){
    //        if(payMethodView.hidden){
    //            isAddHeight = YES;
    //        }
    //        payMethodView.hidden = NO;
    //    }else{
    //        if(!payMethodView.hidden){
    //            isAddHeight = NO;
    //        }
    //        payMethodView.hidden = YES;
    //    }
    
    [self updateUI];
}
-(void)initialScrollView{
    _myScrollView.contentSize = CGSizeMake(kSizeOfScreen.width, totalHeight);
}
- (void)changePayBtnSelectedIcon:(UIButton *)btn {
    if (btn.selected) {
        [btn setImage:[UIImage imageNamed:@"mycar_click"] forState:UIControlStateNormal];
    } else {
        [btn setImage:[UIImage imageNamed:@"mycar_noclick"] forState:UIControlStateNormal];
    }
}
#pragma mark -=============================OtherCallBack
/**支付按钮*/
-(void)payButtonClicked:(UIButton*)sender{
//    for(int i=0; i<PAYMETHOD; i++){
//        UIButton* button = (UIButton*)[self.view viewWithTag:200+i];
//        button.selected = NO;
//    }
    payMoney = [[payInfoView.priceLabel.text substringFromIndex:1] floatValue];
    payMethodNum = sender.tag-200;
    payMethodString = sender.titleLabel.text;
    
    
    UISwitch* balanceSwitch = (UISwitch *)[self.view viewWithTag:301];
    balanceSwitch.on = NO;
    
    switch(payMethodNum){
        case 0:{
            MyLog(@"%@",sender.titleLabel.text);
            zhifubaoButton.selected = YES;
            weixinButton.selected = NO;
            balanceButton.selected = NO;
            couponButtton.selected = NO;
        }break;
        case 1:{
            MyLog(@"%@",sender.titleLabel.text);
            zhifubaoButton.selected = NO;
            weixinButton.selected = YES;
            balanceButton.selected = NO;
            couponButtton.selected = NO;
        }break;
        case 2:{
            sender.selected = YES;
            MyLog(@"%@",sender.titleLabel.text);
            zhifubaoButton.selected = NO;
            weixinButton.selected = NO;
            balanceButton.selected = YES;
            couponButtton.selected = NO;
        }break;
            case 3:
            sender.selected = YES;
            MyLog(@"%@",sender.titleLabel.text);
            zhifubaoButton.selected = NO;
            weixinButton.selected = NO;
            balanceButton.selected = NO;
            couponButtton.selected = YES;
            redSwitch.on = NO;
            [self nonUseDiscountCoupon];
        default:break;
    }
    [self changePayBtnSelectedIcon:weixinButton];
    [self changePayBtnSelectedIcon:zhifubaoButton];
    [self changePayBtnSelectedIcon:balanceButton];
    [self changePayBtnSelectedIcon:couponButtton];
}
#pragma mark 使用优惠劵
- (void)getCoupons {
    [HttpHelper discountCouponListWithUserId:userInfo.desc
                                       token:userInfo.token
                                   serviceId:self.dataDict[@"goods_id"]
                                     success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                         NSLog(@"优惠劵列表 :%@",responseObjcet);
                                         NSDictionary *dict = (NSDictionary *)responseObjcet;
                                         NSString *code = dict[@"code"];
                                         userInfo.token = dict[@"token"];
                                         if ([code isEqualToString:SERVICE_SUCCESS]) {
                                             _coupons = dict[@"msg"];
                                         } else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                         } else {
                                             [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                         }
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         [MBProgressHUD showError:@"请求失败，请重试" toView:self.view];
                                     }];
}
- (void)createDiscountCouponUI:(NSArray *)couponList {
    discountCouponView = [[UIView alloc] initWithFrame:CGRectMake(5,CGRectGetMaxY(redPackageUsedView.frame), kSizeOfScreen.width, 60 * couponList.count)];
    
    for (int i = 0; i < couponList.count; i++) {
        UIImageView *discountCouponImageLeft = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10 + i*60 , discountCouponView.frame.size.width * 0.5, 40)];
        discountCouponImageLeft.image = [UIImage imageNamed:@"lightCoupon"];
        discountCouponImageLeft.contentMode = UIViewContentModeScaleToFill;
        UILabel *couponMoney = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, discountCouponImageLeft.frame.size.width, 20)];
        couponMoney.text = [NSString stringWithFormat:@"%@ 元",_coupons[i][@"coupon"][@"amount"]];
        couponMoney.textAlignment = NSTextAlignmentLeft;
        couponMoney.font = [UIFont systemFontOfSize:12];
        couponMoney.textColor = [UIColor whiteColor];
        UILabel *bottomLeft = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, discountCouponImageLeft.frame.size.width, 20)];
        bottomLeft.text = @"全场通用优惠劵";
        bottomLeft.textAlignment = NSTextAlignmentLeft;
        bottomLeft.font = [UIFont systemFontOfSize:12];
        bottomLeft.textColor = [UIColor whiteColor];
        [discountCouponImageLeft addSubview:couponMoney];
        [discountCouponImageLeft addSubview:bottomLeft];
        [discountCouponView addSubview:discountCouponImageLeft];
        
        UIImageView *discountCouponImageRight = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(discountCouponImageLeft.frame)+1, 10 + i*60, discountCouponView.frame.size.width * 0.3, 40)];
        discountCouponImageRight.image = [UIImage imageNamed:@"darkCoupon"];
        discountCouponImageRight.contentMode = UIViewContentModeScaleToFill;
        UILabel *couponTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, discountCouponImageRight.frame.size.width, 40)];
        couponTypeLabel.textAlignment = NSTextAlignmentCenter;
        couponTypeLabel.font = [UIFont systemFontOfSize:12];
        couponTypeLabel.textColor = [UIColor whiteColor];
        NSString *couponType = [NSString stringWithFormat:@"%@",_coupons[i][@"coupon"][@"type"]];
        if ([couponType isEqualToString:@"SPECIFY"]) {
            couponTypeLabel.text = @"特殊优惠劵";
        } else {
           couponTypeLabel.text = @"通用优惠劵";
        }
        [discountCouponImageRight addSubview:couponTypeLabel];
        [discountCouponView addSubview:discountCouponImageRight];
        
        UIButton *discountCouponBtn = [[UIButton alloc] init];
        discountCouponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        discountCouponBtn.frame = CGRectMake(0, 1 + i*58, kSizeOfScreen.width, 58);
        [discountCouponBtn setImage:[UIImage imageNamed:@"mycar_noclick"] forState:UIControlStateNormal];
        [discountCouponBtn setImage:[UIImage imageNamed:@"mycar_click"] forState:UIControlStateSelected];
        [discountCouponBtn setImageEdgeInsets:UIEdgeInsetsMake(0, kSizeOfScreen.width-65, 0, 0)];
        discountCouponBtn.tag = 1000 + i;
        [discountCouponBtn addTarget:self action:@selector(selecteDiscountCoupon:) forControlEvents:UIControlEventTouchUpInside];
        [discountCouponView addSubview:discountCouponBtn];
        [_couponsSelectedBtn addObject:discountCouponBtn];
        
        UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(discountCouponImageLeft.frame) + 9, kSizeOfScreen.width, 1)];
        spaceView.backgroundColor = [UIColor whiteColor];
        [discountCouponView addSubview:spaceView];
    }
    totalHeight += discountCouponView.frame.size.height;
    [_myScrollView addSubview:discountCouponView];
}
- (void)useDiscountCoupon {
    if (_coupons.count == 0) {
        [MBProgressHUD showError:@"没有可用优惠劵哦" toView:self.view];
        return;
    }
    [self createDiscountCouponUI:_coupons];
    NSLog(@"useDiscountCoupon");
}
- (void)nonUseDiscountCoupon {
    totalHeight -= discountCouponView.frame.size.height;
    CGRect frame = CGRectMake(0, 0, kSizeOfScreen.width, 0);
    discountCouponView.frame = frame;
    [discountCouponView removeSubviews];
    NSLog(@"nonUseDiscountCoupon");
}
#pragma mark 选择优惠劵按钮点击事件
- (void)selecteDiscountCoupon:(UIButton *)sender {
    //重新选择优惠劵，复原确认订单钱的UI信息
    [payInfoView setDataDict:self.dataDict];
    totalCountLabel.text = payInfoView.priceLabel.text;
    redMoney = 0;
    redLabel.text = [NSString stringWithFormat:@"使用优惠劵抵用%.2f元",redMoney];
    
    for(int i=0; i<_coupons.count; i++){
        UIButton* button = (UIButton*)[self.view viewWithTag:1000+i];
        button.selected = NO;
    }
    sender.selected = YES;
    int index = (int)sender.tag - 1000;
    
    redMoney = [[NSString stringWithFormat:@"%@",_coupons[index][@"coupon"][@"amount"]] floatValue];
    redLabel.text = [NSString stringWithFormat:@"使用优惠劵抵用%.2f元",redMoney];
    NSLog(@"coupon pay %f",redMoney);
    payMoney = [[payInfoView.priceLabel.text substringFromIndex:1] floatValue];
    payMoney = payMoney - redMoney;
    if (payMoney < 0) {
        payMoney = 0;
    }
    NSLog(@"pay :%f",payMoney);
    payInfoView.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",payMoney];
    totalCountLabel.text = payInfoView.priceLabel.text;
}

/**确认订单按钮*/
-(void)comfimButtonClicked:(UIButton*)sender{
/*
    以下是新版支付方式
*/
    
//    CWSPaySuccessViewController* testSuccessVc = [CWSPaySuccessViewController new];
//    testSuccessVc.dataDict = @{@"price":@"0.01",@"goods_name":@"普洗（5座轿车）",@"order_sn":@"20151228-01-21423270",@"effectiveTime":@"72小时",@"order_id":@"11",@"store_name":@"重庆洗车"};
//    [self.navigationController pushViewController:testSuccessVc animated:YES];
    
   
    
//    NSDictionary* paramDict = @{
////                                @"uid":KUserManager.uid,
//                                @"uid":userInfo.desc,
////                                @"mobile":KUserManager.mobile,
//                                @"mobile":@"18280068114",
//                                @"appid":@"app_j5qbP4Dib5uHTe5C",
//                                @"amount":[NSString stringWithFormat:@"%d",(int)(payMoney*100)], //paymoney
//                                @"channel":payMethodString,
//                                @"currency":@"cny",
//                                @"subject":self.dataDict[@"goods_name"],
//                                @"body":[NSString stringWithFormat:@"车生活%@服务支付",self.dataDict[@"goods_name"]],
//                                @"red":[NSString stringWithFormat:@"%d",(int)(redMoney*100)],//redmoney
//                                @"money":[NSString stringWithFormat:@"%d",(int)(balanceMoney*100)], //balancemoney
//                                @"order_sn":[NSString stringWithFormat:@""],
//                                @"store_id":self.dataDict[@"store_id"],
//                                @"goods_id":self.dataDict[@"goods_id"],
//                                @"price":[NSString stringWithFormat:@"%d",(int)(settleMoney*100)] //settlemoney
//                                        };
//    
//    MyLog(@"-------------生成支付订单的参数-------------%@",paramDict);
//    MyLog(@"支付方式:%@-支付金额:%.2f",payMethodString,payMoney);
    if(payMoney){
        //在线支付
        [MBProgressHUD showMessag:@"订单提交中..." toView:self.view];
        NSString *paymentType;
        if([payMethodString isEqualToString:@"wx"]){
            paymentType = @"WECHAT";
        }else if([payMethodString isEqualToString:@"alipay"]){
            paymentType = @"ALIPAY";
        }else if([payMethodString isEqualToString:@"yue"]){
            paymentType = @"WALLET";
        }
        
        
        NSLog(@"goods_id is %@", self.dataDict[@"goods_id"]);
        [HttpHelper payServiceWithUserId:userInfo.desc
                                   token:userInfo.token
                               serviceId:self.dataDict[@"goods_id"]
                             paymentType:paymentType
                                recordId:@""
                                couponId:@""
                                 success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
        
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSDictionary* rootDict = [NSDictionary dictionaryWithDictionary:responseObjcet];
//                MyLog(@"----------充值返回信息-----------%@",[PublicUtils showServiceReturnMessage:rootDict[@"msg"]]);
                MyLog(@"----------充值返回信息-----------%@",rootDict);
                if([rootDict[@"code"] isEqualToString:SERVICE_SUCCESS]){
                    
                    if([payMethodString isEqualToString:@"wx"]){
                        //使用微信支付
                        WXPay* thyWeiXinPay = [WXPay shareInstance];
                        thyWeiXinPay.isSuccess = NO;
                        [self WXPayWithParamDict:rootDict[@"msg"]];
                        
                    }else if([payMethodString isEqualToString:@"alipay"]){
                        //使用支付宝支付
                        [self AlipayWithPrice:[NSString stringWithFormat:@"%.2f元",payMoney] andOrderNum:rootDict[@"msg"][@"out_trade_no"]];
                    }else  if([payMethodString isEqualToString:@"yue"]){
                        
                        //余额支付成功后回调
                        [self updateCarServicePayStatus:rootDict];
                        
                        
                    }
                    
                }else{
                    [self alert:@"温馨提示" msg:[PublicUtils showServiceReturnMessage:rootDict[@"desc"]]];
                }
                
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [self alert:@"温馨提示" msg:@"网络出错,请重新加载"];
         }];
    }else{
        //使用红包或者余额支付
        [MBProgressHUD showMessag:@"订单提交中..." toView:self.view];
//        [ModelTool getPayByRedAndBalaceWithParameter:paramDict andSuccess:^(id object) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                NSDictionary* rootDict = [NSDictionary dictionaryWithDictionary:object];
//                MyLog(@"----------红包或余额充值返回信息-----------%@",[PublicUtils showServiceReturnMessage:rootDict[@"message"]]);
//                MyLog(@"----------红包或余额充值返回信息-----------%@",rootDict);
//                if([rootDict[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]){
//                    isPaySuccess = YES;
//                    CWSPaySuccessViewController* paySuccessVc = [CWSPaySuccessViewController new];
//                    [paySuccessVc setDataDict:rootDict[@"data"][@"return"]];
//                    [self.navigationController pushViewController:paySuccessVc animated:YES];
//                }else{
//
//                    [WCAlertView showAlertWithTitle:@"提示" message:[PublicUtils showServiceReturnMessage:rootDict[@"message"]] customizationBlock:nil completionBlock:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                }
//            });
//        } andFail:^(NSError *err) {
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            [self alert:@"温馨提示" msg:@"网络出错,请重新加载"];
//        }];
    }

/*
    以下是PINGPP的支付方式
 */
//    NSDictionary* paramDict = @{
//                                @"uid":KUserManager.uid,
//                                @"mobile":KUserManager.mobile,
//                                @"appid":@"app_j5qbP4Dib5uHTe5C",
//                                @"amount":[NSString stringWithFormat:@"%d",(int)(payMoney*100)],
//                                @"channel":payMethodString,
//                                @"currency":@"cny",
//                                @"subject":self.dataDict[@"goods_name"],
//                                @"body":self.dataDict[@"description"] != nil ? self.dataDict[@"description"] : @"default_description",
//                                @"red":[NSString stringWithFormat:@"%d",(int)(redMoney*100)],
//                                @"money":[NSString stringWithFormat:@"%d",(int)(balanceMoney*100)],
//                                @"order_sn":[NSString stringWithFormat:@""],
//                                @"store_id":self.dataDict[@"merchantsID"],
//                                @"goods_id":self.dataDict[@"id"],
//                                @"price":[NSString stringWithFormat:@"%d",(int)(settleMoney*100)]
//                                        };
//    MyLog(@"-------------生成支付订单的参数-------------%@",paramDict);
//    
//    //向服务器发送支付索要并取得传回的凭据//
//    [MBProgressHUD showMessag:@"订单提交中..." toView:self.view];
//    [ModelTool getPayOrderCreateWithParameter:paramDict andSuccess:^(id object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            MyLog(@"----------支付订单提交返回信息----------%@",object);
//            if([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]){
//                //成功取得凭据后，调用支付控件完成支付//
//                 NSDictionary* dataDict = [NSDictionary dictionaryWithDictionary:object[@"data"]];
//                if([dataDict[@"type"] integerValue] == 1){  //(红包或余额支付用户)
//                    
//                    NSDictionary* currentDataDict = [NSDictionary dictionaryWithDictionary:dataDict[@"return"]];
//                    CWSPaySuccessViewController* paySucVc = [CWSPaySuccessViewController new];
//                    [paySucVc setDataDict:currentDataDict];
//                    [self.navigationController pushViewController:paySucVc animated:YES];
//                    
//                }else{  //(在线支付用户)
//                    
//                    NSDictionary* chargeObject = [NSDictionary dictionaryWithDictionary:dataDict[@"charge"]];
//                    
//                    CWSPayViewController* __weak weakVc = self;
//                    if(payMethodNum == 1){
//                        
//                        if([WXApi isWXAppInstalled]){
//                            [Pingpp createPayment:chargeObject viewController:weakVc appURLScheme:@"MyPayUrlScheme" withCompletion:^(NSString *result, PingppError *error) {
//                                if([result isEqualToString:@"success"]){
//                                    
//                                    MyLog(@"支付成功!");
//                                
//                                }else{
//
//                                    [MBProgressHUD showError:[error getMsg] toView:self.view];
//                                }
//                            }];
//                        }else{
//                            [WCAlertView showAlertWithTitle:@"温馨提示" message:@"您还没有安装微信客户端哦" customizationBlock:nil completionBlock:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//                        }
//                    }else{
//            
//                        [Pingpp createPayment:chargeObject viewController:weakVc appURLScheme:@"MyPayUrlScheme" withCompletion:^(NSString *result, PingppError *error) {
//                            if([result isEqualToString:@"success"]){
//                                
//                                MyLog(@"支付成功!");
//                                
//                            }else{
//                                [MBProgressHUD showError:[error getMsg] toView:self.view];
//                            }
//                        }];
//                        
//                    }
//                }
//                
//            }else{
//                [WCAlertView showAlertWithTitle:@"温馨提示" message:object[@"message"] customizationBlock:nil completionBlock:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            }
//        });
//    } andFail:^(NSError *err) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        [WCAlertView showAlertWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%@",err] customizationBlock:nil completionBlock:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    }];
    
}
#pragma mark =======================余额支付成功后回调

-(void)updateCarServicePayStatus:(NSDictionary *)rootDict{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:KUserInfo.desc,@"userId",KUserInfo.token,@"token",rootDict[@"desc"],@"recordId",@"PAID",@"chargeStatus", nil];
    [MBProgressHUD showMessag:@"正在生成订单..." toView:self.view];
    [HttpHelper updateCarServicePayStatusWithUserDic:dic success:^(AFHTTPRequestOperation*operation, id object){
        NSLog(@"正在生成订单%@",object);
        NSDictionary *dataD = (NSDictionary *)object;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([dataD[@"code"] isEqualToString:SERVICE_SUCCESS]){
            CWSPaySuccessViewController* paySuccessVc = [CWSPaySuccessViewController new];
            
            NSDictionary *successData = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSString stringWithFormat:@"%@", self.dataDict[@"store_name"]],
                                         @"store_name",
                                         [NSString stringWithFormat:@"%@", self.dataDict[@"goods_name"]],
                                         @"goods_name",
                                         [NSString stringWithFormat:@"%@", self.dataDict[@"discount_price"]],
                                         @"price",
                                         rootDict[@"msg"][@"out_trade_no"],
                                         @"order_sn",
                                         rootDict[@"desc"],
                                         @"orderId",
                                         self.dataDict[@"categoryName"],
                                         @"categoryName",
                                         nil];
            
       
            [paySuccessVc setDataDict:successData];
            [self.navigationController pushViewController:paySuccessVc animated:YES];
        }else{
            [self alert:@"温馨提示" msg:[PublicUtils showServiceReturnMessage:dataD[@"desc"]]];
        }
    } failure:^(AFHTTPRequestOperation *operation ,NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self alert:@"温馨提示" msg:@"网络出错,请重新加载"];
    }];
}
#pragma mark -======================支付的方法回调
/**新版微信支付*/
-(void)WXPayWithParamDict:(NSDictionary*)thyDict{
    NSString* time_stamp, *nonce_str, *package;
    time_t now;
    time(&now);
    time_stamp = [NSString stringWithFormat:@"%ld",now];
    nonce_str = [WXUtil md5:time_stamp];
    package = @"Sign=WXPay";
    NSMutableDictionary* signParams = [NSMutableDictionary dictionary];
    [signParams setObject:APP_ID forKey:@"appid"];
    [signParams setObject:nonce_str forKey:@"noncestr"];
    [signParams setObject:package forKey:@"package"];
    [signParams setObject:MCH_ID forKey:@"partnerid"];
    [signParams setObject:time_stamp forKey:@"timestamp"];
    [signParams setObject:[NSString stringWithFormat:@"%@",thyDict[@"prepay_id"]] forKey:@"prepayid"];
    
    //生成签名
    NSString *sign  = [self createMd5Sign:signParams];
    
    //添加签名
    [signParams setObject:sign forKey:@"sign"];
    
    PayReq* request = [[PayReq alloc]init];
    request.openID = APP_ID;
    request.partnerId = MCH_ID;
    request.nonceStr = signParams[@"noncestr"];
    request.package = signParams[@"package"];
    request.prepayId = signParams[@"prepayid"];
    request.sign = signParams[@"sign"];
    request.timeStamp = [signParams[@"timestamp"] intValue];
    [WXApi sendReq:request];
    [[WXPay shareInstance]setPaySucc:^{
//        [self alert:@"温馨提示" msg:@"支付完成!"];
//        [self.navigationController popViewControllerAnimated:YES];
        //  [self checkLoginOrNo];
        [MBProgressHUD showMessag:@"支付完成,跳转中..." toView:self.view];
        [ModelTool getPayFinishInfoWithParameter:@{@"uid":KUserManager.uid,@"order_sn":thyDict[@"out_trade_no"]} andSuccess:^(id object) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                MyLog(@"----------支付完成返回信息----------%@",object);
                if([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]){
                    isPaySuccess = YES;
                    CWSPaySuccessViewController* paySuccessVc = [CWSPaySuccessViewController new];
                    paySuccessVc.dataDict = object[@"data"][@"return"];
                    [self.navigationController pushViewController:paySuccessVc animated:YES];
                    
                }else{
                    [WCAlertView showAlertWithTitle:@"温馨提示" message:[PublicUtils showServiceReturnMessage:object[@"message"]] customizationBlock:nil completionBlock:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                }
            });
        } andFail:^(NSError *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [WCAlertView showAlertWithTitle:@"温馨提示" message:@"网络出错,请重新加载" customizationBlock:nil completionBlock:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        }];
    }];
}

/**支付宝支付*/
-(void)AlipayWithPrice:(NSString*)thyPrice andOrderNum:(NSString*)thyOrderNum{
    [[WQPay shareInstance]payProductArray:thyPrice AndOrderID:thyOrderNum];
    [[WQPay shareInstance] setPaySucc:^{
//        [self alert:@"提示" msg:@"支付完成!"];
//        [self.navigationController popViewControllerAnimated:YES];
        //  [self checkLoginOrNo];
        [MBProgressHUD showMessag:@"支付完成,跳转中..." toView:self.view];
        [ModelTool getPayFinishInfoWithParameter:@{@"uid":KUserManager.uid,@"order_sn":thyOrderNum} andSuccess:^(id object) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                MyLog(@"----------支付完成返回信息----------%@",object);
                if([object[@"state"] isEqualToString:SERVICE_STATE_SUCCESS]){
                    
                    isPaySuccess = YES;
                    CWSPaySuccessViewController* paySuccessVc = [CWSPaySuccessViewController new];
                    paySuccessVc.dataDict = object[@"data"][@"return"];
                    [self.navigationController pushViewController:paySuccessVc animated:YES];
                    
                    
                }else{
                    [WCAlertView showAlertWithTitle:@"温馨提示" message:[PublicUtils showServiceReturnMessage:object[@"message"]] customizationBlock:nil completionBlock:nil cancelButtonTitle:@"" otherButtonTitles:nil, nil];
                }
            });
        } andFail:^(NSError *err) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [WCAlertView showAlertWithTitle:@"温馨提示" message:@"网络出错,请重新加载" customizationBlock:nil completionBlock:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        }];
    }];
}



#pragma mark -======================其他方法的回调
//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
}

-(NSString*) createMd5Sign:(NSMutableDictionary*)dict{
    
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", PARTNER_ID];
    //得到MD5 sign签名
    NSString *md5Sign =[WXUtil md5:contentString];
    
    MyLog(@"-------关键字串---------%@",contentString);
    MyLog(@"-------生成的md5------%@",md5Sign);
    
    
    return md5Sign;
}

-(void)backClicked:(UIBarButtonItem*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
