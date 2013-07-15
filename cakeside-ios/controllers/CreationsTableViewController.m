#import "CreationsTableViewController.h"
#import "Cake.h"

@interface CreationsTableViewController ()
@property (strong, nonatomic) NSMutableArray *data;
@end

@implementation CreationsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.navigationItem setHidesBackButton:YES];
  self.title = @"CakeSide";

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedDataNotification) name:NOTIFICATION_CAKES_UPDATED object:nil];
  // start loading data
  [self updateData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updatedDataNotification
{
  [self.tableView reloadData];
}

- (void)updateData
{
  self.data = nil;
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

  NSError *error;
  NSString *token = [SSKeychain passwordForService:KEYCHAIN_API_TOKEN account:KEYCHAIN_ACCOUNT error:&error];

  // load data
  AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:HOST]];
  [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
  [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
  [httpClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Token token=%@", token]];
  [httpClient setParameterEncoding:AFJSONParameterEncoding];

  NSMutableURLRequest *request;
  request = [httpClient requestWithMethod:@"GET" path:URL_CAKES parameters:nil];

  NSLog(@"GET: %@", request);

  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
   if (!self.data)
   {
     self.data = [[NSMutableArray alloc] init];
   }
   for (NSDictionary *data in JSON)
   {
     Cake *cake = [Cake initFromJSON:data];
     [self.data addObject:cake];
   }
   [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CAKES_UPDATED object:nil];
  }
  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
   NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
   [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CAKES_UPDATED object:nil];

   BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Oops..." message:@"Something is broken in the kitchen. Please try again later."];
   [alert setCancelButtonWithTitle:@"Got it" block:nil];
   [alert show];
  }];
  [operation start];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (!self.data || self.data.count == 0)
  {
    return 0;
  }
  else
  {
    return self.data.count;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CakeCell"];
  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CakeCell"];
  }

  Cake *cake = [self.data objectAtIndex:indexPath.row];
  [cell.imageView setImageWithURL:[NSURL URLWithString:cake.photo] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
  cell.textLabel.text = cake.name;
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
