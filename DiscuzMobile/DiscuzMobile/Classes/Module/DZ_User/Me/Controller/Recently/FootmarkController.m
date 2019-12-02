//
//  FootmarkController.m
//  DiscuzMobile
//
//  Created by HB on 2017/5/4.
//  Copyright © 2017年 comsenz-service.com.  All rights reserved.
//

#import "FootmarkController.h"

#import "DZThreadListModel.h"
#import "HomeListCell.h"

@interface FootmarkController ()

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger perPage;

@end

@implementation FootmarkController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.perPage = 10;
    self.count = [[DZDatabaseHandle defaultDataHelper] countForFootUid:[Environment sharedEnvironment].member_uid];
    
    [self.HUD showLoadingMessag:@"正在加载" toView:self.view];
    [self refreshFoot];
    
    KWEAKSELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshFoot];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf addFoot];
    }];
    [self.view addSubview:self.tableView];
    self.tableView.mj_footer.hidden = YES;
    
}

- (void)refreshFoot {
    self.page = 1;
    KWEAKSELF;
    BACK(^{
        weakSelf.dataSourceArr = [NSMutableArray arrayWithArray:[[DZDatabaseHandle defaultDataHelper] searchFootWithUid:[Environment sharedEnvironment].member_uid andPage:weakSelf.page andPerpage:weakSelf.perPage]];
        MAIN(^{
            if (weakSelf.dataSourceArr.count >= weakSelf.count) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf emptyShow];
            [weakSelf.HUD hideAnimated:YES];
            [weakSelf.tableView reloadData];
        });
    });
}

- (void)addFoot {
    
    KWEAKSELF;
    BACK(^{
        weakSelf.page ++;
        [weakSelf.dataSourceArr addObjectsFromArray:[[DZDatabaseHandle defaultDataHelper] searchFootWithUid:[Environment sharedEnvironment].member_uid andPage:weakSelf.page andPerpage:weakSelf.perPage]];
        MAIN(^{
            if (weakSelf.dataSourceArr.count >= weakSelf.count) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            
            [weakSelf.HUD hideAnimated:YES];
            [weakSelf.tableView reloadData];
        });
    });
}

#pragma mark - tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [(HomeListCell *)cell cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static  NSString  * CellIdentiferId = @"HomeCellCellID";
    HomeListCell  * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        cell = [[HomeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentiferId];
        
    }
    
    DZThreadListModel *model = [self.dataSourceArr objectAtIndex:indexPath.row];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toOtherCenter:)];
    cell.headV.tag = [model.authorid integerValue];
    [cell.headV addGestureRecognizer:tapGes];
    cell.info = model;
    return cell;
}

- (void)toOtherCenter:(UITapGestureRecognizer *)sender {
    
    if (![self isLogin]) {
        return;
    }
    [[DZMobileCtrl sharedCtrl] PushToOtherUserController:checkInteger(sender.view.tag)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DZThreadListModel *model = self.dataSourceArr[indexPath.row];
    [[DZMobileCtrl sharedCtrl] PushToThreadDetailController:model.tid];
}



@end







