//
//  MTDCoredataManager.m
//  MTDLib
//
//  Created by wangyc on 5/18/15.
//  Copyright (c) 2015 MTD. All rights reserved.
//

#import "MTDCoredataManager.h"

NSString *const kCoreDataBaseFileDidChangeNotification = @"kPBCoreDataBaseFileDidChangeNotification";

@implementation MTDCoredataManager {
    NSManagedObjectModel *_managedObjectModel;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    
    NSManagedObjectContext *_rootManagedObjectContext;
    NSManagedObjectContext *_mainThreadManagedObjectContext;
    NSManagedObjectContext *_threadManagedObjectContext;
    
    NSMutableDictionary *_classNameMapping;
}

+ (instancetype)sharedManager {
    static id _g_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _g_instance = [[self alloc] init];
    });
    return _g_instance;
}

+ (NSString *)appDocumentsDirectoryUrlString {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSURL *)appDocumentsDirectoryURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *appName = [[[NSBundle mainBundle] infoDictionary] stringValueForKey:(NSString *)kCFBundleExecutableKey defaultValue:nil];
        NSAssert(appName, @"kCFBundleExecutableKey return nil when init DWCoredataManager");
//        _managedModelFileName = [appName copy];
        _managedModelFileName = @"YH";
        self.persistentStoreFileName = @"data.sqlite";
    }
    return self;
}

- (void)setPersistentStoreFileName:(NSString *)persistentStoreFileName {
    if (![persistentStoreFileName isEqualToString:_persistentStoreFileName]) {
        _persistentStoreFileName = [persistentStoreFileName copy];
        
        _persistentStoreCoordinator = nil;
        _rootManagedObjectContext = nil;
        _mainThreadManagedObjectContext = nil;
        _threadManagedObjectContext = nil;
        [self.classNameMap removeAllObjects];
        
        [self coredataProDebugInfoUpdate];
        
        [self rootManagedObjectContext];
        [self mainThreadManagedObjectContext];
        [self threadManagedObjectContext];
        
        // init map
        [self initMapping];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kCoreDataBaseFileDidChangeNotification object:nil];
        });
    }
}

- (void)setManagedModelFileName:(NSString *)managedModelFileName {
    if (![managedModelFileName isEqualToString:_managedModelFileName]) {
        _managedModelFileName = [managedModelFileName copy];
        
        // update managed context
        self.persistentStoreFileName = self.persistentStoreFileName;
    }
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        NSAssert(self.managedModelFileName, @"managedModelFileName can`t be nil when load coredata momd file");
        
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.managedModelFileName withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        NSURL *storeURL = [[[self class] appDocumentsDirectoryURL] URLByAppendingPathComponent:self.persistentStoreFileName];
        NSError *error = nil;
        NSDictionary *option = @{NSMigratePersistentStoresAutomaticallyOption: @(YES),
                                 NSInferMappingModelAutomaticallyOption: @(YES)};
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:option error:&error]) {
            if (error.code == 134100) {
                // delete fault file
                unlink([[storeURL path] UTF8String]);
                if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:option error:&error]) {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            }
            else {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
        
        // remove from backup map
        {
            assert([[NSFileManager defaultManager] fileExistsAtPath: [storeURL path]]);
            error = nil;
            
            BOOL success = [storeURL setResourceValue: [NSNumber numberWithBool: YES]
                                               forKey: NSURLIsExcludedFromBackupKey error: &error];
            if(!success){
                NSLog(@"Error excluding %@ from backup %@", [storeURL lastPathComponent], error);
            }
        }
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)rootManagedObjectContext {
    if (!_rootManagedObjectContext) {
        _rootManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _rootManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
        _rootManagedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    }
    return _rootManagedObjectContext;
}

- (NSManagedObjectContext *)mainThreadManagedObjectContext {
    if (!_mainThreadManagedObjectContext) {
        _mainThreadManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainThreadManagedObjectContext.parentContext = self.rootManagedObjectContext;
        _mainThreadManagedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    }
    return _mainThreadManagedObjectContext;
}

- (NSManagedObjectContext *)threadManagedObjectContext {
    if (!_threadManagedObjectContext) {
        _threadManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _threadManagedObjectContext.parentContext = self.mainThreadManagedObjectContext;
        _threadManagedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    }
    return _threadManagedObjectContext;
}

#pragma mark - mapping

- (void)initMapping {
    for (NSEntityDescription *entDes in self.managedObjectModel.entities) {
        [self.classNameMap setValue:entDes.name forKey:entDes.managedObjectClassName];
    }
}

- (NSMutableDictionary *)classNameMap {
    if (!_classNameMapping) {
        _classNameMapping = [[NSMutableDictionary alloc] init];
    }
    return _classNameMapping;
}

#pragma mark - save

- (BOOL)saveContext:(NSManagedObjectContext *)savedMoc ToPersistentStore:(NSError **)error {
    __block NSError *localError = nil;
    
    /**
     To work around issues in ios 5 first obtain permanent object ids for any inserted objects.  If we don't do this then its easy to get an `NSObjectInaccessibleException`.  This happens when:
     
     1. Create new object on main context and save it.
     2. At this point you may or may not call obtainPermanentIDsForObjects for the object, it doesn't matter
     3. Update the object in a private child context.
     4. Save the child context to the parent context (the main one) which will work,
     5. Save the main context - a NSObjectInaccessibleException will occur and Core Data will either crash your app or lock it up (a semaphore is not correctly released on the first error so the next fetch request will block forever.
     */
    [savedMoc obtainPermanentIDsForObjects:[[savedMoc insertedObjects] allObjects] error:&localError];
    if (localError) {
        if (error) *error = localError;
        return NO;
    }
    
    BOOL success = [savedMoc save:&localError];
    if (! success && localError == nil) NSLog(@"Saving of managed object context failed, but a `nil` value for the `error` argument was returned. This typically indicates an invalid implementation of a key-value validation method exists within your model. This violation of the API contract may result in the save operation being mis-interpretted by callers that rely on the availability of the error.");
    
    
    if (! success) {
        if (error) *error = localError;
        return NO;
    }
    
    if (savedMoc.parentContext) {
        [self _saveContext:savedMoc.parentContext];
    }
    
    return YES;
}

- (void)_saveContext:(NSManagedObjectContext *)savedMoc {
    WEAK_SELF_DEFINE(pSelf);
    if (!savedMoc) {
        return;
    }
    
    [savedMoc performBlock:^{
        NSError *localError = nil;
        [savedMoc obtainPermanentIDsForObjects:[[savedMoc insertedObjects] allObjects] error:&localError];
        if (localError) {
            NSLog(@"%@", localError);
            return;
        }
        
        BOOL success = [savedMoc save:&localError];
        if (!success){
            NSLog(@"%@", localError);
            return;
        }
        if (savedMoc.parentContext) {
            [pSelf _saveContext:savedMoc.parentContext];
        }
        
    }];
}

#pragma mark - CoreDataUtility debug
#if !(TARGET_OS_EMBEDDED)  // This will work for Mac or Simulator but excludes physical iOS devices
- (void) createCoreDataDebugProjectWithType: (NSNumber*) storeFormat storeUrl:(NSString*) storeURL modelFilePath:(NSString*) modelFilePath {
    NSDictionary* project = @{
                              @"storeFilePath": storeURL,
                              @"storeFormat" : storeFormat,
                              @"modelFilePath": modelFilePath,
                              @"v" : @(1)
                              };
    
    NSString* projectFile = [NSString stringWithFormat:@"/tmp/%@.cdp", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey]];
    
    [project writeToFile:projectFile atomically:YES];
    
}
#endif

- (void)coredataProDebugInfoUpdate {
#if !(TARGET_OS_EMBEDDED)  // This will work for Mac or Simulator but excludes physical iOS devices
#ifdef DEBUG
    // @(1) is NSSQLiteStoreType
    NSURL *storeURL = [[[self class] appDocumentsDirectoryURL] URLByAppendingPathComponent:self.persistentStoreFileName];
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.managedModelFileName withExtension:@"momd"];
    [self createCoreDataDebugProjectWithType:@(1) storeUrl:[storeURL absoluteString] modelFilePath:[modelURL absoluteString]];
#endif
#endif
}

@end
