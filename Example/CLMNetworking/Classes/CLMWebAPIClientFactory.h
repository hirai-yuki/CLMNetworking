//
//  CLMWebAPIClientFactory.h
//  CLMNetworking
//
//  Created by hirai.yuki on 2015/02/13.
//  Copyright (c) 2015年 hirai.yuki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLMArticleWebAPIClient.h"

@interface CLMWebAPIClientFactory : NSObject

#pragma mark - Singleton

+ (instancetype)sharedFactory;

#pragma mark - Public

- (CLMArticleWebAPIClient *)articleWebAPIClient;

@end
