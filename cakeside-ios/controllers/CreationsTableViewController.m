//
//  CreationsTableViewController.m
//  cakeside-ios
//
//  Created by mo khan on 2013-07-14.
//  Copyright (c) 2013 mo khan. All rights reserved.
//

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
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  // start loading data...
  [self updateData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//  Authorization: Token token=
  [httpClient setParameterEncoding:AFJSONParameterEncoding];
  
  NSMutableURLRequest *request;
  request = [httpClient requestWithMethod:@"GET" path:URL_CAKES parameters:nil];
  
  NSLog(@"GET: %@", request);
  
  AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                       JSONRequestOperationWithRequest:request
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                       {
                                         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                         //NSLog(@"%@", JSON);
                                         
                                         if (!self.data)
                                         {
                                           self.data = [[NSMutableArray alloc] init];
                                         }
                                         
                                         for (NSDictionary *data in JSON)
                                         {
                                           Cake *cake = [Cake initFromJSON:data];
                                           [self.data addObject:cake];
                                         }
                                         
//                                         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATED_STATS_DATA object:nil];
                                       }
                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                       {
                                         NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
                                         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATED_STATS_DATA object:nil];
                                         
                                         BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Error" message:@"Failed to retrieve reading data. Please try again later."];
                                         [alert setCancelButtonWithTitle:@"Ok" block:nil];
                                         [alert show];
                                       }];
  [operation start];
  
  
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
