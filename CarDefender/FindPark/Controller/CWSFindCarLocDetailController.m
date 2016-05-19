//
//  CWSFindCarLocDetailController.m
//  CarDefender
//
//  Created by 李散 on 15/7/28.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSFindCarLocDetailController.h"
#define kDistanceNomarl 10
@interface CWSFindCarLocDetailController ()
{
    UIScrollView*_scrolView;
}
//@property (nonatomic, strong) NSDictionary*dicMsg;
@end

@implementation CWSFindCarLocDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"停车场详情";
    [Utils changeBackBarButtonStyle:self];
    [self buildUI];
}

-(void)buildUI
{
    _scrolView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, kSizeOfScreen.height)];
    [self.view addSubview:_scrolView];
    
    //顶部停车场详情
    
    UIImageView*imgView = [[UIImageView alloc]initWithFrame:CGRectMake(kDistanceNomarl, 15, 62, 62)];
    [_scrolView addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"zhaochewei_img.png"];
    
    CGFloat topXpoint = imgView.frame.size.width+imgView.frame.origin.x+kDistanceNomarl;
    
    UILabel*nameLabel = [Utils labelWithFrame:CGRectMake(topXpoint, 15, kSizeOfScreen.width-topXpoint - kDistanceNomarl, 20) withTitle:self.park.name titleFontSize:kFontOfSize(16) textColor:kCOLOR(49, 52, 64) alignment:NSTextAlignmentLeft];
    [_scrolView addSubview:nameLabel];
    
    UIImageView*imageAddress = [[UIImageView alloc]initWithFrame:CGRectMake(topXpoint, imgView.frame.size.height+imgView.frame.origin.y-34, 14, 14)];
    [_scrolView addSubview:imageAddress];
    imageAddress.image = [UIImage imageNamed:@"zhaochewei_locationxiangqing.png"];
    
    UILabel*addressLabel = [Utils labelWithFrame:CGRectMake(topXpoint+imageAddress.frame.size.width+kDistanceNomarl-3, imageAddress.frame.origin.y, kSizeOfScreen.width-(topXpoint+imageAddress.frame.size.width+kDistanceNomarl+5) - kDistanceNomarl, 14) withTitle:self.park.addr titleFontSize:kFontOfSize(14) textColor:kCOLOR(121, 124, 128) alignment:NSTextAlignmentLeft];
    [_scrolView addSubview:addressLabel];
    
    
    UIImageView*imageDH = [[UIImageView alloc]initWithFrame:CGRectMake(topXpoint, imgView.frame.size.height+imgView.frame.origin.y-14, 14, 14)];
    [_scrolView addSubview:imageDH];
    imageDH.image = [UIImage imageNamed:@"zhaochewei_fangxiang.png"];
    
    UILabel*dhLabel = [Utils labelWithFrame:CGRectMake(topXpoint+imageDH.frame.size.width+kDistanceNomarl-3, imageDH.frame.origin.y, kSizeOfScreen.width-(topXpoint+imageDH.frame.size.width+kDistanceNomarl+5) - kDistanceNomarl, 14) withTitle:@"500米" titleFontSize:kFontOfSize(14) textColor:kCOLOR(121, 124, 128) alignment:NSTextAlignmentLeft];
    int distance = [self.park.distance intValue];
    if (distance >= 1000) {
        dhLabel.text = [NSString stringWithFormat:@"%.1f千米",(float)distance/1000];
    }else{
        dhLabel.text = [NSString stringWithFormat:@"%i米",distance];
    }
    [_scrolView addSubview:dhLabel];
    
    //分割线
    UIView*viewLineMiddle = [[UIView alloc]initWithFrame:CGRectMake(0, 87, kSizeOfScreen.width, 1)];
    [_scrolView addSubview:viewLineMiddle];
    viewLineMiddle.backgroundColor = kCOLOR(233, 233, 233);
    
    
    //车位信息
    UIImageView*nubWeiImg = [[UIImageView alloc]initWithFrame:CGRectMake(kDistanceNomarl, viewLineMiddle.frame.size.height+viewLineMiddle.frame.origin.y+kDistanceNomarl, 17, 17)];
    [_scrolView addSubview:nubWeiImg];
    nubWeiImg.image=[UIImage imageNamed:@"zhaochewei_cheweixiangqing.png"];
    
    UILabel*nubweiLabel = [Utils labelWithFrame:CGRectMake(nubWeiImg.frame.size.width+kDistanceNomarl+3, nubWeiImg.frame.origin.y, kSizeOfScreen.width-(nubWeiImg.frame.size.width+kDistanceNomarl+3) - kDistanceNomarl, 17) withTitle:@"车位" titleFontSize:kFontOfSize(18) textColor:kCOLOR(61, 154, 250) alignment:NSTextAlignmentLeft];
    [_scrolView addSubview:nubweiLabel];
    
    UILabel*nubOfLabel = [Utils labelWithFrame:CGRectMake(nubWeiImg.frame.size.width+kDistanceNomarl+3, nubweiLabel.frame.origin.y+nubweiLabel.frame.size.height+kDistanceNomarl, kSizeOfScreen.width-(nubWeiImg.frame.size.width+kDistanceNomarl+3) - kDistanceNomarl, 17) withTitle:[NSString stringWithFormat:@"%@/%@",self.park.leftNum,self.park.total] titleFontSize:kFontOfSize(16) textColor:kCOLOR(51, 51, 51) alignment:NSTextAlignmentLeft];
    [_scrolView addSubview:nubOfLabel];
    
    
    //收费详情
    UIImageView*costImg = [[UIImageView alloc]initWithFrame:CGRectMake(kDistanceNomarl, nubOfLabel.frame.size.height+nubOfLabel.frame.origin.y+18, 17, 17)];
    [_scrolView addSubview:costImg];
    costImg.image=[UIImage imageNamed:@"zhaochewei_feiyongxiangqing.png"];
    
    UILabel*costLabel = [Utils labelWithFrame:CGRectMake(nubWeiImg.frame.size.width+kDistanceNomarl+3, nubOfLabel.frame.size.height+nubOfLabel.frame.origin.y+18, kSizeOfScreen.width-(nubWeiImg.frame.size.width+kDistanceNomarl+3) - kDistanceNomarl, 17) withTitle:@"收费详情" titleFontSize:kFontOfSize(18) textColor:kCOLOR(61, 154, 250) alignment:NSTextAlignmentLeft];
    [_scrolView addSubview:costLabel];
    
    
    CGSize costSize = [Utils takeTheSizeOfString:self.park.priceDesc withFont:kFontOfSize(16) withWeight:kSizeOfScreen.width-(nubWeiImg.frame.size.width+kDistanceNomarl+3) - kDistanceNomarl];
    UILabel*costDetailLabel = [Utils labelWithFrame:CGRectMake(nubWeiImg.frame.size.width+kDistanceNomarl+3, costLabel.frame.size.height+costLabel.frame.origin.y+kDistanceNomarl, kSizeOfScreen.width-(nubWeiImg.frame.size.width+kDistanceNomarl+3) - kDistanceNomarl, costSize.height) withTitle:self.park.priceDesc titleFontSize:kFontOfSize(16) textColor:kCOLOR(51, 51, 51) alignment:NSTextAlignmentLeft];
    costDetailLabel.numberOfLines = 0;
    [_scrolView addSubview:costDetailLabel];
    
    
    
    UIButton*leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(kDistanceNomarl, costDetailLabel.frame.size.height+costDetailLabel.frame.origin.y+25, kSizeOfScreen.width/2-kDistanceNomarl*3/2, 40)];
    [leftBtn setTitle:@"预约" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"zhaochewei_phone.png"] forState:UIControlStateNormal];
    [_scrolView addSubview:leftBtn];
    [Utils setViewRiders:leftBtn riders:4];
    [Utils setBianKuang:kCOLOR(233, 233, 233) Wide:1 view:leftBtn];
    
    UIButton*rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(kSizeOfScreen.width/2+kDistanceNomarl/2, costDetailLabel.frame.size.height+costDetailLabel.frame.origin.y+25, kSizeOfScreen.width/2-kDistanceNomarl*3/2, 40)];
    [rightBtn setTitle:@"到这去" forState:UIControlStateNormal];
    [rightBtn setTitleColor:kCOLOR(49, 52, 64) forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"zhaochewei_go.png"] forState:UIControlStateNormal];
    [_scrolView addSubview:rightBtn];
    [Utils setViewRiders:rightBtn riders:4];
    [Utils setBianKuang:kCOLOR(233, 233, 233) Wide:1 view:rightBtn];
    [rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)btnClick:(UIButton*)sender
{
    CLLocationCoordinate2D point = (CLLocationCoordinate2D){[self.park.latitude floatValue], [self.park.longitude floatValue]};
    [self startNaviWithNewPoint:point OldPoint:_oldPt];
}



@end
