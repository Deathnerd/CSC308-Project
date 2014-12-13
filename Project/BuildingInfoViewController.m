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
@property NSArray *resultsContent;
@property DbManager *dbManager;
@property NSNumber *longitude;
@property NSNumber *latitude;
@property NSString *buildingName;
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
    // Instantiate the database object
    self.dbManager = [[DbManager alloc] initWithDatabaseFilename:@"Db.sqlite"];
    // Do any additional setup after loading the view.
}

/*
 * This method is what we should use to do things when the view is shown (duh). 
 * This'll take care of almost all of our actions such as setting the map coordinates and laying down a pin, etc.
 * Also remember to set the header text to the name of the location
 * - Wes
 */
- (void)viewDidAppear:(BOOL)animated{
    self.navigationItem.title = self.name;  // Set the header name
    [self loadSelectedData: self.name];
    

    CLLocationCoordinate2D location;

    location.latitude = [self.latitude doubleValue];
    location.longitude = [self.longitude doubleValue];
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    // Make an address object given a latitude and longitude
    // For use with placing a pin. Pretty stupid if you ask me
    CLGeocoder *g = [CLGeocoder new];
    [g reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark * myPlacemark = placemarks [0];
        
        MKCoordinateRegion mapRegion;
        mapRegion.center.latitude = myPlacemark.location.coordinate.latitude;
        mapRegion.center.longitude = myPlacemark.location.coordinate.longitude;
        mapRegion.span.longitudeDelta = 0.008;
        mapRegion.span.latitudeDelta = 0.008;
        [self.mapView setRegion:mapRegion animated:YES];    // redraw the map

        MKPlacemark *p = [[MKPlacemark alloc] initWithPlacemark:myPlacemark];
        [self.mapView addAnnotation:p];
    }];
    
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
    /*
     * Couldn't get the proper way working (using CLLocation2dCoordinates and junk), so I hacked together
     * a little trick: iOS and Android intercept specific urls to interact with apps. One of them is 
     * map links. Android will open Google Maps urls in Google Maps and iOS will do the same for Apple Maps
     * and Apple Maps urls. A dirty hack, but eh it works.
     */
    NSString *link = [NSString stringWithFormat: @"http://maps.apple.com/maps?q=%@,%@", self.latitude, self.longitude];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}

/*
 * Loads data about the building based on the name and stores it in the self.currentData directory
 */
-(void) loadSelectedData:(NSString *)name{
    // Form the query.
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT latitude, longitude FROM locations WHERE name='%@';", name];
    // Get the results.
    if (self.resultsContent != nil) {
        self.resultsContent = nil;
    }
    
    self.resultsContent = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    self.longitude = [[NSNumber alloc] initWithDouble:[[[self.resultsContent objectAtIndex:0] objectAtIndex:1] doubleValue]];
    self.latitude = [[NSNumber alloc] initWithDouble:[[[self.resultsContent objectAtIndex:0] objectAtIndex:0] doubleValue]];
}

@end
