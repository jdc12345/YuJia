//
//  YJFriendCommentTableViewCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/10.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJFriendCommentTableViewCell.h"
#import "UILabel+Addition.h"
#import "UIColor+colorValues.h"

@interface YJFriendCommentTableViewCell()<UITextViewDelegate>
@property (nonatomic, weak) UITextView* textview;

@end
@implementation YJFriendCommentTableViewCell

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
-(void)setModel:(NSString *)model{
    _model = model;
    NSString *content = [NSString stringWithFormat:@"%@: 你说你要浪里格朗，我说你要浪里个浪，到底是浪里格朗还是浪里个浪",model];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:content];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    // 行间距
//    paragraphStyle.lineSpacing = 5;
//    // 对齐方式
//    paragraphStyle.alignment = NSTextAlignmentLeft;
//    [attStr addAttribute:NSParagraphStyleAttributeName
//                    value:paragraphStyle
//                    range:NSMakeRange(0, attStr.length)];
    [attStr addAttribute:NSLinkAttributeName value:@"click://" range:NSMakeRange(0, model.length)];
    [attStr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} range:NSMakeRange(0, model.length)];
    [attStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor colorWithHexString:@"#00bfff"]
                    range:NSMakeRange(0, model.length)];
    _textview.linkTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#00bfff"]};
    
    
    self.textview.attributedText = attStr;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    
    if ([[URL scheme] isEqualToString:@"click"]) {
        NSAttributedString *abStr = [textView.attributedText attributedSubstringFromRange:characterRange];
        NSString *str = [NSString stringWithFormat:@"%@",abStr];
        if (self.clickBtnBlock) {
            self.clickBtnBlock(str);
        }
        
        return NO;
    }
    
    
    return YES;
}
-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    UIImageView *iconView = [[UIImageView alloc]init];//回复图片
    UIImage *image =[UIImage imageNamed:@"blue-opinion"];
    iconView.image = image;
    [self.contentView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5*kiphone6);
        make.left.offset(27*kiphone6);
        make.height.width.offset(11*kiphone6);
    }];
    self.iconView = iconView;
    iconView.hidden = true;
    UITextView *textView= [[UITextView alloc]init];
    textView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self.contentView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.equalTo(iconView.mas_right).offset(8*kiphone6);
        make.right.offset(0*kiphone6);
    }];
    textView.textColor = [UIColor colorWithHexString:@"#333333"];
    textView.font = [UIFont systemFontOfSize:12];
//    textView.contentInset = UIEdgeInsetsMake(-5, 0, 0, -5);
    textView.textContainerInset = UIEdgeInsetsMake(5,0, 0, 0);
    textView.delegate = self;
    textView.editable = NO;//必须禁止输入，否则点击将会弹出输入键盘
    textView.scrollEnabled = NO;//可选的，视具体情况而定
    self.textview = textView;
}

@end