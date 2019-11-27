//
//  ThreadListCell.m
//  DiscuzMobile
//
//  Created by HB on 17/1/18.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "ThreadListCell.h"

@interface ThreadListCell()

@property (nonatomic, strong) UIImageView *typeIcon;

@end

@implementation ThreadListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addInit];
    }
    return  self;
}

- (void)addInit {
    [self.desLab addSubview:self.typeIcon];
}

-(void)setListInfo:(DZThreadListModel *)listInfo{
    [super setListInfo:listInfo];
    
    if (![listInfo isSpecialThread]) {
        self.typeIcon.hidden = YES;
    } else {
        self.typeIcon.hidden = NO;
        self.typeIcon.frame = CGRectMake(0, 2, 16, 16);
        if ([listInfo.special isEqualToString:@"1"]) {
            self.typeIcon.image = [UIImage imageNamed:@"votesmall"];
        } else if ([listInfo.special isEqualToString:@"4"]) {
            self.typeIcon.image = [UIImage imageNamed:@"activitysmall"];
        } else if ([listInfo.special isEqualToString:@"5"]) {
            self.typeIcon.image = [UIImage imageNamed:@"debatesmall"];
        }
    }
    
}

- (UIImageView *)typeIcon {
    if (_typeIcon == nil) {
        _typeIcon = [[UIImageView alloc] init];
        _typeIcon.hidden = YES;
    }
    return _typeIcon;
}

@end
