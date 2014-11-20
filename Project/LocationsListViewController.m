//
//  LocationsListViewController.m
//  Project
//
//  Created by student on 11/18/14.
//  Copyright (c) 2014 cs@eku.edu. All rights reserved.
//

#import "LocationsListViewController.h"

@interface LocationsListViewController ()
@property NSArray *content;
@property NSString *currentlySelectedName;
@property NSDictionary *dataToSend;
@end

@implementation LocationsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Some dummy data. We'll need to populate it with database results when we know how to
    // TODO: have this load from the database
    // - Wes
    
//    self.content = @[
//  
//                     @{@"mainTitleKey": @"Foo",
//                      @"secondaryTitleKey": @"Bar"},
//                     
//                     @{@"mainTitleKey": @"Donkey Kong Country 2",
//                       @"secondaryTitleKey": @"It's a good game!"},
//                     
//                     @{@"mainTitleKey": @"Coffee",
//                       @"secondaryTitleKey": @"Beans"}
//                     
//                     ];
    
    self.content = @[@{@"id": @1,
                       @"name": @"Foo",
                       @"latitude": @-37.7563,
                       @"longitude": @20.227,
                       @"description": @"Bar"},
                     
                     @{@"id": @2,
                       @"name": @"Donkey Kong 64",
                       @"latitude": @100.7563,
                       @"longitude": @1.227,
                       @"description": @"is a flawed game but I still like it"},
                     
                     @{@"id": @3,
                       @"name": @"Ice cream",
                       @"latitude": @-20,
                       @"longitude": @55.227,
                       @"description": @"I need to stop eating it"}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * This really shouldn't be a required mehod, but it is. It tells iOS how many sections we want in each table cell.
 * It shouldn't be needed for majority of cases as you'll only really need one, so it should default to it, but Apple.
 * - Wes
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.content.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/*
 * Take care of things like passing data to the next view. We really should only need the building name because we 
 * can then just do a query to search for the other data from the database. A simple CRUD operation like that 
 * shouldn't be too costly
 * - Wes
 */
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // I don't remember specifically how to do the passing of data
    // - Wes
    //TODO: Send the dictionary entry to the next view
}

/*
 * Populates a cell with data. Uses the self.content dictionary to do so.
 * I copied this from somewhere, but I can't remember. Probably AppCoda
 * - Wes
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" ];
    
    NSDictionary *data = [self.content objectAtIndex:indexPath.row];
    cell.textLabel.text = [data objectForKey:@"name"];
    cell.detailTextLabel.text = [data objectForKey:@"description"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary *data = [];
//    self.currentlySelectedName =
    self.dataToSend = [self.content objectAtIndex:indexPath.row];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
