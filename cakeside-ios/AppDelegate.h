//
//  AppDelegate.h
//  cakeside-ios
//
//  Created by mo khan on 2013-07-14.
//  Copyright (c) 2013 mo khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LoginViewController *viewController;
@property (strong, nonatomic) UINavigationController * navigationController;
@end
