// CLMFilter.m
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

#import "CLMFilter.h"

@implementation CLMFilter

#pragma mark - Public

- (id)filter:(id)object
{
    id filteredObject;
    
    if ([object isKindOfClass:[NSArray class]]) {
        filteredObject = [self applyToArray:object];
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        filteredObject = [self applyToDictionary:object];
    } else {
        filteredObject = object;
    }
    
    return filteredObject;
}

#pragma mark - Private

- (NSDictionary *)applyToDictionary:(NSDictionary *)dictonary
{
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:dictonary];
    
    for (id key in [dictonary allKeys]) {
        id object = [dictonary objectForKey:key];
        
        [self.handler filterMutableDictionary:mutableDictionary object:object forKey:key];
        
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *subdictionary = [self applyToDictionary:object];
            mutableDictionary[key] = subdictionary;
        } else if ([object isKindOfClass:[NSArray class]]) {
            NSArray *subarray = [self applyToArray:object];
            mutableDictionary[key] = subarray;
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:mutableDictionary];
}

- (NSArray *)applyToArray:(NSArray *)array
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    
    for (id object in array) {
        NSInteger index = [mutableArray indexOfObject:object];
        
        [self.handler filterMutableArray:mutableArray object:object atIndex:index];

        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *subdictionary = [self applyToDictionary:object];
            [mutableArray replaceObjectAtIndex:index withObject:subdictionary];
        } else if ([object isKindOfClass:[NSArray class]]) {
            NSArray *subarray = [self applyToArray:object];
            [mutableArray replaceObjectAtIndex:index withObject:subarray];
        }
    }
    
    return [NSArray arrayWithArray:mutableArray];
}

@end
