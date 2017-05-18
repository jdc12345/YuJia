//
//  EditPersonalViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/12.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "EditPersonalViewController.h"
#import "UIBarButtonItem+Helper.h"
#import  <AFNetworking.h>
#import <UIImageView+WebCache.h>

@interface EditPersonalViewController ()<UIImagePickerControllerDelegate>
@property (nonatomic, weak) UIImageView *iconV;
@property (nonatomic, weak) UISegmentedControl *genderSel;


@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, weak) UIImageView *userIcon;
@property (nonatomic, strong) UIImage *chooseImage;


@property (nonatomic, weak) UITextField *nameTextF;

@end

@implementation EditPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.title = @"个人信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" normalColor:[UIColor colorWithHexString:@"00bfff"] highlightedColor:[UIColor colorWithHexString:@"00bfff"] target:self action:@selector(changeInfo)];
    [self createSubViews];
    // Do any additional setup after loading the view.
}
- (void)createSubViews{
    UIImageView *iconImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"avatar.jpg"]];
    iconImageV.layer.cornerRadius = 45;
    iconImageV.clipsToBounds = YES;
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeIconImage)];
    [iconImageV addGestureRecognizer:tapGest];
    [self.view addSubview:iconImageV];
    
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(94);
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(90 ,90));
    }];
    self.iconV = iconImageV;
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setTitle:@"更改头像" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [changeBtn addTarget:self action:@selector(changeIconImage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:changeBtn];
    
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageV.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(60 ,11));
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"用户名";
    titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(changeBtn.mas_bottom).with.offset(30);
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(70 ,11));
    }];
    
    
    UITextField *nameTextF = [[UITextField alloc]init];
    nameTextF.font = [UIFont systemFontOfSize:15];
    nameTextF.textColor = [UIColor colorWithHexString:@"333333"];
    nameTextF.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    nameTextF.layer.borderWidth = 1;
    nameTextF.layer.cornerRadius = 2.5;
    nameTextF.clipsToBounds = YES;
    nameTextF.textAlignment = NSTextAlignmentCenter;
    self.nameTextF = nameTextF;
    [self.view addSubview:nameTextF];
    
    [nameTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(15);
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(185 ,30));
    }];
    
    
    UILabel *genderLabel = [[UILabel alloc]init];
    genderLabel.text = @"性 别";
    genderLabel.textColor = [UIColor colorWithHexString:@"666666"];
    genderLabel.font = [UIFont systemFontOfSize:14];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:genderLabel];
    
    [genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTextF.mas_bottom).with.offset(30);
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(70 ,11));
    }];
    
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"男",@"女",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedData];
//    segmentedControl.frame = CGRectMake((kScreenW -150 -20)/2.0, 7,150, 30.0);
    /*
     这个是设置按下按钮时的颜色
     */
    segmentedControl.tintColor = [UIColor colorWithHexString:@"00bfff"];
    segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引、
    [segmentedControl addTarget:self action:@selector(segmentAction) forControlEvents:UIControlEventValueChanged];
    
    self.genderSel = segmentedControl;
    /*
     下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等
     */
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor colorWithHexString:@"666666"], NSForegroundColorAttributeName, nil];
    
    
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor colorWithHexString:@"666666"] forKey:NSForegroundColorAttributeName];
    
    [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    //设置分段控件点击相应事件
    [segmentedControl addTarget:self action:@selector(segmentAction)forControlEvents:UIControlEventValueChanged];
    

    [self.view addSubview:segmentedControl];
    
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(genderLabel.mas_bottom).with.offset(15);
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(150 ,30));
    }];
    
    
    if (self.personalModel.avatar.length>0) {
        [self.iconV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mPrefixUrl,self.personalModel.avatar]]];
    }
    self.nameTextF.text = self.personalModel.userName;
    if ([self.personalModel.gender isEqualToString:@"0"]) {
        self.genderSel.selectedSegmentIndex = 1;
    }else{
        self.genderSel.selectedSegmentIndex = 0;
    }
    

}
- (void)changeIconImage{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]){
        //先把图片转成NSData
        self.chooseImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(self.chooseImage) == nil){
            data = UIImageJPEGRepresentation(self.chooseImage, 1.0);
        }else{
            data = UIImagePNGRepresentation(self.chooseImage);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        _filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        /****图片本地持久化*******/
        
        
        
        //        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //        NSString *myfilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"picture.png"]];
        //        // 保存文件的名称
        //        [UIImagePNGRepresentation(self.chooseImage)writeToFile: myfilePath  atomically:YES];
        //        NSUserDefaults *userDef= [NSUserDefaults standardUserDefaults];
        //        [userDef setObject:myfilePath forKey:kImageFilePath];
        
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        self.iconV.image = [self.chooseImage  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)sendInfo
{
    NSLog(@"图片的路径是：%@", _filePath);
    
}
- (void)segmentAction{
    
}
- (void)changeInfo{
    //UIImage图片转成Base64字符串：
    
    UIImage *originImage = self.iconV.image;
    NSData *data = UIImageJPEGRepresentation(originImage, 0.2f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:2];
    // 添加性别
    if (self.genderSel.selectedSegmentIndex == 0 ) {
        [dict setValue:@"1" forKey:@"gender"];;
    }else{
        [dict setValue:@"0" forKey:@"gender"];;
    }
//    [dict setValue:self.personalModel.info_id forKey:@"id"];
//    [dict setValue:mDefineToken forKey:@"token"];
    [dict setValue:self.nameTextF.text forKey:@"userName"];
//    [dict setValue:data forKey:@"file1"];
//
//    NSLog(@"%@信息%@",encodedImageStr,dict);
//    [[HttpClient defaultClient]requestWithPath:mSaveMyInfo method:1 parameters:dict prepareExecute:^{
//        
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"%@",responseObject);
//        NSString *result;
//        if ([responseObject[@"code"] isEqualToString:@"0"]) {
//                result = @"修改用户信息成功";
//            
//        }else{
//            result = responseObject[@"message"];
//        }
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:result preferredStyle:UIAlertControllerStyleAlert];
//        //       UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            if ([responseObject[@"code"] isEqualToString:@"0"]) {
//                [self.navigationController popViewControllerAnimated:YES];
//            }else{
//            }
//            
//        }];
//        
//        //       [alert addAction:cancelAction];
//        [alert addAction:okAction];
//        [self presentViewController:alert animated:YES completion:nil];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@",error);
//    }];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager.requestSerializer setValue:mDefineToken forHTTPHeaderField:@"token"];
    [manager POST:[NSString stringWithFormat:@"%@token=%@",mSaveMyInfo,mDefineToken] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(self.iconV.image,0.2) name:@"file1" fileName:@"something.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                NSString *result;
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                        result = @"修改用户信息成功";
        
                }else{
                    result = responseObject[@"message"];
                }
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:result preferredStyle:UIAlertControllerStyleAlert];
                //       UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    if ([responseObject[@"code"] isEqualToString:@"0"]) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                    }
        
                }];
        
                //       [alert addAction:cancelAction];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc]initWithTitle:@"上传失败" message:@"网络故障，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
