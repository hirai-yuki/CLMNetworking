//
//  CLMArticleRepository.h
//  CLMNetworking
//
//  Created by hirai.yuki on 2015/02/13.
//  Copyright (c) 2015年 hirai.yuki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>
#import "CLMArticle.h"

@interface CLMArticleRepository : NSObject

@property (nonatomic, readonly) NSArray *articles;

#pragma mark - Public

- (BFTask *)fetchArticles;

@end
