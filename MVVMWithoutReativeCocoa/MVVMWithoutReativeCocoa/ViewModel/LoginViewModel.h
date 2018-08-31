//
//  LoginViewModel.h
//  MVVMWithoutReativeCocoa
//
//  Created by lemon on 2018/8/28.
//  Copyright © 2018年 Lemon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject
@property (nonatomic, copy, readwrite) NSString *username;
@property (nonatomic, copy, readwrite) NSString *password;
@property (nonatomic, copy, readonly) NSString *avatarUrlString;
@property (nonatomic, assign, readonly) BOOL isLoginValid;
- (void)loginSuccess:(void(^)(NSDictionary *para))success failure:(void(^)(NSError *error))failure;
- (void)safariLogin;
@end
