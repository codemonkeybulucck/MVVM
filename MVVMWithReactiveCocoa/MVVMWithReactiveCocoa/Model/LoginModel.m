//
//  LoginModel.m
//  MVVMWithoutReativeCocoa
//
//  Created by lemon on 2018/8/28.
//  Copyright © 2018年 Lemon. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel
- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password{
    if (self = [super init]) {
        _userName = username;
        _password = password;
    }
    return self;
}

@end
