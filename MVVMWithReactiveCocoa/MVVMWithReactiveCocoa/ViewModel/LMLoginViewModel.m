//
//  LMLoginViewModel.m
//  MVVMWithReactiveCocoa
//
//  Created by lemon on 2018/8/31.
//  Copyright © 2018年 Lemon. All rights reserved.
//

#import "LMLoginViewModel.h"
#import "AppDelegate.h"
#import "LoginModel.h"

@interface LMLoginViewModel()
@property (nonatomic, copy) NSString *avatarUrlString;
@property (nonatomic, strong) RACSignal *isLoginValidSignal;
@end

@implementation LMLoginViewModel

- (instancetype)init{
    if (self = [super init]) {
        [self registerRACSignal];
    }
    return self;
}

- (void)registerRACSignal{
    //监听绑定
    RAC(self,avatarUrlString) = [[RACObserve(self, username) map:^NSString *(NSString *username) {
        return  [UIImage imageNamed:username]?username:@"placeholderAvatar";
    }]distinctUntilChanged];
    
    self.isLoginValidSignal = [[RACSignal combineLatest:@[RACObserve(self,username),RACObserve(self, password)] reduce:^(NSString *username,NSString *password){
        return  @(username.length >0 && password.length);
    }]distinctUntilChanged];
    
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        //这里可以对账号或者密码长度做简单的本地校验
        /*
        if (self.password.length < 8) {
            return  [RACSignal error:[NSError errorWithDomain:@"www.lemon2well.top" code:@(100000) userInfo:@{@"errorDesc":@"密码错误"}]];
        }
        */
        //执行异步登录
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            //模拟网络请求
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([self.username isEqualToString:@"lemon"] && [self.password isEqualToString:@"well"]) {
                    //保存账号信息到本地，这里只是示例，建议账号信息加密保存到keychain
                    [[NSUserDefaults standardUserDefaults] setValue:self.username forKey:@"username"];
                    [[NSUserDefaults standardUserDefaults] setValue:self.password forKey:@"password"];
                    //保存到缓存
                    [AppDelegate shareAPPDelegate].loginUser = [[LoginModel alloc] initWithUsername:self.username password:self.password];
                    NSDictionary *para = @{@"nickName":@"lemon",@"website":@"http://www.lemon2well.top"};
                    [subscriber sendNext:para];
                    [subscriber sendCompleted];
                }else{
                    //失败回调
                    NSError *error = [NSError errorWithDomain:@"lmeon2well.top" code:100000 userInfo:@{@"error":@"username or password error"}];
                    [subscriber sendError:error];
                }
            });
            return  nil;
        }];
    }];
    
    self.safariLoginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSURL *url = [NSURL URLWithString:@"http://www.lemon2well.top"];
            [subscriber sendNext:@{@"url":url}];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    
}

@end
