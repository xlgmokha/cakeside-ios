#import "LoginViewController.h"
#import "CreationsTableViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) MBProgressHUD *HUD;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

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

- (MBProgressHUD *)HUD
{
  if (!_HUD) {
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
  }
  return _HUD;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  // user did hit the Return/Done button on the keyboard
  if (textField == self.emailTextBox)
  {
    // goto password field
    [self.passwordTextBox becomeFirstResponder];
  }
  else
    if (textField == self.passwordTextBox)
    {
      [self login:self.passwordTextBox];
    }
  return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  [textField resignFirstResponder];
}

- (void)dismissKeyboard
{
  [self.view endEditing:YES];
}

#pragma mark - Action methods

- (IBAction)backgroundTapped:(id)sender
{
  [self dismissKeyboard];
}

- (IBAction)login:(id)sender
{
  [self dismissKeyboard];
  self.HUD.mode = MBProgressHUDModeIndeterminate;
  self.HUD.labelText = nil;
  self.HUD.customView = nil;
  [self.HUD show:YES];

  // try to login
  NSDictionary *params = @{@"email": self.emailTextBox.text, @"password": self.passwordTextBox.text};
  AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HOST]];
  [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
  [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
  [httpClient.operationQueue setMaxConcurrentOperationCount:1];
  [httpClient setParameterEncoding:AFJSONParameterEncoding];
  NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:URL_LOGIN parameters:params];

  NSLog(@"POST: %@", request);
  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
     NSLog(@"%@", JSON);
     // check if login was successfull
     NSString *token = [JSON objectForKey:@"auth_token"];
     if (!token || [token isEmpty])
     {
       [self.HUD hide:YES];
       [TSMessage showNotificationInViewController:self withTitle:@"Login failed!" withMessage:@"Please verify your login credentials and try again." withType:TSMessageNotificationTypeError withDuration:OVERLAY_MESSAGE_DURATION];
     }
     else
     {
       // successfull login!
       [SSKeychain setPassword:token forService:KEYCHAIN_API_TOKEN account:KEYCHAIN_ACCOUNT];
       [SSKeychain setPassword:self.emailTextBox.text forService:KEYCHAIN_USER_NAME account:KEYCHAIN_ACCOUNT];
       [SSKeychain setPassword:self.passwordTextBox.text forService:KEYCHAIN_USER_PASSWORD account:KEYCHAIN_ACCOUNT];
       CreationsTableViewController *controller = [[CreationsTableViewController alloc] initWithNibName:@"CreationsTableViewController" bundle:nil];
       [self.navigationController pushViewController:controller animated:YES];

     }
   }
   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
   {
     [self.HUD hide:YES];
     NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
     BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Something's not working." message:@"Login/Signup currently not possible. Please try again."];
     [alert setCancelButtonWithTitle:@"Ok" block:nil];
     [alert show];
   }];
  [operation start];
}

@end
