//
//  CWSBuyCarInsuranceViewController.h
//  CarDefender
//
//  Created by 万茜 on 15/12/7.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSBuyCarInsuranceViewController : UIViewController

@property (nonatomic,strong)UILabel *notCardLabel;//未上传行驶证
@property (nonatomic,strong)UILabel *carLabel;//车辆
@property (nonatomic,strong)UIButton *immediatelyUploadButton;//立即上传
@property (nonatomic,strong)UIButton *changeCarButton;//切换车辆
@property (nonatomic,strong)UILabel *insuredCityLabel;//投保城市
@property (nonatomic,strong)UILabel *brandCarsLabel;//品牌车系
@property (nonatomic,strong)UILabel *insuredCarLabel;//投保车辆
@property (nonatomic,strong)UILabel *carModelsLabel;//车型
@property (nonatomic,strong)UIButton *tryCalculateButton;//试算

@end
