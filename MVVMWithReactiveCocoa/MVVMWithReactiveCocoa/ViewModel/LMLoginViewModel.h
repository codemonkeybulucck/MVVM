//
//  LMLoginViewModel.h
//  MVVMWithReactiveCocoa
//
//  Created by lemon on 2018/8/31.
//  Copyright © 2018年 Lemon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>

@interface LMLoginViewModel : NSObject
@property (nonatomic, copy, readwrite) NSString *username;
@property (nonatomic, copy, readwrite) NSString *password;
@property (nonatomic, copy, readonly) NSString *avatarUrlString;
@property (nonatomic, strong, readonly) RACSignal *isLoginValidSignal;
@property (nonatomic, strong) RACCommand *loginCommand;
@property (nonatomic, strong)  RACCommand *safariLoginCommand;
@end
