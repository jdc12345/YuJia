//
//  YJHouseSearchMoreTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/7/18.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJHouseSearchMoreTVCell.h"
#import "UILabel+Addition.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

@interface YJHouseSearchMoreTVCell()
@property (nonatomic, weak) UILabel* itemLabel;
@property (nonatomic, weak) UIButton* firstBtn;
@property (nonatomic, weak) UIButton* secondBtn;
@property (nonatomic, weak) UIButton* thirdlBtn;
@property (nonatomic, weak) UIButton* fourthBtn;
@property (nonatomic, weak) UIButton* fifthBtn;
@end
@implementation YJHouseSearchMoreTVCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}
-(void)setBaseTag:(long)baseTag{
    _baseTag = baseTag;
    self.firstBtn.tag = baseTag+1;
    self.secondBtn.tag = baseTag+2;
    self.thirdlBtn.tag = baseTag+3;
    self.fourthBtn.tag = baseTag+4;
    self.fifthBtn.tag = baseTag+5;
}
//NSArray *moreArr = @[@{@"typeArr":@[@"1居",@"2居",@"3居",@"4居",@"4居以上"],@"item":@"户型"},@{@"typeArr":@[@"东",@"南",@"西",@"北",@"南北"],@"item":@"朝向"}];
-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.itemLabel.text = dic[@"item"];
    NSArray *typeArr = dic[@"typeArr"];
    [self.firstBtn setTitle:typeArr[0] forState:UIControlStateNormal];
    [self.secondBtn setTitle:typeArr[1] forState:UIControlStateNormal];
    [self.thirdlBtn setTitle:typeArr[2] forState:UIControlStateNormal];
    [self.fourthBtn setTitle:typeArr[3] forState:UIControlStateNormal];
    [self.fifthBtn setTitle:typeArr[4] forState:UIControlStateNormal];
    
}
-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    //添加line
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1/[UIScreen mainScreen].scale);
    }];
    UILabel *itemLabel = [UILabel labelWithText:@"户型" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:17];
    [self.contentView addSubview:itemLabel];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.offset(15*kiphone6);
    }];
    [self.contentView layoutSubviews];
    [itemLabel layoutIfNeeded];
    NSArray *typeArr = @[@"1",@"2",@"3",@"4",@"5"];
    int columnCount=4;
    //每个格子的宽度和高度
    CGFloat appW=73.0*kiphone6;
    CGFloat appH=25.0*kiphone6;
    //计算间隙
    CGFloat appMargin=(kScreenW-20-columnCount*appW)/(columnCount+1);
    
    for (int i=0; i<5; i++) {
        UIButton *btn = [[UIButton alloc]init];
//        btn.tag = 11+i;
        switch (i) {
            case 0:
                self.firstBtn = btn;
                break;
            case 1:
                self.secondBtn = btn;
                break;
            case 2:
                self.thirdlBtn = btn;
                break;
            case 3:
                self.fourthBtn = btn;
                break;
            case 4:
                self.fifthBtn = btn;
                break;
            default:
                break;
        }
//        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [btn setTitle:typeArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#f5f5f5"]];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        //计算列号和行号
        int colX=i%columnCount;
        int rowY=i/columnCount;
        //计算坐标
        CGFloat appX=10*kiphone6+colX*(appW+appMargin);
        CGFloat appY= CGRectGetMaxY(itemLabel.frame)+20*kiphone6+rowY*(appH+10*kiphone6);
        
        btn.frame=CGRectMake(appX, appY, appW, appH);
        
        [self.contentView addSubview:btn];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
    

    self.itemLabel = itemLabel;
    self.hyb_lastViewInCell = self.fifthBtn;
    self.hyb_bottomOffsetToCell = 15*kiphone6;
}
- (void)clickBtn:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = [UIColor colorWithHexString:@"#00eac6"];
        for (UIButton *btn in self.contentView.subviews) {
            if (btn.tag!=sender.tag) {
                btn.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
