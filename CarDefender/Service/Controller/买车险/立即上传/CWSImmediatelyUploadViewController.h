//
//  CWSImmediatelyUploadViewController.h
//  CarDefender
//
//  Created by 万茜 on 15/12/7.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CWSImmediatelyUploadViewController : UIViewController

@property (nonatomic,strong)UIButton *headTakePhotoBtn;//上面拍照
@property (nonatomic,strong)UIButton *headChooseBtn;//上面选取
@property (nonatomic,strong)UIButton *footTakePhotoBtn;//下面拍照
@property (nonatomic,strong)UIButton *footChooseBtn;//下面选取
@property (nonatomic,strong)UIButton *immediatelySubmitBtn;//立即提交

@property (nonatomic,strong)UIView   *mainView;
@property (nonatomic,strong)UIView   *headPhotoCustomView;//上面拍照的view
@property (nonatomic,strong)UIView   *footPhotoCusstomView;//下面拍照的view
@property (nonatomic,strong)UIImageView *headImageView;
@property (nonatomic,strong)UIImageView *footImageView;

@end
