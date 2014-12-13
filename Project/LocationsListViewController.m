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
@property NSDictionary *dataToSend;
@property DbManager *dbManager;
@property NSArray *resultsContent;
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
    // Instantiate the database
    self.dbManager = [[DbManager alloc] initWithDatabaseFilename:@"Db.sqlite"];
    // Do any additional setup after loading the view.
    
    /*
     * Load the data from the database to populate the table
     */
    [self loadData];
}

/*
 * When the view appears, we need to reload the data and refresh the table
 */
- (void)viewDidAppear:(BOOL)animated {
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
 * This really shouldn't be a required mehod, but it is. It tells iOS how many sections we want in each table cell.
 * It shouldn't be needed for majority of cases as you'll only really need one, so it should default to it, but Apple.
 * - Wes
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultsContent.count;
}

/*
 * We only need one section
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/*
 * This takes care of passing the data from this view controller to the Building Info View Controller.
 * It also sets the title of the nav bar in the next view to the selected building's name
 */
- (void) passData{
    BuildingInfoViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BuildingInfoVC"];
    viewController.name = self.selectedName;  // Pass the name to the next view
    viewController.navigationItem.title = self.selectedName;  // Set the nav bar title to the selected building name
    [self.navigationController pushViewController:viewController animated:YES];  // Do the segue
}

/*
 * Populates a cell with data. Uses the self.content dictionary to do so.
 * I copied this from somewhere, but I can't remember. Probably AppCoda
 * - Wes
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Dequeue the cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    NSInteger indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"name"];  // Get the index of the name in the database results
    
    // Set the loaded data to the appropriate cell labels.
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.resultsContent objectAtIndex:indexPath.row] objectAtIndex:indexOfName]];
    
    return cell;
}

/*
 * When we select a table cell, pass the data to the Building Info View Controller
 * so that it can set up the data it needs to display the map
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Keep track of the building name we've selected
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectedName = cell.textLabel.text;
    [self passData];
    
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

/*
 * Load the data from the database to use to populate the table
 */
-(void)loadData{
    // Form the query.
    NSString *query = @"SELECT * FROM locations;";
    
    // Get the results.
    if (self.resultsContent != nil) {
        self.resultsContent = nil;
    }
    self.resultsContent = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.locationsTable reloadData];
}

@end