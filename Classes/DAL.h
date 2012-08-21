//
//  DAL.h
//  DatabaseExp
//
//  Created by Gaurang Makwana on 28/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DAL : NSObject 
{
	sqlite3 *database;
	BOOL dbAccessError;
	NSString *dbPath;
}

- (id)initDatabase:(NSString *)dbName;
- (NSMutableDictionary *)executeDataSet:(NSString *)strQuery;
- (int) execureScalar:(NSString *)strQuery;
- (NSMutableArray *)executeArraySet: (NSString *) strQuery;
- (BOOL)insertBookmark:(NSString*)strQuery;
- (void)deleteBookmark:(NSInteger )bookmarkID;

@end
