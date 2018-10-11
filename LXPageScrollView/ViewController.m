//
//  ViewController.m
//  LXPageScrollView
//
//  Created by lx on 2018/10/8.
//  Copyright © 2018 zuimeiqidai. All rights reserved.
//

#import "ViewController.h"
#import "LXPageScrollView.h"
#import <LXSegmentTitleView.h>
#import "TestListView.h"

static const CGFloat kSectionHeaderHeight = 50;
static const CGFloat kTableHeaderHeight = 150;

@interface ViewController ()<LXPageScrollViewDelegate, LXSegmentTitleViewDelegate>

@property(strong, nonatomic) LXPageScrollView *pageView;

@property(strong, nonatomic) LXSegmentTitleView *segmentView;

@property(strong, nonatomic) NSMutableArray *listViews;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listViews = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i++) {
        TestListView *listView = [[TestListView alloc] init];
        listView.dataSources = @[@"橡胶火箭", @"橡胶火箭炮", @"橡胶机关枪", @"橡胶子弹", @"橡胶攻城炮", @"橡胶象枪", @"橡胶象枪乱打", @"橡胶灰熊铳", @"橡胶雷神象枪", @"橡胶猿王枪", @"橡胶犀·榴弹炮", @"橡胶大蛇炮", @"橡胶火箭", @"橡胶火箭炮", @"橡胶机关枪", @"橡胶子弹", @"橡胶攻城炮", @"橡胶象枪", @"橡胶象枪乱打", @"橡胶灰熊铳", @"橡胶雷神象枪", @"橡胶猿王枪", @"橡胶犀·榴弹炮", @"橡胶大蛇炮", @"橡胶火箭", @"橡胶火箭炮", @"橡胶机关枪", @"橡胶子弹", @"橡胶攻城炮", @"橡胶象枪", @"橡胶象枪乱打", @"橡胶灰熊铳", @"橡胶雷神象枪", @"橡胶猿王枪", @"橡胶犀·榴弹炮"];
        [self.listViews addObject:listView];
    }
    
    self.pageView = [[LXPageScrollView alloc] initWithDelegate:self];
    [self.view addSubview:self.pageView];
    
    self.segmentView = [[LXSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kSectionHeaderHeight)];
    self.segmentView.delegate = self;
    self.segmentView.backgroundColor = [UIColor whiteColor];
    self.segmentView.segmentTitles = @[@"标题1", @"标题2", @"标题3", @"标题4"];
    
    [self.pageView reloadData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.pageView.frame = self.view.bounds;
}

#pragma mark - LXPageScrollViewDelegate

- (UIView *)tableHeaderViewInPageScrollView:(LXPageScrollView *)pageScrollView {
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTableHeaderHeight);
    headerView.backgroundColor = [UIColor blueColor];
    return headerView;
}

- (CGFloat)tableHeaderViewHeightInPageScrollView:(LXPageScrollView *)pageScrollView {
    return kTableHeaderHeight;
}

- (CGFloat)heightForPinSectionHeaderInPageScrollView:(LXPageScrollView *)pageScrollView {
    return kSectionHeaderHeight;
}

- (UIView *)viewForPinSectionHeaderInPageScrollView:(LXPageScrollView *)pageScrollView {
    return self.segmentView;
}

- (NSArray <UIView <LXPageScrollViewListViewDelegate>*>*)listViewsInPageScrollView:(LXPageScrollView *)pageScrollView {
    return [self.listViews copy];
}

- (void)listContainerDidEndDecelerating:(LXPageListContainerView *)containerView {
    NSInteger index = containerView.collectionView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    self.segmentView.selectedIndex = index;
}

#pragma mark - LXSegmentTitleViewDelegate

- (void)segmentTitleView:(LXSegmentTitleView *)segmentView selectedIndex:(NSInteger)selectedIndex lastSelectedIndex:(NSInteger)lastSelectedIndex {
    [self.pageView.listContainerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

@end
