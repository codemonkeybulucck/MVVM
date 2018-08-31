//
//  LMLoginViewController.m
//  MVVMWithReactiveCocoa
//
//  Created by lemon on 2018/8/31.
//  Copyright © 2018年 Lemon. All rights reserved.
//

#import "LMLoginViewController.h"
#import "LMLoginViewModel.h"
#import "MBProgressHUD+LKZ.h"
#import <RACSignal.h>

@interface LMLoginViewController ()
@property (nonatomic, strong) LMLoginViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *safariLoginBtn;
@end

@implementation LMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self listenSignal];
    
}

- (void)listenSignal{
    
    //self.usernameTf.rac_textSignal只会在用户输入的时候产生信号，还要利用RACObserve来监听Textfield的text的变化，当通过代码直接赋值的时候会捕捉到生产一个信号
    RAC(self.viewModel,username) = [RACSignal merge:@[self.usernameTf.rac_textSignal,RACObserve(self.usernameTf, text)]];
    
    RAC(self.viewModel,password) = [RACSignal merge:@[self.passwordTf.rac_textSignal,RACObserve(self.passwordTf, text)]];
    
    //绑定avatarUrlString 和 avatarView
    [RACObserve(self.viewModel, avatarUrlString) subscribeNext:^(NSString *avatarUrlString) {
        self.avatarView.image = [UIImage imageNamed:avatarUrlString];
    }];
    
    RAC(self.loginBtn,enabled) = self.viewModel.isLoginValidSignal;

    //这样写会报错，因为同一个对象不能绑定两个RACDynamicSignal，上面enabled已经绑定了一个一个信号，下面不能这样绑定一个新的。
    //self.loginBtn.rac_command = self.viewModel.loginCommand;
    
    //正确的方式：
    [[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(__kindof UIControl * _Nullable x) {
        [MBProgressHUD showMessage:@"Log In..."];
    }]subscribeNext:^(__kindof UIControl * _Nullable x) {
        //手动执行
        [self.viewModel.loginCommand execute:nil];
    }];
    
    //处理成功
    [self.viewModel.loginCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *para) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"success!! %@",para[@"nickName"]]];
    }];
    //处理失败情况
    [self.viewModel.loginCommand.errors subscribeNext:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"error!!! \n reason:%@",error.userInfo]];
    }];
    
    self.safariLoginBtn.rac_command = self.viewModel.safariLoginCommand;
    [self.viewModel.safariLoginCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *dict) {
        NSURL *url = dict[@"url"];
        if([[UIApplication sharedApplication] canOpenURL:url]){
            [[UIApplication sharedApplication] openURL:url options:nil completionHandler:nil];
        }
    }];
}

- (LMLoginViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[LMLoginViewModel alloc]init];
    }
    return _viewModel;
}

@end
