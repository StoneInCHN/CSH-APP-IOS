//
//  ProvinceView.m
//  云车宝项目
//
//  Created by renhua on 14-8-6.
//  Copyright (c) 2014年 HCYunAPP. All rights reserved.
//

#import "ProvinceView.h"

@implementation ProvinceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:0.5];
        _oldIndexPath=nil;
    }
    return self;
}
//-(void)setDicMsg:(NSDictionary *)dicMsg
//{
//    [ModelTool httpGetAppGainCityWithParameter:@{@"grade":@"1"} success:^(id object) {
//        MyLog(@"%@\n%@",object[@"message"],object);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.provincesArray=object[@"data"][@"list"];
//            
//        });
//    } faile:^(NSError *err) {
//        
//    }];
//}
-(void)setProvincesArray:(NSArray *)provincesArray
{
    _currentArray=provincesArray;
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(self.frame.size.width*0.3, 0, self.frame.size.width*0.7, self.frame.size.height)];
    _tableview.dataSource=self;
    _tableview.delegate=self;
    [self addSubview:_tableview];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _currentArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellId=@"mycell";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor=[UIColor whiteColor];
    }
    cell.textLabel.text=_currentArray[indexPath.row][@"name"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate provinceViewWithBackMsg:_currentArray[indexPath.row]];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"touchbegan" object:nil];
}
@end
