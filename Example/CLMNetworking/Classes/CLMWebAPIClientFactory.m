//
//  CLMWebAPIClientFactory.m
//  CLMNetworking
//
//  Created by hirai.yuki on 2015/02/13.
//  Copyright (c) 2015年 hirai.yuki. All rights reserved.
//

#import "CLMWebAPIClientFactory.h"
#import <CLMNetworking/CLMRESTAPICoordinator.h>
#import "CLMCredentialProvider.h"

static NSString * const CLMBaseURL = @"http://localhost:3000/";
static NSString * const CLMOAuth2TokenEndpoint = @"oauth/token";
static NSString * const CLMOAuth2ClientID = @"clientID";
static NSString * const CLMOAuth2Secret = @"secret";

@interface CLMWebAPIClientFactory ()

@property (nonatomic) CLMRESTAPICoordinator *coordinator;
@property (nonatomic) CLMCredentialProvider *credentialProvider;

@end

@implementation CLMWebAPIClientFactory

#pragma mark - Singleton

+ (instancetype)sharedFactory {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:CLMBaseURL];
        CLMCredentialProvider *credentialProvider = [CLMCredentialProvider new];
        CLMRESTAPICoordinator *coordinator = [CLMRESTAPICoordinator coordinatorWithBaseURL:baseURL
                                                                       OAuth2TokenEndpoint:CLMOAuth2TokenEndpoint
                                                                                  clientID:CLMOAuth2ClientID
                                                                                    secret:CLMOAuth2Secret
                                                                        credentialProvider:credentialProvider];
        
        sharedInstance = [[self alloc] initWithCoordinator:coordinator credentialProvider:credentialProvider];
    });

    return sharedInstance;
}

#pragma mark - Initializer

- (instancetype)initWithCoordinator:(CLMRESTAPICoordinator *)coordinator credentialProvider:(CLMCredentialProvider *)credentialProvider {
    self = [super init];
    
    if (self) {
        _coordinator = coordinator;
        _credentialProvider = credentialProvider;
    }
    
    return self;
}

#pragma mark - Public

- (CLMArticleWebAPIClient *)articleWebAPIClient {
    CLMRESTAPIClient *RESTAPIClient = [self.coordinator RESTAPIClientWithEndpoint:CLMArticleEndpoint];
    return [[CLMArticleWebAPIClient alloc] initWithRESTAPIClient:RESTAPIClient];
}

@end
