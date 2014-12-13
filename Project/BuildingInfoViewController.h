//
//  BuildingInfoViewController.h
//  Project
//
//  Created by student on 11/19/14.
//  Copyright (c) 2014 cs@eku.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DbManager.h"
#import "LocationsListViewController.h"

@interface BuildingInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)openInMapsButton:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleBar;
@property NSString *name;

@end
