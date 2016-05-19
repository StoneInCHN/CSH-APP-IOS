//
//  CWSCarMaintainInfoModel.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/7.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWSCarMaintainInfoModel : NSObject{

    NSMutableArray *_realDataArray;// 每组的数据
    BOOL _isShow;// 组的状态，yes显示组，no不显示组
    NSString *_sectionName;// 组名
    NSString* _sectionDetailName;
    BOOL _isNeedShow;
    NSString* _priceLabelText;
}

/**每组的数据*/
@property (nonatomic,strong) NSMutableArray* realDataArray;

/**每组每行的高度*/
@property (nonatomic,strong)  NSMutableArray* cellHeightArray;


/**组名*/
@property (nonatomic,copy)   NSString* sectionName;


/**是否展开*/
@property (nonatomic,assign) BOOL isShow;


/**是否需要展开*/
@property (nonatomic,assign) BOOL isNeedShow;


/**详细组名*/
@property (nonatomic,copy)   NSString* sectionDetailName;


/**价格标签*/
@property (nonatomic,copy)   NSString* priceLabelText;

/**商品类别*/
@property (nonatomic,copy)    NSString* categoryId;

@end
