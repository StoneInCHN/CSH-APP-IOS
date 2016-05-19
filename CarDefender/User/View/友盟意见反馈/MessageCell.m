//
//  MessageCell.m
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "MessageCell.h"
#import "Message.h"
#import "MessageFrame.h"
#import "UIImageView+WebCache.h"
@interface MessageCell ()
{
    UIButton     *_timeBtn;
    UIImageView *_iconView;
    UIButton    *_contentBtn;
    UIActivityIndicatorView*_juhuaView;
}

@end

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // 1、创建时间按钮
        _timeBtn = [[UIButton alloc] init];
        [_timeBtn setTitleColor:KBlackMainColor forState:UIControlStateNormal];
        _timeBtn.titleLabel.font = kTimeFont;
        _timeBtn.enabled = NO;
        [_timeBtn setBackgroundImage:[UIImage imageNamed:@"chat_timeline_bg.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_timeBtn];
        
        // 2、创建头像
        _iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconView];
        
        // 3、创建内容
        _contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contentBtn setTitleColor:KBlackMainColor forState:UIControlStateNormal];

        _contentBtn.titleLabel.font = kContentFont;
        _contentBtn.titleLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_contentBtn];
        _juhuaView = [[UIActivityIndicatorView alloc]init];
        [self.contentView addSubview:_juhuaView];
        [_juhuaView stopAnimating];
        
    }
    return self;
}
-(NSString*)checkMsgWithString:(NSString*)string
{
    NSString * timeStampString = string;
    
    NSTimeInterval _interval=[[timeStampString substringToIndex:10] doubleValue];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM-dd HH:mm"; // @"yyyy-MM-dd HH:mm:ss"
    NSString *time = [fmt stringFromDate:date];
    return time;
}
- (void)setMessageFrame:(MessageFrame *)messageFrame{
    
    _messageFrame = messageFrame;
    Message *message = _messageFrame.message;
    
    // 1、设置时间
    [_timeBtn setTitle:[self checkMsgWithString:message.time] forState:UIControlStateNormal];

    _timeBtn.frame = _messageFrame.timeF;
    
    // 2、设置头像
    if ([message.userType isEqualToString:@"user_reply"]) {
        if (KUserManager.uid!=nil) {
            [_iconView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"baseUrl"],KUserManager.photo]] placeholderImage:[UIImage imageNamed:@"icon01.png"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
            [Utils setViewRiders:_iconView riders:_messageFrame.iconF.size.height/2];
        }else{
            _iconView.image = [UIImage imageNamed:@"icon01.png"];
        }
    }else{
        _iconView.image = [UIImage imageNamed:@"icon02.png"];
    }
    //
    
    _iconView.frame = _messageFrame.iconF;
    // 3、设置内容
    MyLog(@"%@",message.content);
    [_contentBtn setTitle:message.content forState:UIControlStateNormal];
    _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentLeft, kContentBottom, kContentRight);
    _contentBtn.frame = _messageFrame.contentF;
    
    if ([message.userType isEqualToString:@"user_reply"]) {
        _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentRight, kContentBottom, kContentLeft);
    }
    UIImage *normal , *focused;
    if ([message.userType isEqualToString:@"user_reply"]) {//自己
        normal = [UIImage imageNamed:@"chatto_bg_normal.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        focused = [UIImage imageNamed:@"chatto_bg_focused.png"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
        CGRect juhuaFrame=CGRectMake(_contentBtn.frame.origin.x-25, _contentBtn.frame.origin.y+5, 20, 20);
        if ([messageFrame.message.isFailed isEqualToString:@"1"]) {
            _juhuaView.frame=juhuaFrame;
            [_juhuaView startAnimating];
        }
    }else{//别人
        normal = [UIImage imageNamed:@"chatfrom_bg_normal.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        focused = [UIImage imageNamed:@"chatfrom_bg_focused.png"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
    }
    [_contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
    [_contentBtn setBackgroundImage:focused forState:UIControlStateHighlighted];
    
}

@end
