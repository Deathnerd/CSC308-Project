//
//  BuildingInfoViewController.m
//  Project
//
//  Created by student on 11/19/14.
//  Copyright (c) 2014 cs@eku.edu. All rights reserved.
//

#import "BuildingInfoViewController.h"

@interface BuildingInfoViewController ()
// Store the lat/long in here for the location of the currently selected building
// - Wes
@property NSDictionary *currentData;
@property NSArray *resultsContent;
@property DbManager *dbManager;

@end

@implementation BuildingInfoViewController

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
    
//    self.currentData = @{
//                         @"longitude": @-111.5955,
//                         @"latitude": @33.225488,
//                         @"name": @"Denny's"
//                         };
}

/*
 * This method is what we should use to do things when the view is shown (duh). 
 * This'll take care of almost all of our actions such as setting the map coordinates and laying down a pin, etc.
 * Also remember to set the header text to the name of the location
 * See more here: http://www.raywenderlich.com/21365/introduction-to-mapkit-in-ios-6-tutorial
 * - Wes
 */
- (void)viewDidAppear:(BOOL)animated{
//    [self loadSelectedData:self.name];
    NSLog(@"I appeared!");
//    NSLog(@"Selected parent view name: %@", ((LocationsListViewController *) self.parentViewController).selectedName);
//    [self loadSelectedData:((LocationsListViewController *) self.parentViewController).selectedName];
//    if(self.name == NULL || self.name == nil){
//        self.name = ((LocationsListViewController *) self.parentViewController).selectedName;
//    }
    NSLog(@"Name! : %@", self.name);
    [self loadSelectedData: self.name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
 * Should be pretty self-explanatory. Handle the logic to open the current location in the Maps app. 
 * I'd love to use Google Maps, but we'll have to deal with our user being led out into the woods in Maine.
 * - Wes
 */
- (IBAction)openInMapsButton:(id)sender {
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(
                                                                 [[self.currentData objectForKey:@"longitude"] doubleValue],
                                                                 [[self.currentData objectForKey:@"latitude"] doubleValue]
                                                                 );
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:location addressDictionary:nil];
    MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
    item.name = [self.currentData objectForKey:@"name"];
    [item openInMapsWithLaunchOptions:nil];
    
}

-(void) loadSelectedData:(NSString *)name{
    
    // Form the query.
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT latitude, longitude FROM locations WHERE name = %@;", name];
    NSLog(@"%@", query);
    // Get the results.
    if (self.resultsContent != nil) {
        self.resultsContent = nil;
    }
    
    self.resultsContent = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"%@", self.resultsContent);
    // Set the loaded data to the appropriate cell labels.
//    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.resultsContent objectAtIndex:indexPath.row] objectAtIndex:indexOfName]];
//    
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"Latitude:%@ Longitude:%@", [[self.resultsContent objectAtIndex:indexPath.row] objectAtIndex:indexOfLatitude], [[self.resultsContent objectAtIndex:indexPath.row] objectAtIndex:indexOfLongitude]];
    NSNumber *longitude = [[NSNumber alloc] initWithDouble:[[[self.resultsContent objectAtIndex:0] objectAtIndex:1] doubleValue]];
    NSLog(@"%@", longitude);
    NSNumber *latitude = [[NSNumber alloc] initWithDouble:[[[self.resultsContent objectAtIndex:0] objectAtIndex:0] doubleValue]];
    NSLog(@"%@", latitude);
    self.currentData = @{
                         @"longitude": longitude,
                         @"latitude": latitude,
                         @"name": name
                         };
    
}

@end
