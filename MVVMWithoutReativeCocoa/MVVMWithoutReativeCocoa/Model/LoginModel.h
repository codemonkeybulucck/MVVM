//
//  LoginModel.h
//  MVVMWithoutReativeCocoa
//
//  Created by lemon on 2018/8/28.
//  Copyright © 2018年 Lemon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password;
@end
