//
//  LXPageScrollView.m
//  LXPageScrollView
//
//  Created by lx on 2018/10/8.
//  Copyright © 2018 zuimeiqidai. All rights reserved.
//

#import "LXPageScrollView.h"

static NSString *const kTableViewCellID = @"kTableViewCellID";

@interface LXPageScrollView()<UITableViewDelegate, UITableViewDataSource, LXPageListContainerViewDelegate>

@property(strong, nonatomic, readwrite) LXPageListContainerView *listContainerView;

@property(strong, nonatomic, readwrite) LXPageMainTableView *mainTableView;

@property(strong, nonatomic) UIScrollView *currentScrollingListView;

@end

@implementation LXPageScrollView

- (instancetype)initWithDelegate:(id<LXPageScrollViewDelegate>)delegate {
    if (self = [super initWithFrame:CGRectZero]) {
        self.delegate = delegate;
        [self initializeViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializeViews];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews {
    self.mainTableView = [[LXPageMainTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableHeaderViewInPageScrollView:)]) {
        UIView *headerView = [self.delegate tableHeaderViewInPageScrollView:self];
        CGFloat headerHeight = 0;
        if (self.delegate && [self.delegate tableHeaderViewHeightInPageScrollView:self]) {
            headerHeight = [self.delegate tableHeaderViewHeightInPageScrollView:self];
        }
        headerView.frame = CGRectMake(0, 0, self.bounds.size.width, headerHeight);
        self.mainTableView.tableHeaderView = headerView;
    }
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellID];
    [self addSubview:self.mainTableView];
    
    self.listContainerView = [[LXPageListContainerView alloc] initWithDelegate:self];
}

- (void)reloadData {
    [self.mainTableView reloadData];
    [self.listContainerView reloadData];
    
    [self configListViewDidScrollCallback];
}

- (void)preferredProcessListViewDidScroll:(UIScrollView *)scrollView {
    CGFloat headerHeight = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableHeaderViewHeightInPageScrollView:)]) {
        headerHeight = [self.delegate tableHeaderViewHeightInPageScrollView:self];
    }
    if (self.mainTableView.contentOffset.y < headerHeight) {
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
    } else {
        self.mainTableView.contentOffset = CGPointMake(0, headerHeight);
        scrollView.showsVerticalScrollIndicator = YES;
    }
}

- (void)preferredProcessMainTableViewDidScroll:(UIScrollView *)scrollView {
    CGFloat headerHeight = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableHeaderViewHeightInPageScrollView:)]) {
        headerHeight = [self.delegate tableHeaderViewHeightInPageScrollView:self];
    }
    if (self.currentScrollingListView != nil && self.currentScrollingListView.contentOffset.y > 0) {
        self.mainTableView.contentOffset = CGPointMake(0, headerHeight);
    }
    
    if (scrollView.contentOffset.y < headerHeight) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(listViewsInPageScrollView:)]) {
            NSArray *listViews = [self.delegate listViewsInPageScrollView:self];
            for (UIView <LXPageScrollViewListViewDelegate>*listView in listViews) {
                [listView listScollView].contentOffset = CGPointZero;
            }
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.mainTableView.frame = self.bounds;
}

#pragma mark - Private

- (void)configListViewDidScrollCallback {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listViewsInPageScrollView:)]) {
        NSArray *listViews = [self.delegate listViewsInPageScrollView:self];
        for (UIView <LXPageScrollViewListViewDelegate>*listView in listViews) {
            __weak typeof(self) weakSelf = self;
            [listView listViewDidScrollViewCallback:^(UIScrollView *scrollView) {
                [weakSelf listViewDidScroll:scrollView];
            }];
        }
    }
}

- (void)listViewDidScroll:(UIScrollView *)scrollView {
    self.currentScrollingListView = scrollView;
    [self preferredProcessListViewDidScroll:scrollView];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellID forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.listContainerView.frame = cell.contentView.bounds;
    [cell.contentView addSubview:self.listContainerView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(heightForPinSectionHeaderInPageScrollView:)]) {
        return self.bounds.size.height - [self.delegate heightForPinSectionHeaderInPageScrollView:self];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewForPinSectionHeaderInPageScrollView:)]) {
        return [self.delegate viewForPinSectionHeaderInPageScrollView:self];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(heightForPinSectionHeaderInPageScrollView:)]) {
        return [self.delegate heightForPinSectionHeaderInPageScrollView:self];
    }
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mainTableView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(mainTableViewDidScroll:)]) {
            [self.delegate mainTableViewDidScroll:self.mainTableView];
        }
    }
}

#pragma mark - LXPageListContainerViewDelegate

- (NSInteger)numberOfRowsInListContainerView:(LXPageListContainerView *)containerView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listViewsInPageScrollView:)]) {
        NSArray *listViews = [self.delegate listViewsInPageScrollView:self];
        return listViews.count;
    }
    return 0;
}

- (UIView *)listContainerView:(LXPageListContainerView *)containerView listViewInRow:(NSInteger)row {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listViewsInPageScrollView:)]) {
        NSArray *listViews = [self.delegate listViewsInPageScrollView:self];
        if (row < listViews.count) {
            return listViews[row];
        }
    }
    return nil;
}

- (void)listContainerView:(LXPageListContainerView *)containerView willDisplayCellAtRow:(NSInteger)row {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listViewsInPageScrollView:)]) {
        NSArray *listViews = [self.delegate listViewsInPageScrollView:self];
        if (row < listViews.count) {
            self.currentScrollingListView = listViews[row];
        }
    }
}

- (void)listContainerViewDidScroll:(LXPageListContainerView *)containerView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerViewDidScroll:)]) {
        [self.delegate listContainerViewDidScroll:containerView];
    }
    if (containerView.collectionView.isTracking || containerView.collectionView.isDecelerating) {
        self.mainTableView.scrollEnabled = NO;
    }
}

- (void)listContainerDidEndDecelerating:(LXPageListContainerView *)containerView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerDidEndDecelerating:)]) {
        [self.delegate listContainerDidEndDecelerating:containerView];
    }
    self.mainTableView.scrollEnabled = YES;
}

- (void)listContainerDidEndDragging:(LXPageListContainerView *)containerView willDecelerate:(BOOL)decelerate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerDidEndDragging:willDecelerate:)]) {
        [self listContainerDidEndDragging:containerView willDecelerate:decelerate];
    }
    self.mainTableView.scrollEnabled = YES;
}

- (void)listContainerDidEndScrollingAnimation:(LXPageListContainerView *)containerView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerDidEndScrollingAnimation:)]) {
        [self listContainerDidEndScrollingAnimation:containerView];
    }
    self.mainTableView.scrollEnabled = YES;
}

@end
