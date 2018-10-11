//
//  LXPageScrollViewListViewDelegate.h
//  LXPageScrollView
//
//  Created by lx on 2018/10/11.
//  Copyright © 2018 zuimeiqidai. All rights reserved.
//

@protocol LXPageScrollViewListViewDelegate <NSObject>

- (UIScrollView *)listScollView;

- (void)listViewDidScrollViewCallback:(void(^)(UIScrollView *scrollView))callback;

@end

