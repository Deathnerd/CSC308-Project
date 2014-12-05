//
//  LocationsListViewController.h
//  Project
//
//  Created by student on 11/18/14.
//  Copyright (c) 2014 cs@eku.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DbManager.h"
#import "BuildingInfoViewController.h"

@interface LocationsListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *locationsTable;
@property NSString *selectedName;

@end
