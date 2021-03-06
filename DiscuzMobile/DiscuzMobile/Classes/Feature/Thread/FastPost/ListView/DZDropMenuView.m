//
//  DZDropMenuView.m
//  DiscuzMobile
//
//  Created by WebersonGao on 2019/12/27.
//  Copyright © 2019 comsenz-service.com. All rights reserved.
//

#import "DZDropMenuView.h"
#import "DZForumBaseNode.h"

@interface DZDropMenuView ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger m_selects[3]; /** 保存 选择的数据(行数) */
}

@property (nonatomic, assign) BOOL isShow;   // 按钮点击后 视图显示/隐藏
@property (nonatomic, assign) CGFloat rowHeightNum; // 设置 rom 高度
@property (nonatomic, strong) UIButton *cancelButton;  //!< 底层取消按钮
@property (nonatomic, strong) NSArray *tableViewArr;  //!< 表视图数组
@property (nonatomic, strong) UIView *tableViewUnderView;  //!< 表视图的 底部视图
@property (nonatomic, assign) NSInteger tableCount;  //!< 显示 TableView 数量
@property (nonatomic, strong) NSArray<DZForumBaseNode *> *dataArr; /// 数据


@end


@implementation DZDropMenuView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /** 数据初始化 */
        self.dataArr = [NSArray array];
        
        /** 保存 初始值为-1 */
        for (int i = 0; i < 3; i++) {
            m_selects[i] = -1;
        }
        
        /* 底层取消按钮 */
        self.cancelButton = [[UIButton alloc] initWithFrame:self.bounds];
        self.cancelButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        [self.cancelButton addTarget:self action:@selector(backCancelButonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
        
        /** 表视图的 底部视图初始化 */
        self.tableViewUnderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        self.tableViewUnderView.backgroundColor = [UIColor colorWithRed:0.74 green:0.73 blue:0.76 alpha:1.000];
        [self.cancelButton addSubview:self.tableViewUnderView];
        
        /** 默认设置为no, row高度为40 */
        self.isShow = NO;
        self.rowHeightNum = kCellDefaultHeight;
        
    }
    return self;
}


-(void)creatDropView:(UIView *)view withShowTableNum:(NSInteger)tableNum withData:(NSArray *)arr{
    
    if (!self.isShow) {
        
        self.isShow = !self.isShow;
        // 显示 TableView数量
        self.dataArr = arr;
        self.tableCount = tableNum;
        self.tableViewUnderView.alpha = 1.0;
        self.tableViewUnderView.height = self.rowHeightNum * arr.count;
        
        // 数据
        for (UITableView *tableView in self.tableViewArr) {
            [tableView reloadData];
        }
        [self loadSelects];
        [self adjustTableViews];
    }else{
        /** 什么也不选择时候, 再次点击按钮 消失视图 */
        [self dismiss];
    }
}


#pragma mark - 加载选中的TableView
-(void)loadSelects{
    
    [self.tableViewArr enumerateObjectsUsingBlock:^(UITableView *tableView, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [tableView reloadData];
        
        // 选中TableView某一行
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:m_selects[idx] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        //  加 !idx 是 循环第一次 idx == 0 方法不执行, 所以循环一次 加载一个TableView.
        if((m_selects[idx] != -1 && !tableView.superview) || !idx) {
            
            [self.tableViewUnderView addSubview:tableView];
            
            [UIView animateWithDuration:0.2f animations:^{
                if (self.arrowView) {
                    self.arrowView.transform = CGAffineTransformMakeRotation(M_PI);
                }
            }];
        }
    }];
    
}

#pragma mark - 重置TableView的 位置
-(void)adjustTableViews{
    
    // 显示的 TableView 数量
    int addTableCount = 0;
    for (UITableView *tableView in self.tableViewArr) {
        if (tableView.superview) {
            addTableCount++;
        }
    }
    
    for (int i = 0; i < addTableCount; i++) {
        
        UITableView *tableView = self.tableViewArr[i];
        CGRect adjustFrame = tableView.frame;
        
        adjustFrame.size.width = KScreenWidth / addTableCount ;
        adjustFrame.origin.x = adjustFrame.size.width * i + 0.5 * i;
        adjustFrame.size.height = self.tableViewUnderView.frame.size.height ;
        
        tableView.frame = adjustFrame;
    }
    
}


#pragma mark - TableView协议
/** 行数 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger __block count;
    [self.tableViewArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj == tableView) {
            NSInteger firstSelectRow = ((UITableView *)self.tableViewArr[0]).indexPathForSelectedRow.row ;
            
            NSInteger secondSelectRow = ((UITableView *)self.tableViewArr[1]).indexPathForSelectedRow.row ;
            
            count = [self countForChooseTable:idx firstTableSelectRow:firstSelectRow withSecondTableSelectRow:secondSelectRow];
            
        }
    }];
    
    return count;
    
}



-(NSInteger)countForChooseTable:(NSInteger)idx firstTableSelectRow:(NSInteger)firstSelectRow withSecondTableSelectRow:(NSInteger)secondSelectRow{
    
    if (idx == 0) {
        return self.dataArr.count;
    }else  if (idx == 1){
        if (firstSelectRow == -1) {
            return 0;
        }else{
            if (self.tableCount == 2) {
                DZForumBaseNode *baseNode = self.dataArr[firstSelectRow];
                return baseNode.subNodeList.count;
            }else{
                DZForumBaseNode *baseNode = self.dataArr[firstSelectRow];
                return baseNode.subNodeList.count;
            }
        }
    }else{
        if (secondSelectRow == -1) {
            return 0;
        }else{
            DZForumBaseNode *baseNode = self.dataArr[firstSelectRow];
            DZForumBaseNode *innerNode = baseNode.subNodeList[secondSelectRow];
            return innerNode.subNodeList.count;
        }
    }
}






/** 自定义cell */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DZ_DropCell"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    if (self.tableCount == 1) {
        DZForumBaseNode *baseNode = self.dataArr[indexPath.row];
        cell.textLabel.text = baseNode.nameStr;
    }else if (self.tableCount == 2){
        NSInteger firstSelectRow = ((UITableView *)self.tableViewArr[0]).indexPathForSelectedRow.row;
        if (tableView == self.tableViewArr[0]) {
            DZForumBaseNode *baseNode = self.dataArr[indexPath.row];
            cell.textLabel.text = baseNode.nameStr;
        }else if (tableView == self.tableViewArr[1]){
            DZForumBaseNode *baseNode = self.dataArr[firstSelectRow];
            DZForumBaseNode *innerNode = baseNode.subNodeList[indexPath.row];
            cell.textLabel.text = innerNode.nameStr;
        }
    }else if (self.tableCount == 3){
        NSInteger firstSelectRow = ((UITableView *)self.tableViewArr[0]).indexPathForSelectedRow.row;
        NSInteger secondSelectRow = ((UITableView *)self.tableViewArr[1]).indexPathForSelectedRow.row;
        
        if (tableView == self.tableViewArr[0]) {
            DZForumBaseNode *baseNode = self.dataArr[indexPath.row];
            cell.textLabel.text = baseNode.nameStr;
        }else if (tableView == self.tableViewArr[1]){
            
            DZForumBaseNode *baseNode = self.dataArr[firstSelectRow];
            DZForumBaseNode *innerNode = baseNode.subNodeList[indexPath.row];
            
            cell.textLabel.text = innerNode.nameStr;
            
        }else if (tableView == self.tableViewArr[2]){
            
            DZForumBaseNode *baseNode = self.dataArr[firstSelectRow];
            DZForumBaseNode *innerNode = baseNode.subNodeList[secondSelectRow];
            DZForumBaseNode *innerthriNode = innerNode.subNodeList[indexPath.row];
            cell.textLabel.text =  innerthriNode.nameStr;
        }
    }
    
    return cell;
    
}


/** 点击 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableView *secondTableView = self.tableViewArr[1];
    UITableView *thirdTableView = self.tableViewArr[2];
    
    if (self.tableCount == 1) {
        [self saveSelects];
        [self dismiss];
        DZForumBaseNode *baseNode = self.dataArr[indexPath.row];
        [_delegate DropMenuListView:self didSelectNode:baseNode];
    }else if (self.tableCount == 2){
        if (tableView == self.tableViewArr[0]) {
            if (!secondTableView.superview) {
                [self.tableViewUnderView addSubview:secondTableView];
            }
            [secondTableView reloadData];
            [self adjustTableViews];
            DZForumBaseNode *baseNode = self.dataArr[indexPath.row];
            [_delegate DropMenuListView:self didSelectNode:baseNode];
        }else if (tableView == self.tableViewArr[1]){
            [self saveSelects];
            [self dismiss];
            NSInteger firstSelectRow = ((UITableView *)self.tableViewArr[0]).indexPathForSelectedRow.row;
            DZForumBaseNode *baseNode = self.dataArr[firstSelectRow];
            DZForumBaseNode *innerNode = baseNode.subNodeList[indexPath.row];
            [_delegate DropMenuListView:self didSelectNode:innerNode];
        }
    }else if (self.tableCount == 3){
        NSInteger firstSelectRow = ((UITableView *)self.tableViewArr[0]).indexPathForSelectedRow.row;
        NSInteger secondSelectRow = ((UITableView *)self.tableViewArr[1]).indexPathForSelectedRow.row;
        if (tableView == self.tableViewArr[0]) {
            if (!secondTableView.superview) {
                [self.tableViewUnderView addSubview:secondTableView];
            }
            [self adjustTableViews];
            [secondTableView reloadData];
            [thirdTableView reloadData];
//            DZForumBaseNode *baseNode = self.dataArr[indexPath.row];
//            [_delegate DropMenuListView:self didSelectNode:baseNode];
        }else if (tableView == self.tableViewArr[1]){
            if (!thirdTableView.superview) {
                [self.tableViewUnderView addSubview:thirdTableView];
            }
            [self adjustTableViews];
            [thirdTableView reloadData];
            DZForumBaseNode *baseNode = self.dataArr[firstSelectRow];
            DZForumBaseNode *innerNode = baseNode.subNodeList[indexPath.row];
            [_delegate DropMenuListView:self didSelectNode:innerNode];
        }else if (tableView == self.tableViewArr[2]){
            [self saveSelects];
            [self dismiss];
            DZForumBaseNode *baseNode = self.dataArr[firstSelectRow];
            DZForumBaseNode *innerNode = baseNode.subNodeList[secondSelectRow];
            DZForumBaseNode *innerthriNode = innerNode.subNodeList[indexPath.row];
            [_delegate DropMenuListView:self didSelectNode:innerthriNode];
        }
    }
}


#pragma mark - 记录 选择状态
-(void)saveSelects{
    [self.tableViewArr enumerateObjectsUsingBlock:^(UITableView *tableView, NSUInteger idx, BOOL * _Nonnull stop) {
        m_selects[idx] = tableView.superview ? tableView.indexPathForSelectedRow.row : -1;
    }];
}



#pragma mark - 视图消失
- (void)dismiss{
    if(self.superview) {
        self.isShow = !self.isShow;
        [self endEditing:YES];
        self.tableViewUnderView.alpha = .0f;
        [self.tableViewUnderView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
        [UIView animateWithDuration:0.2 animations:^{
            if (self.arrowView) {
                self.arrowView.transform = CGAffineTransformMakeRotation(0);
            }
        }];
    }
}

/** 底部按钮, 视图消失 */
-(void)backCancelButonClickAction:(UIButton *)button{
    if (self.tableViewUnderView.alpha > 0) {
        [self dismiss];
    }
}


/** 懒加载 */
-(NSArray *)tableViewArr{
    
    if (_tableViewArr == nil) {
        
        _tableViewArr = @[[[UITableView alloc] init], [[UITableView alloc] init], [[UITableView alloc] init]];
        
        for (UITableView *tableView in _tableViewArr) {
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DZ_DropCell"];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.frame = CGRectMake(0, 0, 0, 0);
            tableView.backgroundColor = [UIColor whiteColor];
            tableView.tableFooterView = [[UIView alloc] init];
            tableView.showsVerticalScrollIndicator = NO;
            tableView.rowHeight = self.rowHeightNum;
        }
    }
    
    return _tableViewArr;
}



@end








