//
//  DZPostTypeSelectView.h
//  DiscuzMobile
//
//  Created by HB on 2017/5/8.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZBaseFloatingView.h"
#import "PostTypeModel.h"

typedef void(^SelectTypeBlock)(PostType type);

@interface DZPostTypeSelectView : DZBaseFloatingView

@property (nonatomic, strong) NSMutableArray *typeArray;

@property (nonatomic, strong) UITableView *selectTableView;

@property (nonatomic, copy) SelectTypeBlock typeBlock;

//- (void)setAllowpost:(NSString *)allowpostspecial;

- (void)setPostType:(NSString *)poll activity:(NSString *)activity debate:(NSString *)debate allowspecialonly:(NSString *)allowspecialonly allowpost:(NSString *)allowpost;

//- (void)setSinglePostType:(NSString *)poll andActivity:(NSString *)activity andDebate:(NSString *)debate;


@end
