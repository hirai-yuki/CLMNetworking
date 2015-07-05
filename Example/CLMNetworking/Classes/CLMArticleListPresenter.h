//
//  CLMArticleListPresenter.h
//  CLMNetworking
//
//  Created by hirai.yuki on 2015/02/13.
//  Copyright (c) 2015年 hirai.yuki. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CLMArticleListViewProtocol;

@interface CLMArticleListPresenter : NSObject

#pragma mark - Initializer

+ (instancetype)presenterWithView:(id<CLMArticleListViewProtocol>)view;

#pragma mark - Public

- (void)viewDidLoad;

@end
