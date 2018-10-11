//
//  LXPageMainTableView.m
//  LXPageScrollView
//
//  Created by lx on 2018/10/8.
//  Copyright © 2018 zuimeiqidai. All rights reserved.
//

#import "LXPageMainTableView.h"

@interface LXPageMainTableView()<UIGestureRecognizerDelegate>

@end

@implementation LXPageMainTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

@end
