//
//  DAL.m
//  DatabaseExp
//
//  Created by Gaurang Makwana on 28/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DAL.h"
#import "NSString+Extensions.h"

@implementation DAL

- (id)initDatabase:(NSString *)dbName
{
	if(self = [super init])
	{
		dbPath = [dbName pathInDocumentDirectory];
		if(sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK)
		{
			dbAccessError = YES;
		}
	}
	return self;	
}

- (id) init
{
	if(self = [super init])
	{
		dbPath = [@"DigitalPlate.sqlite" pathInDocumentDirectory];
		if(sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK)
		{
			dbAccessError = YES;
		}
	}
	return self;
}


//insert data in database and return boolean value
-(BOOL)insertBookmark:(NSString*)strQuery
{
	BOOL success=FALSE;
	const char *query = [strQuery UTF8String];
	
	sqlite3_stmt *compiledStatement = nil;
	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
	{
		int rInt=sqlite3_prepare_v2(database, query, -1, &compiledStatement,NULL);
		if(rInt != SQLITE_OK){
			return success;
		}
		
		if (SQLITE_DONE != sqlite3_step(compiledStatement)){
			sqlite3_close(database);
			return success;
		}
		success = TRUE;
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);
	}
	return success;
}

//delete bookmark record and pass bookmark_id
-(void)deleteBookmark:(NSInteger )bookmarkID
{	
	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
	{
		NSString *query = [NSString stringWithFormat:@"DELETE FROM Bookmark WHERE bookmarkID = %d",bookmarkID];
		const char *sqlStatement = [query UTF8String];
		sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			NSLog(@"deleted from First table ");
		}
		if (SQLITE_DONE != sqlite3_step(compiledStatement)) {
			NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
			sqlite3_reset(compiledStatement);
		}	
		sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
}


- (NSMutableDictionary *)executeDataSet:(NSString *)strQuery
{
	NSMutableDictionary *dctResult = [[NSMutableDictionary alloc]initWithCapacity:0];
	
	const char *sql = [strQuery UTF8String];
	sqlite3_stmt *selectStatement;

	//prepare the select statement
	int returnValue = sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL);
	if(returnValue == SQLITE_OK)
	{
		sqlite3_bind_text(selectStatement, 1, sql, -1, SQLITE_TRANSIENT);
		
		//loop all the rows returned by the query.
		NSMutableArray *arrColumns = [[NSMutableArray alloc]initWithCapacity:0];
		for(int i =0; i < sqlite3_column_count(selectStatement); i++)
		{
			const char *st = sqlite3_column_name(selectStatement, i);
			[arrColumns addObject:[NSString stringWithCString:st encoding:NSUTF8StringEncoding]]; 
		}
		int intRow = 1;
		while(sqlite3_step(selectStatement) == SQLITE_ROW)
		{
			NSMutableDictionary *dctRow = [[NSMutableDictionary alloc]initWithCapacity:0];
			for(int i = 0; i < sqlite3_column_count(selectStatement); i++)
			{
				int intValue = 0;
				double dblValue = 0;
				const char *strValue;
				switch (sqlite3_column_type(selectStatement, i)) 
				{
					case SQLITE_INTEGER:
						intValue = (int)sqlite3_column_int(selectStatement, i);
						[dctRow setObject:[NSString stringWithFormat:@"%d", intValue] forKey:[arrColumns objectAtIndex:i]];
						break;

					case SQLITE_FLOAT:
						dblValue = (double)sqlite3_column_double(selectStatement, i);
						[dctRow setObject:[NSString stringWithFormat:@"%f", dblValue] forKey:[arrColumns objectAtIndex:i]];
						break;
						
					case SQLITE_TEXT:
						strValue = (const char *)sqlite3_column_text(selectStatement, i);
						[dctRow setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumns objectAtIndex:i]];
						break;
					
					case SQLITE_BLOB:
						strValue = (const char *)sqlite3_column_value(selectStatement, i);
						[dctRow setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumns objectAtIndex:i]];
						break;
						
					case SQLITE_NULL:
						[dctRow setObject:@"" forKey:[arrColumns objectAtIndex:i]];
						break;
					default:
						strValue = (const char *)sqlite3_column_value(selectStatement, i);
						[dctRow setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumns objectAtIndex:i]];
						break;
				}
			}
			[dctResult setObject:dctRow forKey:[NSString stringWithFormat:@"Table %d",intRow]];
			intRow ++;
		}
	}
	sqlite3_reset(selectStatement);
	return dctResult;
}


- (int) execureScalar:(NSString *)strQuery
{
	int intResult = -1;
	const char *chrQuery = [strQuery UTF8String];
	sqlite3_stmt *sqlStatement;
	int returnValue = sqlite3_prepare_v2(database, chrQuery, -1, &sqlStatement, NULL);
	if(returnValue == SQLITE_OK)
	{
		returnValue = sqlite3_step(sqlStatement);
		if(returnValue == SQLITE_DONE)
		{
			intResult = 0;
		}
	}
	sqlite3_reset(sqlStatement);
	return intResult;

}


- (NSMutableArray *)executeArraySet: (NSString *) strQuery
{
	NSMutableArray *arrayResult = [[NSMutableArray alloc]initWithCapacity:0];
	
	const char *sql = [strQuery UTF8String];
	sqlite3_stmt *selectStatement;
	
	//prepare the select statement
	int returnValue = sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL);
	if(returnValue == SQLITE_OK)
	{
		sqlite3_bind_text(selectStatement, 1, sql, -1, SQLITE_TRANSIENT);
		
		//loop all the rows returned by the query.
		NSMutableArray *arrColumns = [[NSMutableArray alloc]initWithCapacity:0];
		for(int i = 0; i < sqlite3_column_count(selectStatement); i++)
		{
			const char *st = sqlite3_column_name(selectStatement, i);
			[arrColumns addObject:[NSString stringWithCString:st encoding:NSUTF8StringEncoding]];
		}	
		int intRow = 1;
		while(sqlite3_step(selectStatement) == SQLITE_ROW)
		{
			NSMutableDictionary *dctRow = [[NSMutableDictionary alloc]initWithCapacity:0];
			for(int i=0; i < sqlite3_column_count(selectStatement); i++)
			{
				int intValue = 0;
				double dblValue = 0;
				const char *strValue;
				switch(sqlite3_column_type(selectStatement, i))
				{
					case SQLITE_INTEGER:
						intValue = (int)sqlite3_column_int(selectStatement, i);
						[dctRow setObject:[NSNumber numberWithInt:intValue] forKey:[arrColumns objectAtIndex:i]];
						break;
						
					case SQLITE_FLOAT:
						dblValue = (double)sqlite3_column_double(selectStatement, i);
						[dctRow setObject:[NSNumber numberWithDouble:dblValue] forKey:[arrColumns objectAtIndex:i]];
						break;
						
					case SQLITE_TEXT:
						strValue = (const char *)sqlite3_column_text(selectStatement, i);
						[dctRow setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumns objectAtIndex:i]];						
						break;
						
					case SQLITE_BLOB:;
						strValue = (const char *)sqlite3_column_value(selectStatement, i);
						[dctRow setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumns objectAtIndex:i]];	
						break;
					
					case SQLITE_NULL:
						[dctRow	setObject:@"" forKey:[arrColumns objectAtIndex:i]];
					
					default:
						strValue = (const char *)sqlite3_column_value(selectStatement, i);
						[dctRow setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumns objectAtIndex:i]];	
						break;
				}
			}
			[arrayResult addObject:dctRow];
			intRow++;
		}
	}
	sqlite3_reset(selectStatement);
	return arrayResult;
}

- (void)dealloc 
{
	sqlite3_close(database);
	[super dealloc];
	
}

@end
