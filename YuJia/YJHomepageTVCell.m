//
//  YJHomepageTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/8/1.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJHomepageTVCell.h"
#import "UILabel+Addition.h"

@interface YJHomepageTVCell()
@property (nonatomic, weak) UILabel* itemLabel;
@end
@implementation YJHomepageTVCell

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
-(void)setFunctionList:(YYPropertyFunctionList *)functionList{
    _functionList = functionList;
    self.itemLabel.text = functionList.name;
}
-(void)setRoomName:(NSString *)roomName{
    _roomName = roomName;
    self.itemLabel.text = roomName;
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
    UILabel *itemLabel = [UILabel labelWithText:@"不限" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:18];
    [self.contentView addSubview:itemLabel];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    self.itemLabel = itemLabel;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
