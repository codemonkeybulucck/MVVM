//
//  LoginViewModel.m
//  MVVMWithoutReativeCocoa
//
//  Created by lemon on 2018/8/28.
//  Copyright © 2018年 Lemon. All rights reserved.
//

#import "LoginViewModel.h"
#import "LoginModel.h"
#import <UIKit/UIKit.h>

@interface LoginViewModel()
@property (nonatomic, strong) LoginModel *model;
@property (nonatomic, copy, readwrite) NSString *avatarUrlString;
@property (nonatomic, assign, readwrite) BOOL isLoginValid;
@property (nonatomic, assign) BOOL hasUserName;
@property (nonatomic, assign) BOOL hasPassword;
@end

@implementation LoginViewModel

- (instancetype)init{
    if (self = [super init]) {
        [self addObserver:self forKeyPath:@"username" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
         [self addObserver:self forKeyPath:@"password" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        self.model = [[LoginModel alloc]init];
    }
    return self;
}

//通过监听username和password来改变model和avatarUrlString，isValid的值。
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"username"]) {
        //设置用户名对应的图片
        NSString *userName = change[NSKeyValueChangeNewKey];
        if (userName!= nil && ![userName isEqualToString:@""]) {
            self.hasUserName = YES;
        }else{
            self.hasUserName = NO;
        }
        self.avatarUrlString = userName;
        self.model.userName = userName;
    }
    if ([keyPath isEqualToString:@"password"]) {
        NSString *password = change[NSKeyValueChangeNewKey];
        if (password!= nil && ![password isEqualToString:@""]) {
            self.hasPassword = YES;
        }else{
            self.hasPassword = NO;
        }
        self.model.password = password;
    }
    self.isLoginValid = self.hasUserName && self.hasPassword;
    NSLog(@"model isLoginValid = %d",self.isLoginValid);
}

- (void)loginSuccess:(void(^)(NSDictionary *para))success failure:(void(^)(NSError *error))failure{
    //模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.username isEqualToString:@"lemon"] && [self.password isEqualToString:@"well"]) {
            //保存账号信息到本地，这里只是示例，建议账号信息加密保存到keychain
            [[NSUserDefaults standardUserDefaults] setValue:self.username forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setValue:self.password forKey:@"password"];
            NSDictionary *para = @{@"nickName":@"lemon",@"website":@"http://www.lemon2well.top"};
            if (success) {
                success(para);
            }
        }else{
            //失败回调
            NSError *error = [NSError errorWithDomain:@"lmeon2well.top" code:100000 userInfo:@{@"error":@"username or password error"}];
            if (failure) {
                failure(error);
            }
        }
       
    });
}

- (void)safariLogin{
    NSURL *loginUrl = [NSURL URLWithString:@"http://www.lemon2well.top"];
    [[UIApplication sharedApplication] openURL:loginUrl options:nil completionHandler:nil];
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"username"];
    [self removeObserver:self forKeyPath:@"password"];
}
@end
