// CLMURLFilterHandler.m
//
// Copyright (c) 2015 CLMNetworking (http://dev.classmethod.jp)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "CLMURLFilterHandler.h"
#import "CLMURLFormatter.h"

static NSString * const CLMURLFilterHandlerDefaultURLKeySuffix = @"url";

@implementation CLMURLFilterHandler

#pragma mark - Initializer

+ (instancetype)defaultFilterHandler
{
    return [[self alloc] initWithSuffix:CLMURLFilterHandlerDefaultURLKeySuffix];
}

- (instancetype)initWithSuffix:(NSString *)suffix
{
    self = [super init];
    
    if (self) {
        _suffix = suffix;
    }
    
    return self;
}

#pragma mark - Public (Override)

- (void)filterMutableDictionary:(NSMutableDictionary *)mutableDictionary object:(id)object forKey:(NSString *)key
{
    if ([key hasSuffix:self.suffix]) {
        if ([object isKindOfClass:[NSString class]]) {
            NSURL *url = [CLMURLFormatter URLFromUrlString:object];
            if (url) {
                mutableDictionary[key] = url;
            }
        } else if ([object isKindOfClass:[NSDate class]]) {
            NSString *string = [CLMURLFormatter stringFromURL:object];
            if (string) {
                mutableDictionary[key] = string;
            }
        }
    } else {
        [self.nextHanlder filterMutableDictionary:mutableDictionary object:object forKey:key];
    }
}

@end
