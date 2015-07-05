//
//  CLMCredentialProvider.h
//  CLMNetworking
//
//  Created by hirai.yuki on 2015/02/13.
//  Copyright (c) 2015年 hirai.yuki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CLMNetworking/CLMRESTAPICoordinator.h>

@interface CLMCredentialProvider : NSObject <CLMOAuth2CredentialProvider>

@property (nonatomic) AFOAuthCredential *OAuth2Credential;

@end
