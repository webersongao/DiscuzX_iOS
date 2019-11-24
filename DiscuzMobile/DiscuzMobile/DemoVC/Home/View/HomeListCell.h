//
//  HomeListCell.h
//  DiscuzMobile
//
//  Created by HB on 17/1/16.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "DZBaseTableViewCell.h"
#import "ThreadListModel.h"
#import "HomeIconTextView.h"

@interface HomeListCell : DZBaseTableViewCell

@property (nonatomic, strong) UIImageView *headV;  // 头像
@property (nonatomic, strong) UILabel *nameLab;    // 用户名
@property (nonatomic, strong) UILabel *grade;
@property (nonatomic, strong) UIImageView *tipIcon;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UILabel *desLab;     // 标题
@property (nonatomic, strong) UILabel *messageLab; // 内容
@property (nonatomic, strong) UILabel *datelineLab; // 时间
@property (nonatomic, assign) BOOL hasPic;

@property (nonatomic, strong) HomeIconTextView *viewsLab;   // 浏览数
@property (nonatomic, strong) HomeIconTextView *repliesLab; // 回复数
@property (nonatomic, strong) HomeIconTextView *priceLab;   // 点赞数

@property (nonatomic, strong) ThreadListModel *info;

- (CGFloat)cellHeight;

@end