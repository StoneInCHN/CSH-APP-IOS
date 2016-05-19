//
//  CWSUserInformationController.m
//  CarDefender
//
//  Created by 周子涵 on 15/3/31.
//  Copyright (c) 2015年 SKY. All rights reserved.
//

#import "CWSUserInformationController.h"
#import "PersonHeadTableViewCell.h"
#import "PersonTitleTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "CWSNikenameViewController.h"
#import "CWSUserPersonalSignatureController.h"
#import "CWSUserCenterObject.h"

NSString *UPLOAD_IMG_PATH = @"";

@interface CWSUserInformationController ()<UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    NSArray     *_titleArray;//标题数组
    CWSUserCenterObject *userCenter;
    PersonHeadTableViewCell *headCell;
    NSMutableArray *cellArray;
    NSString    *nikeNameString;
    NSString    *signatureString;
    UserInfo *userInfo;
}

@end

@implementation CWSUserInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils changeBackBarButtonStyle:self];
    self.title = @"个人信息";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    userInfo = [UserInfo userDefault];
    [self initDataSource];
    self.tableView = (UITableView *)[self.view viewWithTag:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init]; 
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
#pragma mark - 数据源
- (void)initDataSource
{
    _titleArray = @[@"昵称",@"我的签名",@"手机号"];
    cellArray = [NSMutableArray array];
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 90;
    }
    else {
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //头像栏
    if (indexPath.row == 0) {
        
        UINib *nib = [UINib nibWithNibName:@"PersonHeadTableViewCell" bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:@"personHeadTableViewCell"];
        headCell = [[PersonHeadTableViewCell alloc] init];
        headCell = [tableView dequeueReusableCellWithIdentifier:@"personHeadTableViewCell" forIndexPath:indexPath];
        headCell.backgroundColor = [UIColor whiteColor];
        headCell.tag = 100;
        [headCell.headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/csh-interface%@",SERVERADDRESS,[UserInfo userDefault].photo]] placeholderImage:[UIImage imageNamed:@"infor_moren.png"] options:SDWebImageLowPriority | SDWebImageRetryFailed|SDWebImageProgressiveDownload];
        
        headCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return headCell;
    }
    
    //信息栏
    else {
        UINib *nib = [UINib nibWithNibName:@"PersonTitleTableViewCell" bundle:[NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:@"personTitleTableViewCell"];
        PersonTitleTableViewCell *cell = [[PersonTitleTableViewCell alloc] init];
        cell = [tableView dequeueReusableCellWithIdentifier:@"personTitleTableViewCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.titleLabel.text = _titleArray[indexPath.row-1];
        switch (indexPath.row) {
            case 1:{
                if ([userInfo.nickName isEqual:[NSNull null]]) {
                    cell.messageLabel.text = userInfo.userName;
                } else {
                    cell.messageLabel.text = userInfo.nickName;
                }
            }
                break;
            case 2:{
                if ([userInfo.signature isEqual:[NSNull null]]) {
                    cell.messageLabel.text = @"请填写";
                } else {
                    cell.messageLabel.text = userInfo.signature;
                }
            }
                break;
            case 3:{
                NSString *telString = [[userInfo.userName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"] mutableCopy];
                cell.messageLabel.text = telString;
                cell.arrowImageView.hidden = YES;
            }
                break;
            default:
                break;
        }
        [cellArray addObject:cell];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
            //头像
        case 0:{
            
            UIActionSheet *menu=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
            [menu showInView:self.view];
        }
            break;
            //昵称
        case 1:{
            CWSNikenameViewController *vc = [[CWSNikenameViewController alloc] init];
            vc.nikeNameString = nikeNameString;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            //我的签名
        case 2:{
            CWSUserPersonalSignatureController *vc = [[CWSUserPersonalSignatureController alloc] init];
            vc.noteString = signatureString;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            //手机号
        case 3:{  
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIActionSheetDelegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex==0){
        //拍照获取
        [self snapImage];
    }else if(buttonIndex==1){
        //相册获取
        [self pickImage];
    }else if(buttonIndex==2){
        [actionSheet removeFromSuperview];
    }
}
#pragma mark - 拍照获取相片
- (void) snapImage{
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    [Utils changeBackBarButtonStyle:ipc];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    ipc.allowsEditing = NO;
    [self presentViewController:ipc animated:YES completion:^{
        
    }];
}
#pragma mark - 从相册获取相片
- (void) pickImage{
    UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
    [Utils changeBackBarButtonStyle:ipc];
    ipc.sourceType= UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    ipc.allowsEditing = NO;
    [self presentViewController:ipc animated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePickerControllerDelegate
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *) info{
    UIImage *img=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
    }
    UIImage *newImg=[self imageWithImageSimple:img scaledToSize:CGSizeMake(300, 300)];
    [self saveImage:newImg WithName:[NSString stringWithFormat:@"%@%@",[self generateUuidString],@".jpg"]];
    
    PersonHeadTableViewCell *cell = (PersonHeadTableViewCell *)[self.view viewWithTag:100];
    cell.headImageView.image=newImg;
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
     [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - 获取图片
-(UIImage *) imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}

#pragma mark - 保存图片
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    NSLog(@"===UPLOAD_IMG_PATH===%@",UPLOAD_IMG_PATH);
    //获取的图片
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // 获取图片完整路径（有图片名）
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    UPLOAD_IMG_PATH = fullPathToFile;
    NSLog(@"===UPLOAD_IMG_PATH===%@",UPLOAD_IMG_PATH);
    UIImage* lImage = [[UIImage alloc] initWithData:imageData];
    CGSize size;
    if (lImage.size.width > lImage.size.height) {
        if (lImage.size.width > 800) {
            size = CGSizeMake(800, lImage.size.height * (800 / lImage.size.width));
        }else
        {
            size = lImage.size;
        }
    }else
    {
        if (lImage.size.height > 800) {
            size = CGSizeMake(lImage.size.width * (800 / lImage.size.height), 800);
        }else
        {
            size = lImage.size;
        }
    }
    lImage = [self imageWithImageSimple:lImage scaledToSize:size];
    NSData *imageData1 = UIImageJPEGRepresentation(lImage,0.8); // 将图片转为NSData， 发送

    //设置头像
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    [self showHudInView:self.view hint:@"头像上传中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVERADDRESS,@"/csh-interface/endUser/editUserPhoto.jhtml"];
    NSDictionary *parameters = @{@"userId":userInfo.desc,@"token":userInfo.token};
    
    [manger POST:url
      parameters:parameters
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData1 name:@"photo" fileName:@"hear.png" mimeType:@"application/octet-stream"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"upload user head image :%@",responseObject);
        NSDictionary *dic = (NSDictionary*)responseObject;
        if ([dic[@"code"] isEqualToString:SERVICE_SUCCESS]) {
            userInfo.photo = dic[@"msg"][@"photo"];
            dispatch_async(dispatch_get_main_queue(), ^{
                PersonHeadTableViewCell *cell = (PersonHeadTableViewCell *)[self.view viewWithTag:100];
                cell.headImageView.image=[UIImage imageWithData:imageData1];
            });
            [self hideHud];
            
        } else {
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"上传头像失败，请重新上传" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@\n%@",operation,error);
        [self hideHud];
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"头像设置失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }];
    
}

- (NSString *)generateUuidString{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    // release the UUID
    CFRelease(uuid);
    return uuidString;
}

/*----通过颜色生成一个纯色的图片----*/
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
