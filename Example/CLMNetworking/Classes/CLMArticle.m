//
//  CLMArticle.m
//  CLMNetworking
//
//  Created by hirai.yuki on 2015/02/13.
//  Copyright (c) 2015年 hirai.yuki. All rights reserved.
//

#import "CLMArticle.h"

@implementation CLMArticle

#pragma mark - Initializer

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _identifier = [dictionary[@"id"] copy];
        _title = [dictionary[@"title"] copy];
        _content = [dictionary[@"content"] copy];
        _imageUrl = [dictionary[@"image_url"] copy];
        _createdAt = [dictionary[@"created_at"] copy];
        _updatedAt = [dictionary[@"updated_at"] copy];
    }
    
    return self;
}

#pragma mark - <NSObject>

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    typeof(self) other = object;
    
    return [self.identifier isEqualToNumber:other.identifier];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ identifier: %@; title: %@; content: %@; imageUrl: %@; createdAt: %@; updatedAt: %@;;",
            [super description], _identifier, _title, _content, _imageUrl, _createdAt, _updatedAt];
}


@end
