//
//  CLMArticleWebAPIClient.h
//  CLMNetworking
//
//  Created by hirai.yuki on 2015/02/13.
//  Copyright (c) 2015年 hirai.yuki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CLMNetworking/CLMRESTAPICoordinator.h>
#import "CLMArticle.h"

extern NSString * const CLMArticleEndpoint;

@interface CLMArticleWebAPIClient : NSObject

#pragma mark - Initializer

- (instancetype)initWithRESTAPIClient:(CLMRESTAPIClient *)RESTAPIClient;

#pragma mark - Public

- (BFTask *)fetchArticles;

@end
