//
//  CLMArticleService.m
//  CLMNetworking
//
//  Created by hirai.yuki on 2015/02/13.
//  Copyright (c) 2015年 hirai.yuki. All rights reserved.
//

#import "CLMArticleService.h"
#import "CLMArticleRepository.h"

@interface CLMArticleService ()

@property (nonatomic) CLMArticleRepository *articleRepository;

@end

@implementation CLMArticleService

+ (instancetype)articleService {
    CLMArticleRepository *articleRepository = [CLMArticleRepository new];
    return [[self alloc] initWithArticleRepository:articleRepository];
}

- (instancetype)initWithArticleRepository:(CLMArticleRepository *)articleRepository {
    self = [super init];
    
    if (self) {
        _articleRepository = articleRepository;
    }

    return self;
}

#pragma mark - Public

- (BFTask *)fetchArticles {
    return [self.articleRepository fetchArticles];
}

- (NSArray *)articles {
    return self.articleRepository.articles;
}

@end
