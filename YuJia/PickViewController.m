//
//  PickViewController.m
//  TestDemo
//
//  Created by Qian on 2017/5/15.
//  Copyright © 2017年 Qian. All rights reserved.
//

#import "PickViewController.h"
#import "AreaModel.h"
#import "CityModel.h"
#import "ProvinceModel.h"
#import "UIColor+Extension.h"
#import "ScreenUtil.h"

@interface PickViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSDictionary *_areaDic;
    NSMutableArray *_provinceArr;
    NSDictionary *_proDic;
    NSMutableArray *_professionArr;
    
    
}
/** 弹框 */
@property (nonatomic, strong) UIView *alertView;
/**标题头*/
@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, copy) NSString *selectedStr;
@property (nonatomic, copy) NSString *selectedStr2;
@property (nonatomic, copy) NSString *selectedStr3;
@property (nonatomic, assign) NSInteger selectedRow;

@property (nonatomic, strong) UIDatePicker *datePicker;


@end

@implementation PickViewController


static PickViewController *instance = nil;
+ (instancetype)shareAlertController{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PickViewController alloc] init];
    });
    return instance;
}

- (void)loading
{
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        [self prepareData];
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            [self.alertView addSubview:self.pickerView];
        });
        
    });
}

- (void)prepareData
{
    //area.plist是字典
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    _areaDic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    
    //city.plist是数组
    NSString *plist = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    NSMutableArray *dataCity = [[NSMutableArray alloc] initWithContentsOfFile:plist];
    
    _provinceArr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in dataCity) {
        ProvinceModel *model  = [[ProvinceModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        model.citiesArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in model.cities) {
            CityModel *cityModel = [[CityModel alloc]init];
            [cityModel setValuesForKeysWithDictionary:dic];
            [model.citiesArr addObject:cityModel];
        }
        [_provinceArr addObject:model];
    }
    
}

#pragma mark --
#pragma mark -- init methods

- (UIView *)titleView {
    if (!_titleView) {
        CGFloat titleViewHeight = 50;
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [ScreenUtil screenWidth], titleViewHeight)];
        _titleView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        cancelBtn.frame = CGRectMake(20, 0, 40, 50);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"cccccc"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:cancelBtn];
        
        UIButton *trueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        trueBtn.frame = CGRectMake(self.alertView.bounds.size.width - 50, 0, 40, 50);
        [trueBtn setTitle:@"确定" forState:UIControlStateNormal];
        [trueBtn setTitleColor:[UIColor colorWithHexString:@"00bfff"] forState:UIControlStateNormal];
        [trueBtn addTarget:self action:@selector(trueBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        trueBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_titleView addSubview:trueBtn];
    }

    return _titleView;
}

- (void)cancelBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIView *)alertView {
    if (!_alertView) {
        CGFloat alertHeight = 299;
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, [ScreenUtil screenHeight] - alertHeight, [ScreenUtil screenWidth], alertHeight)];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.userInteractionEnabled = YES;
    }
    return _alertView;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), [ScreenUtil screenWidth], 240)];
        _pickerView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

#pragma mark --
#pragma mark -- lifeCircle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [ScreenUtil screenWidth], [ScreenUtil screenHeight] - self.alertView.frame.size.height)];
    [self.view addSubview:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [view addGestureRecognizer:tap];

    [self.view addSubview:self.alertView];
    self.titleView.backgroundColor = [UIColor whiteColor];
    [self.alertView addSubview:self.titleView];
    self.alertView.frame = CGRectMake(0, [ScreenUtil screenHeight] - 260, [ScreenUtil screenWidth], 260);
    if ([_type isEqualToString:@"城市"]){
        [self loading];
    } else {
        [self.alertView addSubview:self.pickerView];
    }
    
    [self.pickerView selectRow:1 inComponent:0 animated:NO];
    [self pickerView:self.pickerView didSelectRow:1 inComponent:0];

}


- (void)trueBtnAction:(UIButton *)sender {
    NSArray *arr = [[NSArray alloc]init];
    if ([_type isEqualToString:@"城市"]) {
        if (self.selectedStr.length == 0) {
            self.selectedStr = @"北京市";
            self.selectedStr2 = @"北京市";
            self.selectedStr3 = @"东城区";
        }
        arr = [NSArray arrayWithObjects:self.selectedStr,self.selectedStr2,self.selectedStr3, nil];
    } else{
        arr = [NSArray arrayWithObjects:self.selectedStr, nil];
    }
    self.blocksureBtn(arr);
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark --
#pragma mark --UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if ([_type isEqualToString:@"城市"]) {
        if (0 == component)
        {
            ProvinceModel *model = _provinceArr[row];
            return model.name;
        }
        else if(1==component)
        {
            NSInteger rowProvince = [pickerView selectedRowInComponent:0];
            ProvinceModel *model = _provinceArr[rowProvince];
            CityModel *cityModel = model.citiesArr[row];
            return cityModel.name;
        }else
        {
            NSInteger rowProvince = [pickerView selectedRowInComponent:0];
            NSInteger rowCity = [pickerView selectedRowInComponent:1];
            ProvinceModel *model = _provinceArr[rowProvince];
            CityModel *cityModel = model.citiesArr[rowCity];
            NSString *str = [cityModel.code description];
            NSArray *arr = _areaDic[str];
            AreaModel *areaModel = [[AreaModel alloc]init];
            [areaModel setValuesForKeysWithDictionary:arr[row]];
            return areaModel.name;
        }
    } else {
        return self.dataArr[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedRow = row;
    if ([_type isEqualToString:@"城市"]) {
        if(0 == component)
        {
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            
        } if(1 == component)
        {
            [pickerView reloadComponent:2];
        }
        
        NSInteger selectOne = [pickerView selectedRowInComponent:0];
        NSInteger selectTwo = [pickerView selectedRowInComponent:1];
        NSInteger selectThree = [pickerView selectedRowInComponent:2];
        
        ProvinceModel *model = _provinceArr[selectOne];
        CityModel *cityModel = model.citiesArr[selectTwo];
        NSString *str = [cityModel.code description];
        NSArray *arr = _areaDic[str];
        AreaModel *areaModel = [[AreaModel alloc]init];
        [areaModel setValuesForKeysWithDictionary:arr[selectThree]];
        self.selectedStr = model.name;
        self.selectedStr2 = cityModel.name;
        self.selectedStr3 = areaModel.name;
        
        
        NSLog(@"省:%@ 市:%@ 区:%@",model.name,cityModel.name,areaModel.name);
    } else {
        self.selectedStr = self.dataArr[row];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        if (self.selectedRow == row) {
            [pickerLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
            [pickerLabel setFont:[UIFont systemFontOfSize:16]];

        }else {
            [pickerLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
            [pickerLabel setFont:[UIFont systemFontOfSize:15]];

        }
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    return pickerLabel;
}

#pragma mark --
#pragma mark --UIPickerViewDataSource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([_type isEqualToString:@"城市"]) {
        if (0 == component)
        {
            return _provinceArr.count;
        }
        else if(1==component)
        {
            NSInteger rowProvince = [pickerView selectedRowInComponent:0];
            ProvinceModel *model =   _provinceArr[rowProvince];
            return model.citiesArr.count;
        }
        else
        {   NSInteger rowProvince = [pickerView selectedRowInComponent:0];
            NSInteger rowCity = [pickerView selectedRowInComponent:1];
            ProvinceModel *model = _provinceArr[rowProvince];
            CityModel *cityModel = model.citiesArr[rowCity];
            NSString *str = [cityModel.code description];
            NSArray *arr =  _areaDic[str];
            return arr.count;
        }
        
    } else {
        return self.dataArr.count;;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _count;
}

- (void)tapAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
