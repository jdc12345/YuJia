//
//  YJRentalHouseVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/22.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJRentalHouseVC.h"
#import "YJBackView.h"
#import "UILabel+Addition.h"
#import "YJSelectView.h"
#import "YJRentPersonInfoTVCell.h"

#import "YJPhotoFlowLayout.h"
#import "YJPhotoAddBtnCollectionViewCell.h"
#import <HUImagePickerViewController.h>
#import "YJPhotoDisplayCollectionViewCell.h"
#import <HUPhotoBrowser.h>

static NSString* tableCell = @"table_cell";
static NSString* collectionCellid = @"collection_cell";
static NSString* photoCellid = @"photo_cell";
@interface YJRentalHouseVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,HUImagePickerViewControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UIScrollView *scrollView;
@property(nonatomic,weak)YJBackView *backView;
@property(nonatomic,weak)YJSelectView *selectView;
@property(nonatomic,assign)NSInteger flag;
@property(nonatomic,weak)UIButton *allBtn;
@property(nonatomic,weak)UIButton *shareBtn;
@property(nonatomic,weak)UIView *line2;
@property(nonatomic,weak)UIView *shareView;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property(nonatomic,weak)UICollectionView *collectionView;
@property(nonatomic,weak)UIView *coverView;
@property(nonatomic,weak)UIPickerView *onePickerView;
@property(nonatomic,strong)NSArray *oneArr;
@property(nonatomic,strong)NSDictionary *areaDic;
@property(nonatomic,strong)NSArray *oneLevelArr;
@property(nonatomic,strong)NSArray *twoLevelArr;
@property(nonatomic,strong)NSString *oneLevelArea;
@property(nonatomic,strong)NSString *twoLevelArea;
@property(nonatomic,assign)NSInteger pickFlag;
@property(nonatomic,weak)UIToolbar * topView;
@end

@implementation YJRentalHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = false;
    self.title = @"租房信息";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self setupUI];
}
- (void)setupUI {
    self.flag = 1;
        //
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    YJBackView *backView = [[YJBackView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 1100)];
    [scrollView addSubview:backView];
    self.backView = backView;
    backView.backgroundColor = [UIColor whiteColor];
    UILabel *noticeLabel = [UILabel labelWithText:@"您本月可发帖8条，本月还可以免费发帖6条" andTextColor:[UIColor colorWithHexString:@"#00bfff"] andFontSize:14];
    [backView addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(backView.mas_top).offset(22.5*kiphone6);
    }];//
    UIView *grayView1 = [[UIView alloc]init];
    grayView1.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [backView addSubview:grayView1];
    [grayView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(45*kiphone6);
        make.height.offset(5*kiphone6);
    }];//
    UILabel *leaseLabel = [UILabel labelWithText:@"出租方式" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:14];
    [backView addSubview:leaseLabel];
    [leaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noticeLabel);
        make.centerY.equalTo(grayView1.mas_bottom).offset(27.5*kiphone6);
    }];//
    UIButton *allRentBtn = [[UIButton alloc]init];
    allRentBtn.tag = 101;
    [allRentBtn setImage:[UIImage imageNamed:@"choice_rent"] forState:UIControlStateNormal];
    [allRentBtn setImage:[UIImage imageNamed:@"choiced_rent"] forState:UIControlStateSelected];
    [allRentBtn setTitle:@"整租" forState:UIControlStateNormal];
    [allRentBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    allRentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [backView addSubview:allRentBtn];
    [allRentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leaseLabel);
        make.left.equalTo(leaseLabel.mas_right).offset(15*kiphone6);
    }];
    UIButton *shareRentBtn = [[UIButton alloc]init];
    shareRentBtn.tag = 102;
    [shareRentBtn setImage:[UIImage imageNamed:@"choice_rent"] forState:UIControlStateNormal];
    [shareRentBtn setImage:[UIImage imageNamed:@"choiced_rent"] forState:UIControlStateSelected];
    [shareRentBtn setTitle:@"合租" forState:UIControlStateNormal];
    [shareRentBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    shareRentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [backView addSubview:shareRentBtn];
    [shareRentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leaseLabel);
        make.left.equalTo(allRentBtn.mas_right).offset(15*kiphone6);
    }];
    [allRentBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5*kiphone6, 0.0, 0.0)];
    [shareRentBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5*kiphone6, 0.0, 0.0)];
    self.allBtn = allRentBtn;
    self.shareBtn = shareRentBtn;
    [shareRentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [allRentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];//
    UIView *grayView2 = [[UIView alloc]init];
    grayView2.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [backView addSubview:grayView2];
    [grayView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(grayView1.mas_bottom).offset(55*kiphone6);
        make.height.offset(5*kiphone6);
    }];//
        //拿出xib视图
    NSArray  *apparray= [[NSBundle mainBundle]loadNibNamed:@"YJSelectView" owner:nil options:nil];
//    UIView *appview=[apparray firstObject];
        YJSelectView  *selectView=[apparray firstObject];
    //加载视图
        [backView addSubview:selectView];
        [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(grayView2.mas_bottom);
            make.left.right.offset(0);
            make.height.offset(460);
        }];
        [selectView layoutIfNeeded];
        UIView *line2=(UIView *)[selectView viewWithTag:13];
        self.line2 = line2;
    self.selectView = selectView;
    [selectView.directionBtn addTarget:self action:@selector(pickerView:) forControlEvents:UIControlEventTouchUpInside];
    [selectView.areaBtn addTarget:self action:@selector(pickerView:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *payType=(UIButton *)[selectView viewWithTag:24];
    [payType addTarget:self action:@selector(pickerView:) forControlEvents:UIControlEventTouchUpInside];

    //添加大tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [backView addSubview:tableView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(selectView.mas_bottom);
        make.height.offset(450);
    }];
    [tableView registerClass:[YJRentPersonInfoTVCell class] forCellReuseIdentifier:tableCell];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate =self;
    tableView.dataSource = self;
    tableView.rowHeight = 55;
//    [backView layoutSubviews];CGRectGetMaxY(tableView.frame)
    [tableView layoutIfNeeded];
    scrollView.contentSize = CGSizeMake(kScreenW, 1100);
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.masksToBounds = true;
    btn.layer.cornerRadius = 3;
    [footerView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(40*kiphone6);
        make.centerX.equalTo(footerView);
        make.width.offset(325*kiphone6);
        make.height.offset(45*kiphone6);
    }];
    [btn addTarget:self action:@selector(submitAddress) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn];
    tableView.tableFooterView = footerView;

}
-(void)pickerView:(UIButton*)sender{
    if (sender.tag==101) {
        self.pickFlag = 101;
        self.areaDic = @{@"保定市":@[@"涿州市",@"易县",@"固安"],@"北京市":@[@"顺义区",@"海淀区",@"崇文区"]};
        self.oneLevelArr = [self.areaDic allKeys];
        self.twoLevelArr = self.areaDic[@"北京市"];

        [self pickerView:self.onePickerView titleForRow:0 forComponent:0];
        [self pickerView:self.onePickerView didSelectRow:0 inComponent:0];//第二列需要刷新数据
        [self pickerView:self.onePickerView titleForRow:0 forComponent:1];
    }else if (sender.tag==102){
        self.pickFlag = 102;
        self.oneArr = @[@"东",@"南",@"西",@"北",@"东西",@"南北"];
    }else if (sender.tag==103){
        self.pickFlag = 103;
        self.oneArr = @[@"主卧",@"次卧",@"隔断"];
    }else if (sender.tag==24){
        self.pickFlag = 24;
        self.oneArr = @[@"押一付一",@"押一付三",@"半年付",@"年付"];
    }
    if (self.coverView) {
        
        [self.onePickerView reloadAllComponents];
        self.topView.hidden = false;
        self.onePickerView.hidden = false;
        self.coverView.hidden = false;
    }else{
    //大蒙布View
    UIView *coverView = [[UIView alloc]init];
    coverView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    coverView.alpha = 0.3;
    [self.view addSubview:coverView];
    self.coverView = coverView;
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    coverView.userInteractionEnabled = YES;
    //添加tap手势：
    //    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
    //将手势添加至需要相应的view中
    //    [backView addGestureRecognizer:tapGesture];
    
    UIPickerView *pickView = [[UIPickerView alloc]init];
    [self.view addSubview:pickView];
    [self.view bringSubviewToFront:pickView];
    [pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(200*kiphone6);
    }];
    pickView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    pickView.dataSource = self;
    pickView.delegate = self;
    pickView.showsSelectionIndicator = YES;
    self.onePickerView = pickView;
        UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        [topView setBarStyle:UIBarStyleDefault];
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(2, 5, 50, 25);
        [btn addTarget:self action:@selector(resignFirstResponderText) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
        NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
        [topView setItems:buttonsArray];
        [self.view addSubview:topView];
        [self.view bringSubviewToFront:topView];
        self.topView = topView;
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.bottom.equalTo(pickView.mas_top);
//            make.height.offset(200*kiphone6);
        }];

    }
//    //            设置初始默认值
//    [self pickerView:self.onePickerView didSelectRow:0 inComponent:0];
//    [self.onePickerView selectRow:0 inComponent:0 animated:true];
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
}
#pragma mark - pickView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.pickFlag == 101) {
        return 2;
    }
    return 1;
}
// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.pickFlag == 101) {
        if (component==0) {
            return self.oneLevelArr.count;
        }if (component==1) {
            return self.twoLevelArr.count;
        }
    }
    return self.oneArr.count;
}

#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    if (component==0) {
//        return pickerView.bounds.size.width*0.5;
//    }
    return 120;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    
    return 40.0*kiphone6;
    
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    if (self.pickFlag==101) {
        
        if (component==0) {
            self.oneLevelArea = self.oneLevelArr[row];
            self.twoLevelArr = self.areaDic[self.oneLevelArr[row]];
            [pickerView reloadComponent:1];
            self.twoLevelArea = self.twoLevelArr[0];
        }else if (component==1) {
            self.twoLevelArea = self.twoLevelArr[row];
            
        }
        NSString *allArea = [NSString stringWithFormat:@"%@%@",self.oneLevelArea,self.twoLevelArea];
        [self.selectView.areaBtn setTitle:allArea forState:UIControlStateNormal];
    }else if (self.pickFlag==102) {
        [self.selectView.directionBtn setTitle:[NSString stringWithFormat:@"%@",self.oneArr[row]] forState:UIControlStateNormal];
    }else if (self.pickFlag==103) {
        UIButton *roomType=(UIButton *)[self.shareView viewWithTag:103];
        [roomType setTitle:[NSString stringWithFormat:@"%@",self.oneArr[row]] forState:UIControlStateNormal];
    }else if (self.pickFlag==24) {
        UIButton *payType=(UIButton *)[self.selectView viewWithTag:24];
        [payType setTitle:[NSString stringWithFormat:@"%@",self.oneArr[row]] forState:UIControlStateNormal];
    }
    
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.pickFlag==101) {
        
        if (component==0) {
            return self.oneLevelArr[row];
        }else if (component==1) {
        
            return self.twoLevelArr[row];
            
        }
    }
    

    return self.oneArr[row];
}
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)];
//    if (component == 0) {
//        [label setText:[self.dayArr objectAtIndex:row]];
//        //    }else if (component == 1){
//        //        [label setText:[self.monthArr objectAtIndex:row]];
//    }
//    else if (component == 1){
//        [label setText:[NSString stringWithFormat:@"%@时",self.hourArr[row]]];
//    }
//    else if (component == 2){
//        [label setText:[NSString stringWithFormat:@"%@分",self.minusArr[row]]];
//    }
//    label.backgroundColor = [UIColor clearColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    return label;
//}

-(void)resignFirstResponderText {
    self.topView.hidden = true;
    self.onePickerView.hidden = true;
    self.coverView.hidden = true;
    
}
-(void)submitAddress{
    
}

#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 2;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YJRentPersonInfoTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCell forIndexPath:indexPath];
    NSArray *arr = @[@"联 系 人",@"联系电话"];
    cell.item = arr[indexPath.row];
    return cell;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 354*kiphone6, 5*kiphone6)];
    if (section == 0) {
        headerView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        UILabel *itemLabel = [UILabel labelWithText:@"添加照片" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:14];
        [headerView addSubview:itemLabel];
        [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.top.offset(15);
        }];
        //photoCollectionView
        UICollectionView *photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[YJPhotoFlowLayout alloc]init]];
        [headerView addSubview:photoCollectionView];
        self.collectionView = photoCollectionView;
        photoCollectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(itemLabel.mas_bottom).offset(15);
            make.left.bottom.offset(0);
            make.width.offset(216*kiphone6);
        }];
        photoCollectionView.dataSource = self;
        photoCollectionView.delegate = self;
        // 注册单元格
        [photoCollectionView registerClass:[YJPhotoAddBtnCollectionViewCell class] forCellWithReuseIdentifier:collectionCellid];
        [photoCollectionView registerClass:[YJPhotoDisplayCollectionViewCell class] forCellWithReuseIdentifier:photoCellid];
        photoCollectionView.showsHorizontalScrollIndicator = false;
        photoCollectionView.showsVerticalScrollIndicator = false;

        
    }else{
        headerView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    }
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.imageArr.count<4) {
           return 128;
        }
        return 198;
    }
    return 5;
}

#pragma mark - UICollectionView
// 有多少行
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.imageArr.count<8&&self.imageArr.count>0) {
        return self.imageArr.count+1;
    }else if(self.imageArr.count==8){
        return self.imageArr.count;
    }else{
        return 1;
    }
}

// cell内容
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    if (self.imageArr.count==0) {
        // 去缓存池找
        YJPhotoAddBtnCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellid forIndexPath:indexPath];
        cell.clickBtnBlock = ^(NSInteger tag) {//cell上按钮点击事件
            HUImagePickerViewController *picker = [[HUImagePickerViewController alloc] init];
            picker.delegate = self;
            picker.maxAllowedCount = 8-self.imageArr.count;
            picker.originalImageAllowed = YES; //想要获取高清图设置为YES,默认为NO
            [self presentViewController:picker animated:YES completion:nil];
        };
        return cell;
    }else if (self.imageArr.count<8&&self.imageArr.count>0){
        if (indexPath.row==self.imageArr.count) {
            // 去缓存池找
            YJPhotoAddBtnCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellid forIndexPath:indexPath];
            cell.clickBtnBlock = ^(NSInteger tag) {//cell上按钮点击事件
                HUImagePickerViewController *picker = [[HUImagePickerViewController alloc] init];
                picker.delegate = self;
                picker.maxAllowedCount = 8-self.imageArr.count;
                picker.originalImageAllowed = YES; //想要获取高清图设置为YES,默认为NO
                [self presentViewController:picker animated:YES completion:nil];
            };
            return cell;
        }else{
            // 去缓存池找
            YJPhotoDisplayCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellid forIndexPath:indexPath];
            cell.imageView.clickBtnBlock = ^(NSInteger tag) {//cell上按钮点击事件
                [self.imageArr removeObjectAtIndex:indexPath.row];
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//                self.titleView.text = self.content;//刷新后保存报修内容
                [self.collectionView reloadData];
            };
            cell.photo = self.imageArr[indexPath.row];
            return cell;
        }
    }
    // 去缓存池找
    YJPhotoDisplayCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellid forIndexPath:indexPath];
    cell.imageView.clickBtnBlock = ^(NSInteger tag) {//cell上按钮点击事件
        [self.imageArr removeObjectAtIndex:indexPath.row];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//        self.titleView.text = self.content;//刷新后保存报修内容
        [self.collectionView reloadData];
    };
    cell.photo = self.imageArr[indexPath.row];
    return cell;
}

//当选择一张图片后进入这里
- (void)imagePickerController:(HUImagePickerViewController *)picker didFinishPickingImagesWithInfo:(NSDictionary *)info{
    //    self.imageArr = info[kHUImagePickerThumbnailImage];//缩小图
    NSMutableArray *arr = info[kHUImagePickerOriginalImage];//源图
    for (int i = 0; i<arr.count; i++) {
        [self.imageArr addObject:arr[i]];
    }
    //    self.imageArr = [NSMutableArray arrayWithArray:arr];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//    self.titleView.text = self.content;//刷新后保存报修内容
    [self.collectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
// cell点击事件
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    YJPhotoDisplayCollectionViewCell *cell = (YJPhotoDisplayCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [HUPhotoBrowser showFromImageView:cell.imageView withImages:self.imageArr atIndex:indexPath.row];
    
}
-(NSMutableArray *)imageArr{
    if (_imageArr == nil) {
        _imageArr = [[NSMutableArray alloc]init];
    }
    return _imageArr;
}

//- (void)keyboardWillChangeFrame:(NSNotification *)noti{
//    
//    //从userInfo里面取出来键盘最终的位置
//    NSValue *rectValue = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
//    
//    CGRect rect = [rectValue CGRectValue];
//    [self.fieldBackView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view.mas_top).offset(rect.origin.y);
//    }];
//    
//}

-(void)btnClick:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        if (sender.tag == 101) {
            self.flag = 1;
            self.shareBtn.selected = false;
            self.shareView.hidden = true;
        }else{
            self.flag = 2;
            self.allBtn.selected = false;
            if (self.shareView) {
                self.shareView.hidden = false;
            }else{
                //拿出xib视图
                NSArray  *apparray= [[NSBundle mainBundle]loadNibNamed:@"YJShareRentView" owner:nil options:nil];
                UIView *shareView=[apparray firstObject];
                //加载视图
                [self.backView addSubview:shareView];
                [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.line2.mas_bottom);
                    make.left.right.offset(0);
                    make.height.offset(55);
                }];
                self.shareView = shareView;
 
            }
            UIButton *roomType=(UIButton *)[self.shareView viewWithTag:103];
            [roomType addTarget:self action:@selector(pickerView:) forControlEvents:UIControlEventTouchUpInside];
    
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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