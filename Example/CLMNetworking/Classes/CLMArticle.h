//
//  CLMArticle.h
//  CLMNetworking
//
//  Created by hirai.yuki on 2015/02/13.
//  Copyright (c) 2015年 hirai.yuki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLMArticle : NSObject

@property (copy, nonatomic, readonly) NSNumber *identifier;
@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) NSString *content;
@property (copy, nonatomic, readonly) NSURL *imageUrl;
@property (copy, nonatomic, readonly) NSDate *createdAt;
@property (copy, nonatomic, readonly) NSDate *updatedAt;

#pragma mark - Intializer

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
