//
//  CWSCarWashDetailReviewModel.h
//  CarDefender
//
//  Created by 王泰莅 on 15/12/10.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWSCarWashDetailReviewModel : NSObject

/**用户头像*/
@property (nonatomic,copy)  NSString* userHeaderImgUrl;


/**用户昵称*/
@property (nonatomic,copy)  NSString* userNickName;


/**用户评论日期*/
@property (nonatomic,copy)  NSString* userReviewDate;


/**用户评论内容*/
@property (nonatomic,copy)  NSString* userReviewContent;


/**是否有评论图片*/
@property (nonatomic,assign) BOOL isHaveImages;


/**用户评论图片*/
@property (nonatomic,strong) NSArray* reviewImagesArray;


/**是否有评价星级视图*/
@property (nonatomic,assign) BOOL isHaveStarView;


/**评价星星数量*/
@property (nonatomic,assign) int userReviewStarCount;


/**评论cell的高度*/
@property (nonatomic,assign) CGFloat reviewCellHeight;

@end
