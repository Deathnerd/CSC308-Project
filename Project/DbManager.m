//
//  DbManager.m
//  Example16
//
//  Created by student on 11/18/14.
//  Copyright (c) 2014 cs@eku.edu. All rights reserved.
//

#import "DbManager.h"
@interface DbManager()
@property NSString *documentsDirectory;  // path to the Documents directory
@property NSString *databaseFilename;   // name of the database

@property NSMutableArray *arrResults;   // query result from the database

- (void) copyDatabaseIntoDocumentsDirectory;
@end

@implementation DbManager

/*
 * Initialize the database by copying the database file from the app's
 * bundle into the app's Documents directory
 */
- (instancetype) initWithDatabaseFilename:(NSString *)dbFilename {
    self = [super init];
    
    if(self){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex: 0];
        NSLog(@"Copying into documents directory: %@", dbFilename);
        
        self.databaseFilename = dbFilename;
        
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
    
}

- (void) copyDatabaseIntoDocumentsDirectory {
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    // copy the file if it does not already exist in the directory
    if(![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]){
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        if(error != nil){
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

/*
 * Run a database query
 * queryExecutable: NO  -- update/insert/delete statement
 *                  YES __ select select
 * Borrowed from http://www.appcoda.com/sqlite-database-ios-app-tutorial
 */
-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable
{
    
    // ------------------------------------------------------
    // Initialize the results array.
    if (self.arrResults != nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = [[NSMutableArray alloc] init];
    
    // Initialize the column names array.
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    // ------------------------------------------------------
    
    // Create a sqlite object: database handler
    sqlite3 *sqlite3Database;
    
    // Set the database file path.
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    // Open the database.
    int openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK) {
        // Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
        sqlite3_stmt *compiledStatement;
        
        // Load all data from database to memory.
        int prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK) {
            // Check if the query is non-executable.
            if (!queryExecutable){
                // It is a select query so data must be loaded from the database.
                
                // Declare an array to keep the data for each fetched row.
                NSMutableArray *arrDataRow = [[NSMutableArray alloc] init];;
                
                // Loop through the results and add them to the results array row by row.
                // [SQLITE_ROW] is returned each time a new row of data is ready for processing by the caller.
                while(sqlite3_step(compiledStatement) == SQLITE_ROW)
                {
                    // Get the total number of columns in the result table.
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    // Go through all columns and fetch each column data.
                    for (int i=0; i<totalColumns; i++){
                        // Convert the column data to text (characters).
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        // If there are contents in the currenct column (field) then add them to the current row array.
                        if (dbDataAsChars != NULL) {
                            // Convert the characters to string.
                            [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        // Keep the current column name.
                        if (self.arrColumnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    // Store each fetched data row in the results array, but first check if there is actually data.
                    if (arrDataRow.count > 0) {
                        [self.arrResults addObject:arrDataRow];
                        
                        // arrDataRow = nil;
                        arrDataRow = [[NSMutableArray alloc] init];;
                    }
                }
            }
            else {
                // This is the case of an executable query (insert, update, ...).
                
                // Execute the query.
                int executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults == SQLITE_DONE) {
                    // Keep the affected rows.
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    
                    // Keep the last inserted row ID.
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                }
                else {
                    // If could not execute the query show the error message on the debugger.
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        }
        else {
            // In the database cannot be opened then show the error message on the debugger.
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }
        
        // Release the compiled statement from memory.
        sqlite3_finalize(compiledStatement);
        
    }
    
    // Close the database.
    sqlite3_close(sqlite3Database);
}

/*
 * Execute SELECT statement
 */
- (NSArray *) loadDataFromDB:(NSString *)query {
    [self runQuery: [query UTF8String] isQueryExecutable:NO];
    
    return (NSArray *) self.arrResults;
}

/*
 * Execute INSERT/DELETE/UPDATE statements
 */
- (void) executableQuery:(NSString *)query{
    [self runQuery: [query UTF8String] isQueryExecutable:YES];
}
@end
