// CLMPagableResponse.m
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

#import "CLMResourcesResponse.h"
#import "CLMRESTAPIClient.H"

static NSString * const CLMResponseHeaderFieldKeyTotalCount = @"X-List-Totalcount";
static NSString * const CLMResponseHeaderFieldKeyLink = @"Link";
static NSString * const LinkPatternFormat = @"(<([\\w/:%#\\$&\\?\\(\\)~\\.=\\+\\-]+)>; rel=\"([first|prev|next|last]+)\"; page=\"([0-9]+)\")";

@implementation CLMResourcesResponse

#pragma mark - Initializer

- (instancetype)initWithHeaderFields:(NSDictionary *)headerFields
                           resources:(NSArray *)resources
{
    self = [super init];
    
    if (self) {
        _resources = resources;
        [self parseHeaderFields:headerFields];
    }
    
    return self;
}

#pragma mark - Accessor

- (BOOL)pagable
{
    return self.firstPagableRequest || self.prevPagableRequest || self.nextPagableRequest || self.lastPagableRequest;
}

#pragma mark - Private

- (void)parseHeaderFields:(NSDictionary *)headerFields
{
    _totalCount = [@([headerFields[CLMResponseHeaderFieldKeyTotalCount] integerValue]) unsignedIntegerValue];
    
    NSString *linkHeader = headerFields[CLMResponseHeaderFieldKeyLink];
    
    if (!linkHeader || linkHeader.length == 0) {
        return;
    }

    NSError *error = nil;
    
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:LinkPatternFormat
                                                                            options:0
                                                                              error:&error];
    
    if (error) {
        return;
    }
    
    NSArray *matches = [regexp matchesInString:linkHeader options:0 range:NSMakeRange(0, linkHeader.length)];
    
    for (NSTextCheckingResult *result in matches) {
        if (result.numberOfRanges != 5) {
            continue;
        }
        
        NSString *endpoint = [linkHeader substringWithRange:[result rangeAtIndex:2]];
        NSDictionary *parameters = [self extractParametersFromEndpoint:endpoint];
        NSString *pageString = [linkHeader substringWithRange:[result rangeAtIndex:4]];
        NSUInteger page = [pageString integerValue];
        
        NSString *rel = [linkHeader substringWithRange:[result rangeAtIndex:3]];
        
        if ([rel isEqualToString:@"first"]) {
            _firstPagableRequest = [[CLMPagableRequest alloc] initWithPage:page parameters:parameters];
        } else if ([rel isEqualToString:@"prev"]) {
            _prevPagableRequest = [[CLMPagableRequest alloc] initWithPage:page parameters:parameters];
        } else if ([rel isEqualToString:@"next"]) {
            _nextPagableRequest = [[CLMPagableRequest alloc] initWithPage:page parameters:parameters];
        } else if ([rel isEqualToString:@"last"]) {
            _lastPagableRequest = [[CLMPagableRequest alloc] initWithPage:page parameters:parameters];
        }
    }
}

- (NSDictionary *)extractParametersFromEndpoint:(NSString *)endpoint
{
    NSRange range = [endpoint rangeOfString:@"?"];
    
    if (range.location == NSNotFound) {
        return nil;
    }
    
    NSString *query = [endpoint substringFromIndex:range.location + 1];
    
    NSMutableDictionary *queryParameters = [NSMutableDictionary dictionary];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        NSString *key = [elements[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *value = [elements[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        queryParameters[key] = value;
    }
    
    return [NSDictionary dictionaryWithDictionary:queryParameters];
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ resources: %@; totalCount: %@; firstPagableRequest: %@; prevPagableRequest: %@; nextPagableRequest: %@; lastPagableRequest: %@;",
            [super description], _resources, @(_totalCount), _firstPagableRequest, _prevPagableRequest, _nextPagableRequest, _lastPagableRequest];
}

@end
