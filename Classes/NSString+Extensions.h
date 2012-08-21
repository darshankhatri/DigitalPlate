

#import <Foundation/Foundation.h>


@interface NSString (Extensions)

- (NSString *)documentsDirectoryPath;
- (NSString *)pathInDocumentDirectory;
- (NSString *)pathInDirectory:(NSString *)dir;
- (NSString *)removeWhiteSpace;
- (NSString*)stringByNormalizingCharacterInSet:(NSCharacterSet*)characterSet withString:(NSString*)replacement;
- (NSString *)bindSQLCharacters;
- (NSString *)trimSpaces;
+ (BOOL) validateEmail: (NSString *) candidate;
+(BOOL)validateForNumericAndCharacets:(NSString*)candidate WithLengthRange:(NSString*)strRange;
@end
