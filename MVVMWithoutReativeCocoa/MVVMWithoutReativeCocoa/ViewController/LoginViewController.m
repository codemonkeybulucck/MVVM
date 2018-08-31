//
//  ViewController.m
//  MVVMWithoutReativeCocoa
//
//  Created by lemon on 2018/8/28.
//  Copyright © 2018年 Lemon. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"
#import "MBProgressHUD+LKZ.h"

@interface LoginViewController ()
@property (nonatomic, strong) LoginViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)logIn:(id)sender;
- (IBAction)safariLogIn:(id)sender;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUpUI];
    [self initData];
    [self addObserver];
}

- (void)setUpUI{
    self.avatarView.layer.cornerRadius = 40;
    self.avatarView.layer.masksToBounds = YES;
    self.title = @"登录";
}

- (void)initData{
    self.viewModel = [[LoginViewModel alloc]init];
}

- (void)addObserver{
    [self.usernameTf addTarget:self action:@selector(textFieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTf addTarget:self action:@selector(textFieldValueDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.viewModel addObserver:self forKeyPath:@"avatarUrlString" options:NSKeyValueObservingOptionNew context:nil];
    [self.viewModel addObserver:self forKeyPath:@"isLoginValid" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)textFieldValueDidChanged:(UITextField *)textField{
    if (textField == self.usernameTf) {
        self.viewModel.username = self.usernameTf.text;
    }else if(textField == self.passwordTf){
        self.viewModel.password = self.passwordTf.text;
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if(object == self.viewModel){
        if ([keyPath isEqualToString:@"avatarUrlString"]) {
            NSString *imageName = change[NSKeyValueChangeNewKey];
            UIImage *image = [UIImage imageNamed:imageName];
            self.avatarView.image = image?image:[UIImage imageNamed:@"placeholderAvatar"];
        }else if([keyPath isEqualToString:@"isLoginValid"]){
            BOOL isValid = [change[NSKeyValueChangeNewKey] boolValue];
            self.loginBtn.enabled = isValid;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)logIn:(id)sender {
    [MBProgressHUD showMessage:@"Login..."];
    [self.viewModel loginSuccess:^(NSDictionary *para) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"success!! website:%@",para[@"nickname"]]];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"error!!! \n reason:%@",error.userInfo]];
    }];
}

- (IBAction)safariLogIn:(id)sender {
    [self.viewModel safariLogin];
}


- (void)dealloc{
    [self.viewModel removeObserver:self forKeyPath:@"avatarUrlString"];
    [self.viewModel removeObserver:self forKeyPath:@"isLoginValid"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
