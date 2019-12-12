//
//  DZUserMsgBoxTabController.m
//  DiscuzMobile
//
//  Created by HB on 2017/7/17.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "DZUserMsgBoxTabController.h"
#import "DZContainerController.h"
#import "DZMsgSubListController.h"

#import "PmTypeModel.h"

@interface DZUserMsgBoxTabController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation DZUserMsgBoxTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.pmType) {
        case pm_mypm:
        {
            PmTypeModel *m1 = [[PmTypeModel alloc] initWithTitle:@"私人消息" andModule:@"mypm" anFilter:@"privatepm" andView:nil andType:nil];
            PmTypeModel *m2 = [[PmTypeModel alloc] initWithTitle:@"公共消息" andModule:@"mypm" anFilter:@"announcepm" andView:nil andType:nil];
            [self.dataArray addObjectsFromArray:@[m1,m2]];
        }
            break;
        case pm_mythread:
        {
            PmTypeModel *m1 = [[PmTypeModel alloc] initWithTitle:@"帖子" andModule:@"mynotelist" anFilter:nil andView:@"mypost" andType:@"post"];
            PmTypeModel *m2 = [[PmTypeModel alloc] initWithTitle:@"点评" andModule:@"mynotelist" anFilter:nil andView:@"mypost" andType:@"pcomment"];
            PmTypeModel *m3 = [[PmTypeModel alloc] initWithTitle:@"活动" andModule:@"mynotelist" anFilter:nil andView:@"mypost" andType:@"activity"];
            PmTypeModel *m4 = [[PmTypeModel alloc] initWithTitle:@"悬赏" andModule:@"mynotelist" anFilter:nil andView:@"mypost" andType:@"reward"];
            PmTypeModel *m5 = [[PmTypeModel alloc] initWithTitle:@"商品" andModule:@"mynotelist" anFilter:nil andView:@"mypost" andType:@"goods"];
            PmTypeModel *m6 = [[PmTypeModel alloc] initWithTitle:@"提到我的" andModule:@"mynotelist" anFilter:nil andView:@"mypost" andType:@"at"];
            [self.dataArray addObjectsFromArray:@[m1,m2,m3,m4,m5,m6]];
        }
            break;
        case pm_interactive:
        {
            PmTypeModel *m1 = [[PmTypeModel alloc] initWithTitle:@" 打招呼" andModule:@"mynotelist" anFilter:nil andView:@"interactive" andType:@"post"];
            PmTypeModel *m2 = [[PmTypeModel alloc] initWithTitle:@"好友" andModule:@"mynotelist" anFilter:nil andView:@"interactive" andType:@"friend"];
            PmTypeModel *m3 = [[PmTypeModel alloc] initWithTitle:@"留言" andModule:@"mynotelist" anFilter:nil andView:@"interactive" andType:@"wall"];
            PmTypeModel *m4 = [[PmTypeModel alloc] initWithTitle:@"评论" andModule:@"mynotelist" anFilter:nil andView:@"interactive" andType:@"comment"];
            PmTypeModel *m5 = [[PmTypeModel alloc] initWithTitle:@"挺你" andModule:@"mynotelist" anFilter:nil andView:@"interactive" andType:@"click"];
            PmTypeModel *m6 = [[PmTypeModel alloc] initWithTitle:@"分享" andModule:@"mynotelist" anFilter:nil andView:@"interactive" andType:@"sharenotice"];
            [self.dataArray addObjectsFromArray:@[m1,m2,m3,m4,m5,m6]];
        }
            break;
        default:
            break;
    }
    
    NSMutableArray *ctArr = [NSMutableArray array];
    for (PmTypeModel *pm in self.dataArray) {
        DZMsgSubListController *listVC = [[DZMsgSubListController alloc] init];
        listVC.title = pm.title;
        listVC.typeModel = pm;
        [ctArr addObject:listVC];
    }
    
    CGRect segmentRect = CGRectMake(0, 0, KScreenWidth, 44);
    self.view.height = KScreenHeight - KNavi_ContainStatusBar_Height;
    DZContainerController *rootVC = [[DZContainerController alloc] init];
    [rootVC setSubControllers:ctArr parentController:self andSegmentRect:segmentRect];
}

- (void)rightBarBtnClick {
    [[DZMobileCtrl sharedCtrl] PushToMsgSendController:nil];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
