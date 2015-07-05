//
//  CLMArticleListPresenter.m
//  CLMNetworking
//
//  Created by hirai.yuki on 2015/02/13.
//  Copyright (c) 2015年 hirai.yuki. All rights reserved.
//

#import "CLMArticleListPresenter.h"
#import "CLMArticleListViewProtocol.h"
#import "CLMArticleService.h"

@interface CLMArticleListPresenter ()

@property (nonatomic) id<CLMArticleListViewProtocol> view;
@property (nonatomic) id<CLMArticleServiceProtocol> articleService;

@end

@implementation CLMArticleListPresenter

#pragma mark - Initializer

+ (instancetype)presenterWithView:(id<CLMArticleListViewProtocol>)view {
    CLMArticleService *articleService = [CLMArticleService articleService];
    return [[self alloc] initWithView:view articleService:articleService];
}

- (instancetype)initWithView:(id<CLMArticleListViewProtocol>)view articleService:(id<CLMArticleServiceProtocol>)articleService {
    self = [super init];
    
    if (self) {
        _view = view;
        _articleService = articleService;
    }
    
    return self;
}

#pragma mark - Public

- (void)viewDidLoad {
    [[self.articleService fetchArticles] continueWithSuccessBlock:^id(BFTask *task) {
        NSArray *articles = [self.articleService articles];
        [self.view displayArticles:articles];
        return nil;
    }];
}

@end
