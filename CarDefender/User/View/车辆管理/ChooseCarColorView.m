//
//  ChooseCarColorView.m
//  pickerView
//
//  Created by 李散 on 15/4/26.
//  Copyright (c) 2015年 Mr Li. All rights reserved.
//

#import "ChooseCarColorView.h"

@implementation ChooseCarColorView
-(void)buildView{
    self.backgroundColor=[UIColor clearColor];
//    self.alpha=0.5;
    pickerVeiw=[[UIPickerView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-216, self.frame.size.width, 216)];
    pickerVeiw.delegate=self;
    pickerVeiw.dataSource=self;
    pickerVeiw.showsSelectionIndicator=YES;
    [self addSubview:pickerVeiw];
    NSArray *dataArray = [[NSArray alloc]initWithObjects:@"黑色",@"白色",@"红色",@"蓝色",@"绿色",@"银灰色",@"黄色", nil];
    pickerArray=dataArray;
    pickerVeiw.backgroundColor=[UIColor whiteColor];
    pickerVeiw.alpha=1;
    
    UIView*view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfScreen.width, self.frame.size.height-pickerVeiw.frame.size.height-30)];
    view1.backgroundColor=KBlackMainColor;
    view1.alpha=0.5;
    [self addSubview:view1];
    UITapGestureRecognizer*tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchDownGesture:)];
    [view1 addGestureRecognizer:tapGesture1];
    
    UIView*viewLineView=[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-pickerVeiw.frame.size.height-30, self.frame.size.width, 30)];
    [self addSubview:viewLineView];
    viewLineView.backgroundColor=[UIColor whiteColor];
    
    //     添加按钮
    CGRect frame = CGRectMake(self.frame.size.width-80-20,5, 80, 30);
    
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    selectButton.frame=frame;
    selectButton.backgroundColor=[UIColor whiteColor];
    [selectButton setTitle:@"确定" forState:UIControlStateNormal];
    [selectButton setTitleColor:kCOLOR(255, 147, 25) forState:UIControlStateNormal];
    [Utils setViewRiders:selectButton riders:4];
    [Utils setBianKuang:kCOLOR(255, 147, 25) Wide:1 view:selectButton];
    
    [selectButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewLineView addSubview:selectButton];
    
    CGRect frame1 = CGRectMake(20,5, 80, 30);
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [Utils setViewRiders:cancelButton riders:4];
    cancelButton.frame=frame1;
    cancelButton.backgroundColor=[UIColor whiteColor];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:kCOLOR(255, 147, 25) forState:UIControlStateNormal];
    [Utils setBianKuang:kCOLOR(255, 147, 25) Wide:1 view:cancelButton];
    
    [cancelButton addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewLineView addSubview:cancelButton];
}
-(void)cancelPressed:(UIButton*)sender
{
    [self removeFromSuperview];
    [self.delegate chooseCarColorViewTouch];
}
-(void) buttonPressed:(id)sender
{
    NSInteger row =[pickerVeiw selectedRowInComponent:0];
    NSString *selected = [pickerArray objectAtIndex:row%7];
    [self.delegate chooseCarColorWithColorTitle:selected];
    [self removeFromSuperview];
    
}
#pragma mark - 返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
#pragma mark - 返回当前显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 50;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerArray objectAtIndex:row%7];
}
-(void) pickerView: (UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent: (NSInteger)component
{
    NSLog(@"%@",pickerArray[row%7]);
}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self removeFromSuperview];
//    [self.delegate chooseCarColorViewTouch];
//}
-(void)touchDownGesture:(UITapGestureRecognizer*)sender
{
    [self removeFromSuperview];
    [self.delegate chooseCarColorViewTouch];

}
@end
