//
//  CWSChooseCarModelView.m
//  CarDefender
//
//  Created by 李散 on 15/4/7.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSChooseCarModelView.h"

@implementation CWSChooseCarModelView

-(void)setModelArray:(NSMutableArray *)modelArray
{
    _currentArray=[NSMutableArray arrayWithArray:modelArray];
    if (_modelTabelView==nil) {
        
        _modelTabelView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _modelTabelView.delegate=self;
        _modelTabelView.dataSource=self;
        [self addSubview:_modelTabelView];
        _modelTabelView.tableFooterView=[[UIView alloc]init];
    }else{
        [_modelTabelView reloadData];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _currentArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*modelID=@"modelID";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:modelID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:modelID];
    }
    cell.textLabel.text=[_currentArray[indexPath.row][@"text"] replaceUnicode];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>0) {
        [self.delegate CWSChooseCarModelViewCellSelect:_currentArray[indexPath.row]];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}
@end
