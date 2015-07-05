// CLMOAuth2AuthenticationAgent.m
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

#import "CLMOAuth2AuthenticationAgent.h"
#import <AFOAuth2Manager/AFHTTPRequestSerializer+OAuth2.h>

static NSInteger CLMOAuth2ClientAFOAuth2ManagerMaxConcurrentOperationCount = 1;

@interface CLMOAuth2AuthenticationAgent ()

@property (nonatomic) BFTaskCompletionSource *currentTaskCompletionSource;
@property (nonatomic) NSMutableArray *waitingTaskCompletionSources;
@property (nonatomic) dispatch_queue_t executionQueue;

@end

@implementation CLMOAuth2AuthenticationAgent

+ (instancetype)authenticationAgentWithBaseURL:(NSURL *)url
                                      endpoint:(NSString *)endpoint
                                      clientID:(NSString *)clientID
                                        secret:(NSString *)secret
                            credentialProvider:(id<CLMOAuth2CredentialProvider>)credentialProvider
{
    AFOAuth2Manager *manager = [AFOAuth2Manager clientWithBaseURL:url
                                                         clientID:clientID
                                                           secret:secret];
    
    manager.operationQueue.maxConcurrentOperationCount = CLMOAuth2ClientAFOAuth2ManagerMaxConcurrentOperationCount;
    
    return [[self alloc] initWithOAuth2Manager:manager
                            credentialProvider:credentialProvider
                                      endpoint:endpoint];
}

- (instancetype)initWithOAuth2Manager:(AFOAuth2Manager *)manager
                   credentialProvider:(id<CLMOAuth2CredentialProvider>)credentialProvider
                             endpoint:(NSString *)endpoint
{
    NSParameterAssert(manager);
    NSParameterAssert(credentialProvider);
    NSParameterAssert(endpoint);
    
    self = [super init];
    
    if (self) {
        _manager                      = manager;
        _credentialProvider           = credentialProvider;
        _endpoint                     = endpoint;
        _executionQueue               = dispatch_queue_create("CLMOAuth2ClientExecutionQueue", DISPATCH_QUEUE_SERIAL);
        _currentTaskCompletionSource  = nil;
        _waitingTaskCompletionSources = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Public

- (BFTask *)authenticateUsingOAuthWithUsername:(NSString *)username password:(NSString *)password scope:(NSString *)scope
{
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    
    dispatch_async(self.executionQueue, ^{
        if (self.currentTaskCompletionSource) {
            [self.waitingTaskCompletionSources addObject:completionSource];
        } else {
            self.currentTaskCompletionSource = completionSource;
            
            [self.manager authenticateUsingOAuthWithURLString:self.endpoint username:username password:password scope:scope success:^(AFOAuthCredential *credential) {
                [self executeSuccessProcessing:completionSource credential:credential];
            } failure:^(NSError *error) {
                [self executeFailureProcessing:completionSource error:error];
            }];
        }
    });
    
    return completionSource.task;
}

- (BFTask *)authenticateUsingOAuthWithScope:(NSString *)scope
{
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    
    dispatch_async(self.executionQueue, ^{
        if (self.currentTaskCompletionSource) {
            [self.waitingTaskCompletionSources addObject:completionSource];
        } else {
            self.currentTaskCompletionSource = completionSource;
            
            [self.manager authenticateUsingOAuthWithURLString:self.endpoint scope:scope success:^(AFOAuthCredential *credential) {
                [self executeSuccessProcessing:completionSource credential:credential];
            } failure:^(NSError *error) {
                [self executeFailureProcessing:completionSource error:error];
            }];
        }
    });
    
    return completionSource.task;
}

- (BFTask *)authenticateUsingOAuthWithRefreshToken:(NSString *)refreshToken
{
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    
    dispatch_async(self.executionQueue, ^{
        if (self.currentTaskCompletionSource) {
            [self.waitingTaskCompletionSources addObject:completionSource];
        } else {
            self.currentTaskCompletionSource = completionSource;
            
            [self.manager authenticateUsingOAuthWithURLString:self.endpoint refreshToken:refreshToken success:^(AFOAuthCredential *credential) {
                [self executeSuccessProcessing:completionSource credential:credential];
            } failure:^(NSError *error) {
                [self executeFailureProcessing:completionSource error:error];
            }];
        }
    });
    
    return completionSource.task;
}

- (BFTask *)authenticateUsingOAuthWithCode:(NSString *)code
                               redirectURI:(NSString *)uri
{
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    
    dispatch_async(self.executionQueue, ^{
        if (self.currentTaskCompletionSource) {
            [self.waitingTaskCompletionSources addObject:completionSource];
        } else {
            self.currentTaskCompletionSource = completionSource;
            
            [self.manager authenticateUsingOAuthWithURLString:self.endpoint code:code redirectURI:uri success:^(AFOAuthCredential *credential) {
                [self executeSuccessProcessing:completionSource credential:credential];
            } failure:^(NSError *error) {
                [self executeFailureProcessing:completionSource error:error];
            }];
        }
    });
    
    return completionSource.task;
}

- (BFTask *)authenticateUsingOAuthParameters:(NSDictionary *)parameters
{
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    
    dispatch_async(self.executionQueue, ^{
        if (self.currentTaskCompletionSource) {
            [self.waitingTaskCompletionSources addObject:completionSource];
        } else {
            self.currentTaskCompletionSource = completionSource;
            
            [self.manager authenticateUsingOAuthWithURLString:self.endpoint parameters:parameters success:^(AFOAuthCredential *credential) {
                [self executeSuccessProcessing:completionSource credential:credential];
            } failure:^(NSError *error) {
                [self executeFailureProcessing:completionSource error:error];
            }];
        }
    });
    
    return completionSource.task;
}

#pragma mark - Private

- (void)executeSuccessProcessing:(BFTaskCompletionSource *)completionSource credential:(AFOAuthCredential *)credential
{
    dispatch_async(self.executionQueue, ^{
        dispatch_queue_t completionQueue = self.manager.completionQueue ? self.manager.completionQueue : dispatch_get_main_queue();
        dispatch_async(completionQueue, ^{
            [self.credentialProvider setOAuth2Credential:credential];
            [completionSource setResult:credential];
            
            if (self.waitingTaskCompletionSources.count > 0) {
                for (BFTaskCompletionSource *waitingTaskCompletionSource in self.waitingTaskCompletionSources) {
                    [waitingTaskCompletionSource setResult:credential];
                }
            }
            
            self.waitingTaskCompletionSources = [NSMutableArray array];
            self.currentTaskCompletionSource = nil;
        });
    });
}

- (void)executeFailureProcessing:(BFTaskCompletionSource *)completionSource error:(NSError *)error
{
    dispatch_async(self.executionQueue, ^{
        dispatch_queue_t completionQueue = self.manager.completionQueue ? self.manager.completionQueue : dispatch_get_main_queue();
        dispatch_async(completionQueue, ^{
            [completionSource setError:error];
            
            if (self.waitingTaskCompletionSources.count > 0) {
                for (BFTaskCompletionSource *waitingTaskCompletionSource in self.waitingTaskCompletionSources) {
                    [waitingTaskCompletionSource setError:error];
                }
            }
            
            self.waitingTaskCompletionSources = [NSMutableArray array];
            self.currentTaskCompletionSource = nil;
        });
    });
}

- (BFTask *)refreshToken:(AFOAuthCredential *)credential
{
    NSParameterAssert(credential);
    return [self authenticateUsingOAuthWithRefreshToken:credential.refreshToken];
}

#pragma mark - <CLMAuthenticationAgent>

- (void)setCredential:(AFHTTPRequestOperationManager *)manager
{
    [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:[self.credentialProvider OAuth2Credential]];
}

- (BFTask *)refreshCredential
{
    return [self refreshToken:[self.credentialProvider OAuth2Credential]];
}

- (BOOL)hasCredential
{
    AFOAuthCredential *credential = [self.credentialProvider OAuth2Credential];
    return (credential != nil);
}

- (BOOL)isExpiredCredential
{
    AFOAuthCredential *credential = [self.credentialProvider OAuth2Credential];
    return credential.isExpired;
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ manager: %@; credentialProvider: %@",
            [super description], _manager, _credentialProvider];
}

@end
