//
//  LXPageListContainerView.m
//  LXPageScrollView
//
//  Created by lx on 2018/10/8.
//  Copyright © 2018 zuimeiqidai. All rights reserved.
//

#import "LXPageListContainerView.h"
#import "LXPageMainTableView.h"

static NSString *const kCollectionViewCellID = @"kCollectionViewCellID";

@interface LXPageListContainerView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(strong, nonatomic, readwrite) UICollectionView *collectionView;

@end

@implementation LXPageListContainerView

- (instancetype)initWithDelegate:(id<LXPageListContainerViewDelegate>)delegate {
    if (self = [super initWithFrame:CGRectZero]) {
        self.delegate = delegate;
        [self initalizeViews];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initalizeViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initalizeViews];
    }
    return self;
}

- (void)initalizeViews {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.scrollsToTop = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellID];
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfRowsInListContainerView:)]) {
        return [self.delegate numberOfRowsInListContainerView:self];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellID forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerView:listViewInRow:)]) {
        UIView *view = [self.delegate listContainerView:self listViewInRow:indexPath.row];
        view.frame = cell.contentView.bounds;
        [cell.contentView addSubview:view];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerView:willDisplayCellAtRow:)]) {
        [self.delegate listContainerView:self willDisplayCellAtRow:indexPath.row];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerDidEndDecelerating:)]) {
        [self.delegate listContainerDidEndDecelerating:self];
    }
//    self.mainTableView.scrollEnabled = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerDidEndDragging:willDecelerate:)]) {
        [self.delegate listContainerDidEndDragging:self willDecelerate:decelerate];
    }
//    self.mainTableView.scrollEnabled = YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerDidEndScrollingAnimation:)]) {
        [self.delegate listContainerDidEndScrollingAnimation:self];
    }
//    self.mainTableView.scrollEnabled = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listContainerViewDidScroll:)]) {
        [self.delegate listContainerViewDidScroll:self];
    }
//    if (scrollView.isTracking || scrollView.isDecelerating) {
//        self.mainTableView.scrollEnabled = NO;
//    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size;
}

@end
