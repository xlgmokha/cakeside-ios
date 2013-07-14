//
//  ViewController.m
//  cakeside-ios
//
//  Created by mo khan on 2013-07-14.
//  Copyright (c) 2013 mo khan. All rights reserved.
//

#import "LoginViewController.h"
#import "SSKeychain.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  UIView *emailPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
  self.emailTextBox.leftView = emailPaddingView;
  self.emailTextBox.leftViewMode = UITextFieldViewModeAlways;
  
  UIView *passwordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
  self.passwordTextBox.leftView = passwordPaddingView;
  self.passwordTextBox.leftViewMode = UITextFieldViewModeAlways;
  
//  self.contentView.$y = 0;
  
  // prepopulate username/password with stored information

  NSError *error;
  NSString *username = [SSKeychain passwordForService:KEYCHAIN_USER_NAME account:KEYCHAIN_ACCOUNT error:&error];
  if (error) { username = nil; }
  NSString *password = [SSKeychain passwordForService:KEYCHAIN_USER_PASSWORD account:KEYCHAIN_ACCOUNT error:&error];
  if (error) { password = nil; }
  
  if (username)
  {
    self.emailTextBox.text = username;
  }
  if (password)
  {
    self.passwordTextBox.text = password;
  }

  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
