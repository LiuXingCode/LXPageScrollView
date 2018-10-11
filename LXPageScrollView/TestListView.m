//
//  TestListView.m
//  LXPageScrollView
//
//  Created by lx on 2018/10/11.
//  Copyright © 2018 zuimeiqidai. All rights reserved.
//

#import "TestListView.h"
#import "LXPageScrollViewListViewDelegate.h"

static NSString *const kCellId = @"kCellId";

@interface TestListView()<UITableViewDelegate, UITableViewDataSource, LXPageScrollViewListViewDelegate>

@property(copy, nonatomic) void(^didScrollCallback)(UIScrollView *scrollView);

@end

@implementation TestListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (void)setDataSources:(NSArray<NSString *> *)dataSources {
    _dataSources = [dataSources copy];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId];
    }
    cell.textLabel.text = self.dataSources[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.didScrollCallback ?: self.didScrollCallback(self.tableView);
}

#pragma mark - LXPageScrollViewListViewDelegate

- (UIScrollView *)listScollView {
    return self.tableView;
}

- (void)listViewDidScrollViewCallback:(void (^)(UIScrollView *))callback {
    self.didScrollCallback = callback;
}

@end
