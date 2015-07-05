//
//  CLMArticleService.h
//  CLMNetworking
//
//  Created by hirai.yuki on 2015/02/13.
//  Copyright (c) 2015年 hirai.yuki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>
#import "CLMArticleServiceProtocol.h"
#import "CLMArticleRepository.h"
#import "CLMArticle.h"

@interface CLMArticleService : NSObject <CLMArticleServiceProtocol>

#pragma mark - Initializer

+ (instancetype)articleService;

#pragma mark - Public

- (BFTask *)fetchArticles;

- (NSArray *)articles;

@end
