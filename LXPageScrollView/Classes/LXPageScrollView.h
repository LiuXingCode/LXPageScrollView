//
//  LXPageScrollView.h
//  LXPageScrollView
//
//  Created by lx on 2018/10/8.
//  Copyright © 2018 zuimeiqidai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXPageListContainerView.h"
#import "LXPageMainTableView.h"
#import "LXPageScrollViewListViewDelegate.h"

@class LXPageScrollView;

@protocol LXPageScrollViewDelegate <NSObject>

@required

- (CGFloat)heightForPinSectionHeaderInPageScrollView:(LXPageScrollView *)pageScrollView;

- (UIView *)viewForPinSectionHeaderInPageScrollView:(LXPageScrollView *)pageScrollView;

- (NSArray <UIView <LXPageScrollViewListViewDelegate>*>*)listViewsInPageScrollView:(LXPageScrollView *)pageScrollView;

@optional

- (CGFloat)tableHeaderViewHeightInPageScrollView:(LXPageScrollView *)pageScrollView;

- (UIView *)tableHeaderViewInPageScrollView:(LXPageScrollView *)pageScrollView;

- (void)mainTableViewDidScroll:(LXPageMainTableView *)mainTableView;

- (void)listContainerViewDidScroll:(LXPageListContainerView *)containerView;

- (void)listContainerDidEndDecelerating:(LXPageListContainerView *)containerView;

- (void)listContainerDidEndDragging:(LXPageListContainerView *)containerView willDecelerate:(BOOL)decelerate;

- (void)listContainerDidEndScrollingAnimation:(LXPageListContainerView *)containerView;

@end

NS_ASSUME_NONNULL_BEGIN

@interface LXPageScrollView : UIView

@property(weak, nonatomic) id<LXPageScrollViewDelegate> delegate;

@property(strong, nonatomic, readonly) LXPageListContainerView *listContainerView;

@property(strong, nonatomic, readonly) LXPageMainTableView *mainTableView;

- (instancetype)initWithDelegate:(id<LXPageScrollViewDelegate>)delegate;

- (void)initializeViews;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
