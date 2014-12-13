//
//  DbManager.h
//  Example16
//
//  Created by student on 11/18/14.
//  Copyright (c) 2014 cs@eku.edu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DbManager : NSObject
@property NSMutableArray *arrColumnNames;
@property int affectedRows;     // number of rows affected by a query statement
@property long long lastInsertedRowID;

- (instancetype) initWithDatabaseFilename: (NSString *) dbFilename;

- (NSArray *) loadDataFromDB: (NSString *) query;
- (void) executableQuery: (NSString *) query;
@end
