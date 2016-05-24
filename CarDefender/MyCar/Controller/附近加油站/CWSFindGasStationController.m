//
//  CWSFindGasStationController.m
//  CarDefender
//
//  Created by 周子涵 on 15/6/23.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSFindGasStationController.h"
#import "CWSOilCell.h"
#import "HttpHelper.h"

@interface CWSFindGasStationController ()<BMKGeoCodeSearchDelegate>
{
    BMKGeoCodeSearch*        _geocodesearch;
    BMKReverseGeoCodeOption* _reverseGeocodeSearchOption;
    CLLocationCoordinate2D   _carPoint;
    UserInfo *userInfo;
}
@end

@implementation CWSFindGasStationController
#pragma mark - 更新数据
-(void)getHttpData:(CLLocationCoordinate2D)coordinate nearbyCar:(BOOL)nearbyCar type:(int)type{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [Utils changeBackBarButtonStyle:self];
    [MBProgressHUD showMessag:@"数据加载中..." toView:self.view];
    userInfo = [UserInfo userDefault];
    _oldPt = coordinate;
//    _subCity = KManager.currentSubCity;
//    NSDictionary* dic;
//    if (KUserManager.uid != nil){
//        dic = @{@"lat":[NSString stringWithFormat:@"%f",coordinate.latitude],
//                @"lon":[NSString stringWithFormat:@"%f",coordinate.longitude],
//                @"uid":KUserManager.uid,
//                @"cityName":[_subCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
//                @"keyWord":[self.type stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
//                @"page":@"0",
//                @"size":@"20"};
//    }else{
//        dic = @{@"lat":[NSString stringWithFormat:@"%f",coordinate.latitude],
//                @"lon":[NSString stringWithFormat:@"%f",coordinate.longitude],
//                @"cityName":[_subCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
//                @"keyWord":[self.type stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
//                @"page":@"0",
//                @"size":@"20"};
//    }
    
    [HttpHelper searchGasolineStationWithUserId:userInfo.desc
                                          token:userInfo.token
                                        keyWord:@"加油站"
                                      longitude:userInfo.longitude
                                       latitude:userInfo.latitude
                                        success:^(AFHTTPRequestOperation *operation, id responseObjcet) {
                                            NSLog(@"加油站response :%@",responseObjcet);
                                            NSDictionary *dict = (NSDictionary *)responseObjcet;
                                            NSString *code = dict[@"code"];
                                            userInfo.token = dict[@"token"];
                                            if ([code isEqualToString:SERVICE_SUCCESS]) {
                                                [_dataArray removeAllObjects];
                                                for (NSDictionary* ldic in dict[@"msg"]) {
                                                    Interest* interest = [[Interest alloc] initWithDic:ldic];
                                                    interest.telephone = ldic[@"additionalInformation"][@"telephone"];
                                                    [_dataArray addObject:interest];
                                                }
                                                FindMapData* findMapData = [[FindMapData alloc] init];
                                                findMapData.point = coordinate;
                                                findMapData.nearbyCar = nearbyCar;
                                                findMapData.coordArray = _dataArray;
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [_findMapView reloadData:findMapData type:type];
                                                    if (_dataArray.count > 0) {
                                                        [self reloadFootView:_dataArray[0]];
                                                    }
                                                    [_tableView reloadData];
                                                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                });
                                                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                            }else if ([code isEqualToString:SERVICE_TIME_OUT]) {
                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"TIME_OUT_NEED_LOGIN_AGAIN" object:nil];
                                            } else {
                                                [MBProgressHUD showError:dict[@"desc"] toView:self.view];
                                            }
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           [MBProgressHUD showError:@"请求失败，请重试" toView:self.view];
                                       }];
    
//    [ModelTool httpGainGasWithParameter:dic success:^(id object) {
//        
//        NSDictionary* dic = object;
//        MyLog(@"%@",dic);
//        MyLog(@"%@",dic[@"data"][@"data"][@"message"]);
//        if ([dic[@"operationState"] isEqualToString:@"SUCCESS"]) {
//            [_dataArray removeAllObjects];
//            for (NSDictionary* ldic in dic[@"data"][@"data"][@"pointList"]) {
//                Interest* interest = [[Interest alloc] initWithDic:ldic];
//                interest.telephone = ldic[@"additionalInformation"][@"telephone"];
//                [_dataArray addObject:interest];
//            }
//            FindMapData* findMapData = [[FindMapData alloc] init];
//            findMapData.point = coordinate;
//            findMapData.nearbyCar = nearbyCar;
//            findMapData.coordArray = _dataArray;
//            
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [_findMapView reloadData:findMapData type:type];
//                if (_dataArray.count > 0) {
//                    [self reloadFootView:_dataArray[0]];
//                }
//                [_tableView reloadData];
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            });
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        }else {
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
//        }
//        
//    } faile:^(NSError *err) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络出错，请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }];
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"oilCell";
    CWSOilCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CWSOilCell" owner:self options:nil][0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    Interest* poi = _dataArray[indexPath.row];
    cell.parkNameLabel.text = [NSString stringWithFormat:@"%i.%@",(int)indexPath.row+1,poi.name];
    cell.parkAddressLabel.text = poi.address;
    cell.tel = poi.telephone;
    if ([poi.telephone isEqualToString:@""]) {
        [cell.telBtn setImage:[UIImage imageNamed:@"baoyang_phone"] forState:UIControlStateNormal];
        [cell.telBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
//    if ([poi.lat isEqualToString:@""] || [poi.lng isEqualToString:@""]) {
//        [cell.locationBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        cell.userInteractionEnabled = NO;
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无定位信息 " delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }
    
    cell.lat = poi.lat;
    cell.lon = poi.lng;
    CLLocation * location1 = [[CLLocation alloc] initWithLatitude:_oldPt.latitude longitude:_oldPt.longitude];
    CLLocation * location2 = [[CLLocation alloc] initWithLatitude:[poi.lat floatValue] longitude:[poi.lng floatValue]];
    int meter = [Utils getMetersBefore:location1 Current:location2];
    NSString* meterStr;
    if (meter >= 1000) {
        meterStr = [NSString stringWithFormat:@" %.2f 千米",(float)meter/1000];
    }else{
        meterStr = [NSString stringWithFormat:@" %i 米",meter];
    }
    CGSize size = [Utils takeTheSizeOfString:meterStr withFont:kFontOfSize(13)];
    UILabel* lDistanLabel = [Utils labelWithFrame:CGRectMake(kSizeOfScreen.width - 18 - size.width, 31, size.width, 12) withTitle:meterStr titleFontSize:kFontOfSize(13) textColor:KBlackMainColor alignment:NSTextAlignmentRight];
    [cell.contentView addSubview:lDistanLabel];
    UIImageView* lImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSizeOfScreen.width - 20 - size.width -  14, 31, 12, 12)];
    lImageView.image = [UIImage imageNamed:@"jiayouzhan_location"];
    [cell.contentView addSubview:lImageView];
    return cell;
}
#pragma mark - 重写车辆定位方法
-(void)carLocationPoint:(CLLocationCoordinate2D)point{
    _carPoint = point;
    if (_geocodesearch == nil) {
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
        _geocodesearch.delegate = self;
        _reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    }
    _reverseGeocodeSearchOption.reverseGeoPoint = (CLLocationCoordinate2D){point.latitude, point.longitude};
    BOOL flag = [_geocodesearch reverseGeoCode:_reverseGeocodeSearchOption];
    
    if(flag)
    {
        MyLog(@"反geo检索发送成功");
    }
    else
    {
        MyLog(@"反geo检索发送失败");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"地图检索出错，请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}


#pragma mark - 地图代理协议
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    _subCity = result.addressDetail.district;
    [self getHttpData:_carPoint nearbyCar:YES type:self.findMapViewType];
}
@end
