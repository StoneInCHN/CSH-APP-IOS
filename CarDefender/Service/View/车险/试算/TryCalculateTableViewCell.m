//
//  TryCalculateTableViewCell.m
//  CarDefender
//
//  Created by 万茜 on 15/12/9.
//  Copyright © 2015年 SKY. All rights reserved.
//

#import "TryCalculateTableViewCell.h"

@interface TryCalculateTableViewCell()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *backView;
}
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
- (IBAction)cellClick:(UIButton *)sender;

@end

@implementation TryCalculateTableViewCell

- (void)awakeFromNib {
    [self.dropDownButton addTarget:self action:@selector(dropDownButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 下拉按钮
- (void)dropDownButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        
//        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.dropDownButton.endX+65, 40, self.dropDownButton.W, 150) style:UITableViewStylePlain];
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.3;
        [window addSubview:backView];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 120, [UIScreen mainScreen].bounds.size.width-40, 240) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.layer.cornerRadius = 10;
        self.tableView.clipsToBounds = YES;
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        self.tableView.tableFooterView = [[UIView alloc] init];
        [window addSubview:self.tableView];
        
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesture)];
        [backView addGestureRecognizer:gesture];
    }
    else {
//        [self.tableView removeFromSuperview];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)gesture
{
    [backView removeFromSuperview];
    [self.tableView removeFromSuperview];
}



- (IBAction)cellClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (sender.selected) {
        self.footImageView.image = [UIImage imageNamed:@"chexian_xuan"];
        [dic setValue:self.moneyLabel.text forKey:@"money"];
        [dic setValue:@"1" forKey:@"tag"];

    }
    else{
        self.footImageView.image = [UIImage imageNamed:@"message_xuanzhongno"];
        [dic setValue:self.moneyLabel.text forKey:@"money"];
        [dic setValue:@"0" forKey:@"tag"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"moneyClick" object:nil userInfo:dic];    
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return _dataArray.count;
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellname = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellname];
    if (cell == nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellname];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"3333";
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [backView removeFromSuperview];
    [self.tableView removeFromSuperview];
}


@end
