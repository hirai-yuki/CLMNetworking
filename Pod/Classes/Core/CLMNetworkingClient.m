// CLMNetworkingClient.m
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

#import "CLMNetworkingClient.h"

typedef void (^SuccessBlock)(AFHTTPRequestOperation *, id);
typedef void (^FailureBlock)(AFHTTPRequestOperation *, NSError *);

@implementation CLMNetworkingClient

#pragma mark - Initializer

- (instancetype)initWithManager:(AFHTTPRequestOperationManager *)manager
{
    NSParameterAssert(manager);
    
    self = [super init];
    
    if (self) {
        _manager = manager;
        _filter = [CLMFilter new];
    }
    
    return self;
}

#pragma mark - Public - GET

- (BFTask *)GET:(NSString *)URLString parameters:(id)parameters
{
    return [self requestTaskWithHTTPMethod:@"GET" URLString:URLString parameters:parameters constructingBodyWithBlock:nil];
}

#pragma mark - Public - HEAD

- (BFTask *)HEAD:(NSString *)URLString parameters:(id)parameters
{
    return [self requestTaskWithHTTPMethod:@"HEAD" URLString:URLString parameters:parameters constructingBodyWithBlock:nil];
}

#pragma mark - Public - POST

- (BFTask *)POST:(NSString *)URLString parameters:(id)parameters
{
    return [self requestTaskWithHTTPMethod:@"POST" URLString:URLString parameters:parameters constructingBodyWithBlock:nil];
}

- (BFTask *)POST:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(CLMConstructingBodyWithBlock)block
{
    return [self requestTaskWithHTTPMethod:@"POST" URLString:URLString parameters:parameters constructingBodyWithBlock:block];
}

#pragma mark - Public - PUT

- (BFTask *)PUT:(NSString *)URLString parameters:(id)parameters
{
    return [self requestTaskWithHTTPMethod:@"PUT" URLString:URLString parameters:parameters constructingBodyWithBlock:nil];
}

- (BFTask *)PUT:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(CLMConstructingBodyWithBlock)block
{
    return [self requestTaskWithHTTPMethod:@"PUT" URLString:URLString parameters:parameters constructingBodyWithBlock:block];
}

#pragma mark - Public - PATCH

- (BFTask *)PATCH:(NSString *)URLString parameters:(id)parameters
{
    return [self requestTaskWithHTTPMethod:@"PATCH" URLString:URLString parameters:parameters constructingBodyWithBlock:nil];
}

- (BFTask *)PATCH:(NSString *)URLString parameters:(id)parameters constructingBodyWithBlock:(CLMConstructingBodyWithBlock)block
{
    return [self requestTaskWithHTTPMethod:@"PATCH" URLString:URLString parameters:parameters constructingBodyWithBlock:block];
}

#pragma mark - Public - DELETE

- (BFTask *)DELETE:(NSString *)URLString parameters:(id)parameters
{
    return [self requestTaskWithHTTPMethod:@"DELETE" URLString:URLString parameters:parameters constructingBodyWithBlock:nil];
}

#pragma mark - Public

- (void)cancelAll
{
    [self.manager.operationQueue cancelAllOperations];
}

- (BFTask *)requestTaskWithHTTPMethod:(NSString *)method
                            URLString:(NSString *)URLString
                           parameters:(id)parameters
            constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
{
    NSParameterAssert(method);
    NSParameterAssert(self.filter);
    
    parameters = [self.filter filter:parameters];
    
    NSError *serializationError = nil;
    
    NSMutableURLRequest *request = [self requestWithMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block error:&serializationError];
    
    if (serializationError) {
        return [BFTask taskWithError:serializationError];
    }
    
    BFTask *task = [self operationTaskWithRequest:request];
    
    return [task continueWithSuccessBlock:^id(BFTask *task) {
        AFHTTPRequestOperation *operation = task.result;
        
        id responseObject = [self.filter filter:operation.responseObject];
        
        CLMNetworkingResult *result = [[CLMNetworkingResult alloc] initWithResponseObject:responseObject request:operation.request response:operation.response];
        
        return [BFTask taskWithResult:result];
    }];
}

#pragma mark - Private

- (BFTask *)operationTaskWithRequest:(NSURLRequest *)request
{
    NSParameterAssert(request);
    
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    
    SuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        [completionSource setResult:operation];
    };
    
    FailureBlock failure = ^(AFHTTPRequestOperation *operation, NSError *error) {
        error = [NSError CLMNetworkingErrorWithOperation:operation error:error];
        
        if (error.cancelled) {
            [completionSource cancel];
        } else {
            [completionSource setError:error];
        }
    };
    
    [self operationWithRequest:request success:success failure:failure];
    
    return completionSource.task;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
                 constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                     error:(NSError *__autoreleasing *)error
{
    NSMutableURLRequest *request;
    
    if (block) {
        request = [self.manager.requestSerializer multipartFormRequestWithMethod:method
                                                                       URLString:[[NSURL URLWithString:URLString relativeToURL:self.manager.baseURL] absoluteString]
                                                                      parameters:parameters
                                                       constructingBodyWithBlock:block
                                                                           error:error];
    } else {
        request = [self.manager.requestSerializer requestWithMethod:method
                                                          URLString:[[NSURL URLWithString:URLString relativeToURL:self.manager.baseURL] absoluteString]
                                                         parameters:parameters
                                                              error:error];
    }
    
    return request;
}

- (AFHTTPRequestOperation *)operationWithRequest:(NSURLRequest *)request
                                         success:(SuccessBlock)success
                                         failure:(FailureBlock)failure
{
    AFHTTPRequestOperation *operation = [self.manager HTTPRequestOperationWithRequest:request success:success failure:failure];
    
    [self.manager.operationQueue addOperation:operation];
    
    return operation;
}

@end
