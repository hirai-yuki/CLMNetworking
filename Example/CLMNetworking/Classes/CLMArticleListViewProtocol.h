//
//  CLMArticleListViewProtocol.h
//  CLMNetworking
//
//  Created by hirai.yuki on 2015/02/13.
//  Copyright (c) 2015年 hirai.yuki. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CLMArticleListViewProtocol <NSObject>

@required
- (void)displayArticles:(NSArray *)articles;

@end