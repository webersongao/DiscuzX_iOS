//
//  DZDiscoverCateController.h
//  DiscuzMobile
//
//  Created by WebersonGao on 2019/11/22.
//  Copyright © 2019 comsenz-service.com. All rights reserved.
//

#import "DZBaseViewController.h"

@class DZBaseForumModel;

@interface DZDiscoverCateController : DZBaseViewController

- (instancetype)initWithFrame:(CGRect)frame Model:(DZBaseForumModel *)model;

-(void)updateDiscoverCateControllerView;

@end


