//
//  DZForumLeftCell.m
//  DiscuzMobile
//
//  Created by piter on 2018/1/30.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "DZForumLeftCell.h"

@interface DZForumLeftCell()

@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation DZForumLeftCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupLeftCellViews];
    }
    return self;
}


-(void)updateCellLabel:(NSString *)labelStr{
    self.titleLab.text = labelStr;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.selectedBackgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 0.5);
    self.line2.backgroundColor = K_Color_NaviBack;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:NO];
    if (selected == YES) {
        self.titleLab.textColor = K_Color_Theme;
    } else {
        self.titleLab.textColor = K_Color_DarkText;
    }
}


- (void)setupLeftCellViews {
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 0.5)];
    self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = K_Color_ForumGray;
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.font = [UIFont systemFontOfSize:14.0];
    self.titleLab.textColor = K_Color_DarkText;
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLab];
    
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.textLabel.font = [UIFont systemFontOfSize:15.0];
    self.textLabel.textColor = K_Color_DarkText;
    
//    UIView *line1 = [[UIView alloc] init];
//    line1.backgroundColor = [UIColor redColor];
//    [self addSubview:line1];
//    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.width.equalTo(self);
//        make.height.equalTo(@1);
//    }];
    
    self.line2 = [[UIView alloc] init];
    self.line2.backgroundColor = K_Color_NaviBack;
    [self.contentView addSubview:self.line2];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.contentView);
        make.bottom.equalTo(@-0.1);
        make.height.equalTo(@0.5);
    }];
}

@end
