//
//  AppDelegate.h
//  MVVMWithoutReativeCocoa
//
//  Created by lemon on 2018/8/28.
//  Copyright © 2018年 Lemon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) LoginModel *loginUser;
+ (instancetype)sharedAPPDelegate;
@end

