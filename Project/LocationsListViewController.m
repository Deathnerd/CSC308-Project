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
    // - Wes
    self.content = @[@{@"mainTitleKey": @"Foo",
                      @"secondaryTitleKey": @"Bar"}];
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
}

/*
 * Populates a cell with data. Uses the self.content dictionary to do so.
 * I copied this from somewhere, but I can't remember. Probably AppCoda
 * - Wes
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *item = (NSDictionary *)[self.content objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"mainTitleKey"];
    cell.detailTextLabel.text = [item objectForKey:@"secondaryTitleKey"];
    
    return cell;
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
