//
//  CLMArticleWebAPIClient.m
//  CLMNetworking
//
//  Created by hirai.yuki on 2015/02/13.
//  Copyright (c) 2015年 hirai.yuki. All rights reserved.
//

#import "CLMArticleWebAPIClient.h"

NSString * const CLMArticleEndpoint = @"articles";

@interface CLMArticleWebAPIClient ()

@property (nonatomic, readonly) CLMRESTAPIClient *RESTAPIClient;

@end

@implementation CLMArticleWebAPIClient

#pragma mark - Initializer methods

- (instancetype)initWithRESTAPIClient:(CLMRESTAPIClient *)RESTAPIClient {
    self = [super init];
    
    if (self) {
        _RESTAPIClient = RESTAPIClient;
    }
    
    return self;
}

#pragma mark - Public

- (BFTask *)fetchArticles {
    return [[self.RESTAPIClient getResourcesWithParameters:nil needsAuthentication:NO] continueWithSuccessBlock:^id(BFTask *task) {
        CLMResourcesResponse *response = task.result;
        
        NSMutableArray *articles = [NSMutableArray array];
        
        for (NSDictionary *articleResponse in response.resources) {
            CLMArticle *article = [[CLMArticle alloc] initWithDictionary:articleResponse];
            [articles addObject:article];
        }
        
        return [BFTask taskWithResult:[NSArray arrayWithArray:articles]];
    }];
}

@end
