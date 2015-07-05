// CLMRESTAPIClient.m
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

#import "CLMRESTAPIClient.h"

NSString * const CLMRESTAPIClientRequestParameterKeyPage    = @"page";
NSString * const CLMRESTAPIClientRequestParameterKeyPerPage = @"per_page";
NSString * const CLMRESTAPIClientRequestParameterKeyFields  = @"fields";

@implementation CLMRESTAPIClient

- (instancetype)initWithAuthorizableNetworkingClient:(CLMAuthorizableNetworkingClient *)authorizableNetworkingClient
                                            endpoint:(NSString *)endpoint
{
    NSParameterAssert(authorizableNetworkingClient);
    
    self = [super init];
    
    if (self) {
        _authorizableNetworkingClient = authorizableNetworkingClient;
        _endpoint = endpoint;
    }
    
    return self;
}

#pragma mark - Public - Read resources

- (BFTask *)getResourcesWithParameters:(NSDictionary *)parameters
                   needsAuthentication:(BOOL)needsAuthentication
{
    return [[self.authorizableNetworkingClient GET:[self endpoint]
                                        parameters:parameters
                               needsAuthentication:needsAuthentication] continueWithSuccessBlock:^id(BFTask *task) {
        CLMNetworkingResult *result = task.result;
        
        CLMResourcesResponse *resourcesResponse = [[CLMResourcesResponse alloc] initWithHeaderFields:result.response.allHeaderFields
                                                                                           resources:result.responseObject];
        
        return [BFTask taskWithResult:resourcesResponse];
    }];
}

- (BFTask *)getResourcesWithParameters:(NSDictionary *)parameters
                                fields:(NSArray *)fields
                   needsAuthentication:(BOOL)needsAuthentication
{
    return [self getResourcesWithParameters:[self appendFields:fields toParameters:parameters] needsAuthentication:needsAuthentication];
}

#pragma mark - Public - Read resource

- (BFTask *)getResourceWithIdentifier:(NSInteger)identifier
                           parameters:(NSDictionary *)parameters
                  needsAuthentication:(BOOL)needsAuthentication
{
    NSParameterAssert(identifier);
    
    return [[self.authorizableNetworkingClient GET:[self endpointWithIdentifier:identifier]
                                        parameters:parameters
                               needsAuthentication:needsAuthentication] continueWithSuccessBlock:^id(BFTask *task) {
        CLMNetworkingResult *result = task.result;
        return [BFTask taskWithResult:result.responseObject];
    }];
}

- (BFTask *)getResourceWithIdentifier:(NSInteger)identifier
                           parameters:(NSDictionary *)parameters
                               fields:(NSArray *)fields
                  needsAuthentication:(BOOL)needsAuthentication
{
    return [self getResourceWithIdentifier:identifier
                                parameters:[self appendFields:fields toParameters:parameters]
                       needsAuthentication:needsAuthentication];
}

- (BFTask *)getResourceWithParameters:(NSDictionary *)parameters
                  needsAuthentication:(BOOL)needsAuthentication
{
    return [[self.authorizableNetworkingClient GET:[self endpoint]
                                        parameters:parameters
                               needsAuthentication:needsAuthentication] continueWithSuccessBlock:^id(BFTask *task) {
        CLMNetworkingResult *result = task.result;
        return [BFTask taskWithResult:result.responseObject];
    }];
}

- (BFTask *)getResourceWithParameters:(NSDictionary *)parameters
                               fields:(NSArray *)fields
                  needsAuthentication:(BOOL)needsAuthentication
{
    return [self getResourceWithParameters:[self appendFields:fields toParameters:parameters]
                       needsAuthentication:needsAuthentication];
}

#pragma mark - Public - Create resource

- (BFTask *)createResourceWithParameters:(NSDictionary *)parameters
                     needsAuthentication:(BOOL)needsAuthentication
{
    return [[self.authorizableNetworkingClient POST:[self endpoint]
                                         parameters:parameters
                                needsAuthentication:needsAuthentication] continueWithSuccessBlock:^id(BFTask *task) {
        CLMNetworkingResult *result = task.result;
        return [BFTask taskWithResult:result.responseObject];
    }];
}

- (BFTask *)createResourceWithParameters:(NSDictionary *)parameters
               constructingBodyWithBlock:(CLMConstructingBodyWithBlock)block
                     needsAuthentication:(BOOL)needsAuthentication
{
    return [[self.authorizableNetworkingClient POST:[self endpoint]
                                         parameters:parameters
                          constructingBodyWithBlock:block
                                needsAuthentication:needsAuthentication] continueWithSuccessBlock:^id(BFTask *task) {
        CLMNetworkingResult *result = task.result;
        return [BFTask taskWithResult:result.responseObject];
    }];
}

#pragma mark - Public - Update resource

- (BFTask *)updateResourceWithIdentifier:(NSInteger)identifier
                              parameters:(NSDictionary *)parameters
                     needsAuthentication:(BOOL)needsAuthentication
{
    NSParameterAssert(identifier);
    
    return [[self.authorizableNetworkingClient PUT:[self endpointWithIdentifier:identifier]
                                        parameters:parameters
                               needsAuthentication:needsAuthentication] continueWithSuccessBlock:^id(BFTask *task) {
        CLMNetworkingResult *result = task.result;
        return [BFTask taskWithResult:result.responseObject];
    }];
}

- (BFTask *)updateResourceWithParameters:(NSDictionary *)parameters
                     needsAuthentication:(BOOL)needsAuthentication
{
    return [[self.authorizableNetworkingClient PUT:[self endpoint]
                                        parameters:parameters
                               needsAuthentication:needsAuthentication] continueWithSuccessBlock:^id(BFTask *task) {
        CLMNetworkingResult *result = task.result;
        return [BFTask taskWithResult:result.responseObject];
    }];
}

- (BFTask *)updateResourceWithIdentifier:(NSInteger)identifier
                              parameters:(NSDictionary *)parameters
               constructingBodyWithBlock:(CLMConstructingBodyWithBlock)block
                     needsAuthentication:(BOOL)needsAuthentication
{
    NSParameterAssert(identifier);
    
    return [[self.authorizableNetworkingClient PUT:[self endpointWithIdentifier:identifier]
                                        parameters:parameters
                         constructingBodyWithBlock:block
                               needsAuthentication:needsAuthentication] continueWithSuccessBlock:^id(BFTask *task) {
        CLMNetworkingResult *result = task.result;
        return [BFTask taskWithResult:result.responseObject];
    }];
}

- (BFTask *)updateResourceWithParameters:(NSDictionary *)parameters
               constructingBodyWithBlock:(CLMConstructingBodyWithBlock)block
                     needsAuthentication:(BOOL)needsAuthentication
{
    return [[self.authorizableNetworkingClient PUT:[self endpoint]
                                        parameters:parameters
                         constructingBodyWithBlock:block
                               needsAuthentication:needsAuthentication] continueWithSuccessBlock:^id(BFTask *task) {
        CLMNetworkingResult *result = task.result;
        return [BFTask taskWithResult:result.responseObject];
    }];
}

#pragma mark - Public - Destroy resource

- (BFTask *)destroyResourceWithIdentifier:(NSInteger)identifier
                      needsAuthentication:(BOOL)needsAuthentication
{
    NSParameterAssert(identifier);
    
    return [self.authorizableNetworkingClient DELETE:[self endpointWithIdentifier:identifier]
                                          parameters:nil
                                 needsAuthentication:needsAuthentication];
}

- (BFTask *)destroyResourceWithNeedsAuthentication:(BOOL)needsAuthentication
{
    return [self.authorizableNetworkingClient DELETE:[self endpoint]
                                          parameters:nil
                                 needsAuthentication:needsAuthentication];
}

#pragma mark - Public

- (void)cancelAll
{
    [self.authorizableNetworkingClient cancelAll];
}

#pragma mark - Private

- (NSString *)endpointWithIdentifier:(NSInteger)identifier
{
    NSParameterAssert(identifier);
    
    return [self.endpoint stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", @(identifier)]];
}

- (NSDictionary *)appendFields:(NSArray *)fields
                  toParameters:(NSDictionary *)parameters
{
    NSMutableDictionary *mutabledParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutabledParameters[CLMRESTAPIClientRequestParameterKeyFields] = [fields componentsJoinedByString:@","];
    
    return [NSDictionary dictionaryWithDictionary:mutabledParameters];
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ authorizableNetworkingClient: %@; endpoint: %@;",
            [super description], _authorizableNetworkingClient, _endpoint];
}

@end
