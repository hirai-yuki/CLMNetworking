//
//  CLMArticleServiceProtocol.h
//  CLMNetworking
//
//  Created by hirai.yuki on 2015/02/13.
//  Copyright (c) 2015年 hirai.yuki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>

@protocol CLMArticleServiceProtocol <NSObject>

@required
- (BFTask *)fetchArticles;
- (NSArray *)articles;

@end