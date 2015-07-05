//
//  CLMArticleRepository.m
//  CLMNetworking
//
//  Created by hirai.yuki on 2015/02/13.
//  Copyright (c) 2015年 hirai.yuki. All rights reserved.
//

#import "CLMArticleRepository.h"
#import "CLMWebAPIClientFactory.h"

@interface CLMArticleRepository ()

@property (nonatomic, readwrite) NSArray *articles;

@end

@implementation CLMArticleRepository

#pragma mark - Public

- (BFTask *)fetchArticles {
    CLMWebAPIClientFactory *webAPIClientFacgtory = [CLMWebAPIClientFactory sharedFactory];
    CLMArticleWebAPIClient *client = [webAPIClientFacgtory articleWebAPIClient];
    
    return [[client fetchArticles] continueWithSuccessBlock:^id(BFTask *task) {
        self.articles = task.result;
        return task;
    }];
}

@end
