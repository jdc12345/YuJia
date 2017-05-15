//
//  YJPostActivitesCommentVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/13.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJPostActivitesCommentVC.h"
#import "BRPlaceholderTextView.h"

@interface YJPostActivitesCommentVC ()<UITextViewDelegate>
@property(nonatomic,weak)BRPlaceholderTextView *contentView;
@end

@implementation YJPostActivitesCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发评论";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    
        //添加右侧发送按钮
        UIButton *deleateBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        [deleateBtn setTitle:@"发表" forState:UIControlStateNormal];
        deleateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [deleateBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        deleateBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        deleateBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
        //        postBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        deleateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [deleateBtn addTarget:self action:@selector(informationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:deleateBtn];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self setupUIWithType:@"写新评论..."];

}
-(void)setupUIWithType:(NSString*)type{
    //输入框
    BRPlaceholderTextView *titleView = [[BRPlaceholderTextView alloc]init];
    titleView.tag = 101;
    [self.view addSubview:titleView];
    self.contentView = titleView;
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(10*kiphone6);
        make.right.offset(-10*kiphone6);
        make.height.offset(200*kiphone6);
    }];
    [titleView layoutIfNeeded];
    titleView.delegate = self;
    titleView.placeholder = type;
    //        titleView.imagePlaceholder = @"title";
    titleView.font=[UIFont boldSystemFontOfSize:14];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    [titleView setPlaceholderFont:[UIFont systemFontOfSize:14]];
    [titleView setPlaceholderColor:[UIColor colorWithHexString:@"#999999"]];
    //    titleField.borderStyle = UITextBorderStyleNone;
    //    //边框宽度
    //    [titleField.layer setBorderWidth:0.01f];
    [titleView setPlaceholderOpacity:0.6];
    [titleView addMaxTextLengthWithMaxLength:500 andEvent:^(BRPlaceholderTextView *text) {
        //            [self.titleView endEditing:YES];
        
        NSLog(@"----------");
    }];
    
    [titleView addTextViewBeginEvent:^(BRPlaceholderTextView *text) {
        NSLog(@"begin");
    }];
    
    [titleView addTextViewEndEvent:^(BRPlaceholderTextView *text) {
        
        NSLog(@"end");
    }];
 
}
-(void)setReplyType:(NSString *)replyType{
    _replyType = replyType;
    for (UIView *subview in [self.view subviews]) {
        if (subview.tag==101) {
            [subview removeFromSuperview];
        }
    }
    NSRange range = [replyType rangeOfString:@"{"];
    NSString *str = [replyType substringToIndex:range.location];
    [self setupUIWithType:[NSString stringWithFormat:@"回复 %@:",str]];
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
