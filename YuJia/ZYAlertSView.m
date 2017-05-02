//
//  ZYAlertSView.m
//  YuYi_Client
//
//  Created by wylt_ios_1 on 2017/2/27.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//


#import "ZYAlertSView.h"


@interface ZYAlertSView()
@property (strong, nonatomic) UIWindow *actionWindow;   // 获取屏幕
@property (strong, nonatomic) UIView *maskView;         // 透明背景
@property (strong, nonatomic) UIView *mainView;         // 弹出视图
@property (nonatomic) BOOL isShow;
@end

@implementation ZYAlertSView

- (instancetype)initWithContentSize:(CGSize)contentSize
                    TitleView:(UIView *)titleView
                       selectView:(UIView *)selectView
                         sureView:(UIView *)sureView
{
    self = [super init];
    if (self) {
        self.isShow = NO;
        //。创建背景
        UIView *maskView = [[UIView alloc] init];
        [maskView setAlpha:0];
        [maskView setUserInteractionEnabled:NO];
        [maskView setFrame:(CGRect){0, 0, kScreenW, kScreenH}];
        [maskView setBackgroundColor:[UIColor blackColor]];
        [self addSubview:maskView];
        _maskView = maskView;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [maskView addGestureRecognizer:tap];
        
        self.mainView = [[UIView alloc]initWithFrame:CGRectMake((kScreenW -contentSize.width)/2.0, (kScreenH -contentSize.height)/2.0, contentSize.width, contentSize.height)];
        self.mainView.backgroundColor = [UIColor whiteColor];
        
        NSLog(@"yyyyy_%g",self.mainView.frame.origin.y);
        
        
        
        if (titleView) {
             [_mainView addSubview:titleView];
        }
        if (selectView) {
            [_mainView addSubview:selectView];
        }
        if (sureView) {
            [_mainView addSubview:sureView];
        }
        [self addSubview:self.mainView];
        
        // 在window上添加AlertView
        [self setFrame:(CGRect){0, 0, kScreenW, kScreenH}];
        [self.actionWindow addSubview:self];
        
    }
    return self;
}

// 弹出识图
- (void)show{
    if (self.isShow) {
        return;
    }
    
    _actionWindow.hidden = NO;
    [self prepareUI];
    [self setFrame:(CGRect){0, 0, kScreenW, kScreenH}];
    [self setNeedsLayout];
    
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [_maskView setAlpha:0.5];
                         [_maskView setUserInteractionEnabled:YES];
                         
//                         CGRect frame = _mainView.frame;
//                         frame.origin.y -= frame.size.height;
//                         [_mainView setFrame:frame];
                         
                     }
                     completion:nil];
    
    self.isShow = YES;
}


// 隐藏视图
- (void)dismiss:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.0f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [_maskView setAlpha:0];
                         [_maskView setUserInteractionEnabled:NO];
                         
//                         CGRect frame = _mainView.frame;
//                         frame.origin.y += frame.size.height;
//                         [_mainView setFrame:frame];
                     }
                     completion:^(BOOL finished) {
                         _actionWindow.hidden = YES;
                         [self removeFromSuperview];
                         self.isShow = NO;
                     }];
}

- (void)prepareUI {
//    _maskView.backgroundColor = self.maskBackgroundColor;
//    _titleLabel.font = self.titleFont;
//    _titleLabel.textColor = self.titleColor;
//    _titleLabel.backgroundColor = self.titleBackgroundColor;
    
//    for (UIImageView *line in self.lines) {
//        line.backgroundColor = self.lineColor;
//    }
    
//    for (int index = 0; index < [self.buttons count]; index++) {
//        UIButton *button = self.buttons[index];
//        [button setBackgroundColor:[self buttonBackgroundColorAtIndex:index]];
//        [[button titleLabel] setFont:[self buttonTextFontAtIndex:index]];
//        [button setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
//        
//    }
}
// 懒加载window
- (UIWindow *)actionWindow {
    if (_actionWindow == nil) {
        
        _actionWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _actionWindow.windowLevel       = UIWindowLevelStatusBar;
        _actionWindow.backgroundColor   = [UIColor clearColor];
        _actionWindow.hidden = NO;
    }
    
    return _actionWindow;
}

//- (void)back_click:(UIButton *)sender{
//    CGFloat alertW = 335 *kiphone6;
//    CGFloat alertH = 310 *kiphone6;
//    
//    // titleView
//    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, alertW, 80 *kiphone6)];
//    UILabel *titleLabel = [[UILabel alloc]init];
//    titleLabel.text = @"选择挂号人";
//    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
//    titleLabel.font = [UIFont systemFontOfSize:20];
//    
//    UILabel *lineLabel = [[UILabel alloc]init];
//    lineLabel.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
//    
//    [titleView addSubview:titleLabel];
//    [titleView addSubview:lineLabel];
//    
//    WS(ws);
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(titleView);
//        make.size.mas_equalTo(CGSizeMake(120 ,20));
//    }];
//    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(titleView);
//        make.bottom.equalTo(titleView);
//        make.size.mas_equalTo(CGSizeMake(kScreenW ,1));
//    }];
//    // 选项view
//    UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), alertW, 170 *kiphone6)];
//    
//    // 取消确定view
//    UIView *sureView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(selectView.frame), alertW, 60 *kiphone6)];
//    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
//    [cancelBtn addTarget:self action:@selector(alertClick:) forControlEvents:UIControlEventTouchUpInside];
//    cancelBtn.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
//    
//    [sureView addSubview:cancelBtn];
//    
//    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(sureView);
//        make.top.equalTo(sureView);
//        make.size.mas_equalTo(CGSizeMake(alertW/2.0, 60 *kiphone6));
//    }];
//    
//    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [sureBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
//    [sureBtn addTarget:self action:@selector(alertClick:) forControlEvents:UIControlEventTouchUpInside];
//    sureBtn.backgroundColor = [UIColor colorWithHexString:@"25f368"];
//    
//    [sureView addSubview:sureBtn];
//    
//    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(sureView);
//        make.top.equalTo(sureView);
//        make.size.mas_equalTo(CGSizeMake(sureView.frame.size.width/2.0, 60 *kiphone6));
//    }];
//    
//    
//    
//    ZYAlertSView *alertV = [[ZYAlertSView alloc]initWithContentSize:CGSizeMake(alertW, alertH) TitleView:titleView selectView:selectView sureView:sureView];
//    [alertV show];
//    self.alertView = alertV;
//}
//- (void)alertClick:(UIButton *)sender{
//    if ([sender.currentTitle isEqualToString:@"取消"]) {
//        [self.alertView dismiss:nil];
//    }else{
//        
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
