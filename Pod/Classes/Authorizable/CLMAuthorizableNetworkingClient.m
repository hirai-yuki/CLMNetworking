// CLMAuthorizableNetworkingClient.m
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

#import "CLMAuthorizableNetworkingClient.h"
#import "NSError+CLMNetworking.h"

@interface CLMAuthorizableNetworkingClient ()

@property (nonatomic, readwrite) id<CLMAuthenticationAgent> authenticationAgent;

@end

@implementation CLMAuthorizableNetworkingClient

#pragma mark - Initializer

- (instancetype)initWithNetworkingClient:(CLMNetworkingClient *)networkingClient
                     authenticationAgent:(id<CLMAuthenticationAgent>)authenticationAgent;
{
    NSParameterAssert(networkingClient);
    
    self = [super init];
    
    if (self) {
        _networkingClient = networkingClient;
        _authenticationAgent = authenticationAgent;
    }
    
    return self;
}

#pragma mark - Public - GET

- (BFTask *)GET:(NSString *)URLString parameters:(id)parameters needsAuthentication:(BOOL)needsAuthentication
{
    return [self requestTaskWithHTTPMethod:@"GET" URLString:URLString parameters:parameters constructingBodyWithBlock:nil needsAuthentication:needsAuthentication];
}

#pragma mark - Public - HEAD

- (BFTask *)HEAD:(NSString *)URLString parameters:(id)parameters needsAuthentication:(BOOL)needsAuthentication
{
    return [self requestTaskWithHTTPMethod:@"HEAD" URLString:URLString parameters:parameters constructingBodyWithBlock:nil needsAuthentication:needsAuthentication];
}

#pragma mark - Public - POST

- (BFTask *)POST:(NSString *)URLString parameters:(id)parameters needsAuthentication:(BOOL)needsAuthentication
{
    return [self requestTaskWithHTTPMethod:@"POST" URLString:URLString parameters:parameters constructingBodyWithBlock:nil needsAuthentication:needsAuthentication];
}

- (BFTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block needsAuthentication:(BOOL)needsAuthentication
{
    return [self requestTaskWithHTTPMethod:@"POST" URLString:URLString parameters:parameters constructingBodyWithBlock:block needsAuthentication:needsAuthentication];
}

#pragma mark - Public - PUT

- (BFTask *)PUT:(NSString *)URLString parameters:(id)parameters needsAuthentication:(BOOL)needsAuthentication
{
    return [self requestTaskWithHTTPMethod:@"PUT" URLString:URLString parameters:parameters constructingBodyWithBlock:nil needsAuthentication:needsAuthentication];
}

- (BFTask *)PUT:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block needsAuthentication:(BOOL)needsAuthentication
{
    return [self requestTaskWithHTTPMethod:@"PUT" URLString:URLString parameters:parameters constructingBodyWithBlock:block needsAuthentication:needsAuthentication];
}

#pragma mark - Public - PATCH

- (BFTask *)PATCH:(NSString *)URLString parameters:(id)parameters needsAuthentication:(BOOL)needsAuthentication
{
    return [self requestTaskWithHTTPMethod:@"PATCH" URLString:URLString parameters:parameters constructingBodyWithBlock:nil needsAuthentication:needsAuthentication];
}

- (BFTask *)PATCH:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block needsAuthentication:(BOOL)needsAuthentication
{
    return [self requestTaskWithHTTPMethod:@"PATCH" URLString:URLString parameters:parameters constructingBodyWithBlock:block needsAuthentication:needsAuthentication];
}

#pragma mark - Public - DELETE

- (BFTask *)DELETE:(NSString *)URLString parameters:(id)parameters needsAuthentication:(BOOL)needsAuthentication
{
    return [self requestTaskWithHTTPMethod:@"DELETE" URLString:URLString parameters:parameters constructingBodyWithBlock:nil needsAuthentication:needsAuthentication];
}

#pragma mark - Public

- (void)cancelAll
{
    [self.networkingClient cancelAll];
}


#pragma mark - Private

- (BFTask *)requestTaskWithHTTPMethod:(NSString *)method
                            URLString:(NSString *)URLString
                           parameters:(id)parameters
            constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                  needsAuthentication:(BOOL)needsAuthentication
{
    if (needsAuthentication) {
        NSParameterAssert(self.authenticationAgent);
        return [self authorizedRequestTaskWithHTTPMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block];
    } else {
        return [self.networkingClient requestTaskWithHTTPMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block];
    }
}

- (BFTask *)authorizedRequestTaskWithHTTPMethod:(NSString *)method
                                      URLString:(NSString *)URLString
                                     parameters:(id)parameters
                      constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
{
    return [[self validateTokenEmptyTask] continueWithSuccessBlock:^id(BFTask *task) {
        return [[self validateTokenExpirationTask] continueWithSuccessBlock:^id(BFTask *task) {
            return [self executeAuthorizedRequestTaskWithHTTPMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block];
        }];
    }];
}

#pragma mark - Private - Authorized request's tasks

- (BFTask *)validateTokenEmptyTask
{
    BFTask *validateTokenTask;
    
    if ([self.authenticationAgent hasCredential]) {
        validateTokenTask = [BFTask taskWithResult:nil];
    } else {
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey : @"Authentication agent doesn't have credential."
                                   };
        
        NSError *error = [NSError CLMNetworkingErrorWithErrorCode:CLMNetworkingErrorCodeUnauthorized userInfo:userInfo];
        
        validateTokenTask = [BFTask taskWithError:error];
    }
    
    return validateTokenTask;
}

- (BFTask *)validateTokenExpirationTask
{
    BFTask *validateTokenExpirationTask;
    
    if ([self.authenticationAgent isExpiredCredential]) {
        validateTokenExpirationTask = [self.authenticationAgent refreshCredential];
    } else {
        validateTokenExpirationTask = [BFTask taskWithResult:nil];
    }
    
    return validateTokenExpirationTask;
}

- (BFTask *)executeAuthorizedRequestTaskWithHTTPMethod:(NSString *)method
                                             URLString:(NSString *)URLString
                                            parameters:(id)parameters
                             constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
{
    [self.authenticationAgent setCredential:self.networkingClient.manager];

    return [[self.networkingClient requestTaskWithHTTPMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block] continueWithBlock:^id(BFTask *task) {
        if (task.error.unauthorized) {
            BFTask *refreshTokenTask = [self.authenticationAgent refreshCredential];
            
            return [refreshTokenTask continueWithSuccessBlock:^id(BFTask *task) {
                [self.authenticationAgent setCredential:self.networkingClient.manager];
                return [self.networkingClient requestTaskWithHTTPMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block];
            }];
        } else {
            return task;
        }
    }];
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ networkingClient: %@; authenticationAgent: %@;",
            [super description], _networkingClient, _authenticationAgent];
}

@end

