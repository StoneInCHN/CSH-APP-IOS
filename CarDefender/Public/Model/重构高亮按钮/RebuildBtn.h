//
//  RebuildBtn.h
//  按钮高亮
//
//  Created by 李散 on 15/4/25.
//  Copyright (c) 2015年 Mr Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RebuildBtn : UIButton
-(void)setTitle:(NSString*)titleString withColorNormalAndHighlight:(NSArray*)colorArray withImageNormalAndHighlight:(NSArray*)imageArray;
@end
