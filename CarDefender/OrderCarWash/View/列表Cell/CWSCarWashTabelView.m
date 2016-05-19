//
//  CWSCarWashTabelView.m
//  CarDefender
//
//  Created by 周子涵 on 15/8/20.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSCarWashTabelView.h"
#import "CarWashCell.h"

@implementation CWSCarWashTabelView

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"carWashCell";
    CarWashCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CarWashCell" owner:self options:nil][0];
        cell.delegate = self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    Park* park = _dataArray[indexPath.row];
    [cell reloadCell:park];
    return cell;
}

@end
