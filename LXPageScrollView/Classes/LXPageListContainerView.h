//
//  LXPageListContainerView.h
//  LXPageScrollView
//
//  Created by lx on 2018/10/8.
//  Copyright © 2018 zuimeiqidai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXPageListContainerView;
@class LXPageMainTableView;

@protocol LXPageListContainerViewDelegate <NSObject>

@required

- (NSInteger)numberOfRowsInListContainerView:(LXPageListContainerView *)containerView;

- (UIView *)listContainerView:(LXPageListContainerView *)containerView listViewInRow:(NSInteger)row;

@optional

- (void)listContainerView:(LXPageListContainerView *)containerView willDisplayCellAtRow:(NSInteger)row;

- (void)listContainerViewDidScroll:(LXPageListContainerView *)containerView;

- (void)listContainerDidEndDecelerating:(LXPageListContainerView *)containerView;

- (void)listContainerDidEndDragging:(LXPageListContainerView *)containerView willDecelerate:(BOOL)decelerate;

- (void)listContainerDidEndScrollingAnimation:(LXPageListContainerView *)containerView;

@end

NS_ASSUME_NONNULL_BEGIN

@interface LXPageListContainerView : UIView

@property(strong, nonatomic, readonly) UICollectionView *collectionView;

@property(weak, nonatomic) id<LXPageListContainerViewDelegate> delegate;

- (instancetype)initWithDelegate:(id<LXPageListContainerViewDelegate>)delegate;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
