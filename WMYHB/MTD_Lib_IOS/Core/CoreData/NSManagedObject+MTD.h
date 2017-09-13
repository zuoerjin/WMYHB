//
//  NSManagedObject+MTD.h
//  MTDLib
//
//  Created by wangyc on 5/18/15.
//  Copyright (c) 2015 MTD. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (MTD)

+ (NSString *)entityNameString;

+ (NSEntityDescription *)entityInMOC:(NSManagedObjectContext *)moc;

+ (NSManagedObject *)fetchWithPredict:(NSPredicate *)pre withMOC:(NSManagedObjectContext *)currentMoc;
+ (NSArray *)fetchAllWithPredict:(NSPredicate *)pre withMOC:(NSManagedObjectContext *)currentMoc;

+ (NSMutableArray *)allItemsWithPredict:(NSPredicate *)pre withMoc:(NSManagedObjectContext *)currentMoc;
+ (NSMutableArray *)allItemsWithPredict:(NSPredicate *)pre WithSortDescriptor:(NSSortDescriptor *)sortDes withMoc:(NSManagedObjectContext *)currentMoc;

+ (NSMutableArray *)allItemsWithMoc:(NSManagedObjectContext *)currentMoc;
+ (NSUInteger)allItemCount;

+ (id)itemWithMOC:(NSManagedObjectContext *)currentMoc;  // insert a new item
+ (id)itemWithDic:(NSDictionary *)dic inMOC:(NSManagedObjectContext *)moc; // insert or update

- (void)updateWithDic:(NSDictionary *)dic;

- (void)deleteItemAndSave;
+ (void)cleanEntityWithMOCAndSave:(NSManagedObjectContext *)currentMoc;

// for subclass
+ (NSPredicate *)predicateWithDic:(NSDictionary *)dic;
// 主要做key的映射
+ (NSDictionary *)processDicBeforeUpdate:(NSDictionary *)dic;
- (void)processOriginalDicAfterUpdate:(NSDictionary *)dic withMOC:(NSManagedObjectContext *)moc;

+ (NSDictionary *)keyMap;
+ (NSArray *)ignoreKeys;
// 将key对应的value改为map中值对应的class类型
+ (NSDictionary *)replaceValueMap;

@end
