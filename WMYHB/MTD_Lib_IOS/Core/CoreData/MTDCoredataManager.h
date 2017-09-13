//
//  MTDCoredataManager.h
//  MTDLib
//
//  Created by wangyc on 5/18/15.
//  Copyright (c) 2015 MTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MTDLib.h"

extern NSString *const kCoreDataBaseFileDidChangeNotification;

@interface MTDCoredataManager : NSObject

// config
@property (nonatomic, copy) NSString *persistentStoreFileName;
@property (nonatomic, copy) NSString *managedModelFileName;

@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly) NSManagedObjectContext *rootManagedObjectContext;
@property (nonatomic, readonly) NSManagedObjectContext *mainThreadManagedObjectContext;
@property (nonatomic, readonly) NSManagedObjectContext *threadManagedObjectContext;

// mapping
@property (nonatomic, readonly) NSMutableDictionary *classNameMap; // key ClassName --> :EntityName

+ (instancetype)sharedManager;

+ (NSString *)appDocumentsDirectoryUrlString;
+ (NSURL *)appDocumentsDirectoryURL;

- (BOOL)saveContext:(NSManagedObjectContext *)savedMoc ToPersistentStore:(NSError **)error;

@end
