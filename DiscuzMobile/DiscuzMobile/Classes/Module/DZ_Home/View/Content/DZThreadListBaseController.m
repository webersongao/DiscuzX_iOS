//
//  DZThreadListBaseController.m
//  DiscuzMobile
//
//  Created by WebersonGao on 2019/11/10.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "DZThreadListBaseController.h"
#import "BaseStyleCell.h"
#import "DiscoverModel.h"
#import "ThreadListCell.h"
#import "ThreadListModel+Display.h"

@interface DZThreadListBaseController ()
@property (nonatomic, assign) BOOL isRequest;
@property (nonatomic, strong) NSString *urlString;
@end

@implementation DZThreadListBaseController

- (SThreadListType)listType {
    return 0;
}

#pragma mark - lifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    
    if (self.listType == SThreadListTypeDigest) {
        self.urlString = DZ_Url_DigestAll;
    } else if (self.listType == SThreadListTypeNewest) {
        self.urlString = DZ_Url_NewAll;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(firstRequest:)
                                                 name:DZ_CONTAINERQUEST_Notify
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData)
                                                 name:DZ_DomainUrlChange_Notify
                                               object:nil];
    
    [self cacheRequest];
}

- (void)initTableView {
    
    [self.tableView registerClass:[ThreadListCell class] forCellReuseIdentifier:[ThreadListCell getReuseId]];
    KWEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
        if ([weakSelf.view hu_intersectsWithAnotherView:nil]) {
        }
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf downLoadData:self.page andLoadType:JTRequestTypeRefresh];
    }];
    self.tableView.mj_footer.hidden = YES;
    [self.view addSubview:self.tableView];
    ((MJRefreshAutoFooter *)self.tableView.mj_footer).triggerAutomaticallyRefreshPercent = -10;
}

#pragma mark - Request

- (void)firstRequest:(NSNotification *)notification {
    if (![self.view hu_intersectsWithAnotherView:nil]) {
        return;
    }

    NSDictionary *userInfo = notification.userInfo;
    if ([DataCheck isValidDictionary:userInfo]) {
        NSInteger index = [[userInfo objectForKey:@"selectIndex"] integerValue];
        if (!self.isRequest && index != 0) {
            self.isRequest = YES;
            [self cacheRequest];
        }
    }
}

- (void)cacheRequest {
    [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
    [self downLoadData:self.page andLoadType:JTRequestTypeCache];
    if ([DZApiRequest isCache:self.urlString andParameters:@{@"page":[NSString stringWithFormat:@"%ld",(long)self.page]}]) {
        [self downLoadData:self.page andLoadType:JTRequestTypeRefresh];
    }
    
}

- (void)refreshData {
    self.page =1;
    [self.tableView.mj_footer resetNoMoreData];
    [self downLoadData:self.page andLoadType:JTRequestTypeRefresh];
}

#pragma mark - 数据下载
- (void)downLoadData:(NSInteger)page andLoadType:(JTLoadType)type {
    
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.urlString = self.urlString;
        request.isCache = YES;
        request.loadType = type;
        request.parameters = @{@"page":[NSString stringWithFormat:@"%ld",(long)page]};
        
    } success:^(id responseObject, JTLoadType type) {
        [self.HUD hide];
        [self.tableView.mj_header endRefreshing];
        
        DiscoverModel *discover = [DiscoverModel mj_objectWithKeyValues:[responseObject objectForKey:@"Variables"]];
        
        if (self.page == 1) { // 刷新列表 刷新的时候移除数据源
            [self clearDatasource];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        
        if ([DataCheck isValidArray:discover.data]) {
            [self.dataSourceArr addObjectsFromArray:discover.data];
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self emptyShow];
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        [self.HUD hide];
        [self emptyShow];
        [self showServerError:error];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

- (void)clearDatasource {
    if (self.cellHeightDict.count > 0) {
        [self.cellHeightDict removeAllObjects];
    }
    if (self.dataSourceArr.count > 0) {
        [self.dataSourceArr removeAllObjects];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThreadListModel *listModel = self.dataSourceArr[indexPath.row];
    ThreadListCell * cell = [self.tableView dequeueReusableCellWithIdentifier:[ThreadListCell getReuseId]];
    cell.info = [listModel dealSpecialThread];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toOtherCenter:)];
    cell.headV.tag = [listModel.authorid integerValue];
    [cell.headV addGestureRecognizer:tapGes];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.cellHeightDict[indexPath]) {
        self.cellHeightDict[indexPath] = @([self heightForRowAtIndexPath:indexPath tableView:tableView]);
    }
    return [self.cellHeightDict[indexPath] floatValue];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    ThreadListCell *cell = [tableView dequeueReusableCellWithIdentifier:[ThreadListCell getReuseId]];
    ThreadListModel *listModel = self.dataSourceArr[indexPath.row];
    return [cell caculateCellHeight:listModel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ThreadListModel *listModel = self.dataSourceArr[indexPath.row];
    [[DZMobileCtrl sharedCtrl] PushToDetailController:listModel.tid];
}

#pragma mark - Action
- (void)toOtherCenter:(UITapGestureRecognizer *)sender {
    
    if (![self isLogin]) {
        return;
    }
    [[DZMobileCtrl sharedCtrl] PushToOtherUserController:checkInteger(sender.view.tag)];
}

@end
