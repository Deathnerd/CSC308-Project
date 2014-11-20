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
    
    self.currentData = @{
                         @"longitude": @-111.5955,
                         @"latitude": @33.225488,
                         @"name": @"Denny's"
                         };
}

/*
 * This method is what we should use to do things when the view is shown (duh). 
 * This'll take care of almost all of our actions such as setting the map coordinates and laying down a pin, etc.
 * Also remember to set the header text to the name of the location
 * See more here: http://www.raywenderlich.com/21365/introduction-to-mapkit-in-ios-6-tutorial
 * - Wes
 */
- (void)viewDidAppear:(BOOL)animated{
    
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
@end
