//
//  TestListView.h
//  LXPageScrollView
//
//  Created by lx on 2018/10/11.
//  Copyright © 2018 zuimeiqidai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestListView : UIView

@property(strong, nonatomic) UITableView *tableView;

@property(strong, nonatomic) NSArray <NSString *>*dataSources;

@end

NS_ASSUME_NONNULL_END
