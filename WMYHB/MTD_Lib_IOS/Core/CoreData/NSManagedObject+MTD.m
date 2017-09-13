//
//  NSManagedObject+MTD.m
//  MTDLib
//
//  Created by wangyc on 5/18/15.
//  Copyright (c) 2015 MTD. All rights reserved.
//
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSManagedObject+MTD.h"
#import "MTDCoredataManager.h"

@implementation NSManagedObject (MTD)

+ (NSString *)entityNameString {
    if ([self isSubclassOfClass:[NSManagedObject class]]) {
        return [[MTDCoredataManager sharedManager].classNameMap valueForKey:NSStringFromClass(self)];
    }
    return nil;
}

+ (NSEntityDescription *)entityInMOC:(NSManagedObjectContext *)moc {
    if (![self isSubclassOfClass:[NSManagedObject class]] || !moc) {
        return nil;
    }
    
    NSEntityDescription *entDes = nil;
    NSString *entName = [[MTDCoredataManager sharedManager].classNameMap valueForKey:NSStringFromClass(self)];
    if (entName.length > 0) {
        entDes = [NSEntityDescription entityForName:entName inManagedObjectContext:moc];
    }
    return entDes;
}

+ (NSPredicate *)predicateWithDic:(NSDictionary *)dic {
    return nil;
}

+ (NSFetchRequest *)fetchRequestInMoc:(NSManagedObjectContext *)moc {
    return [NSFetchRequest fetchRequestWithEntityName:[self entityInMOC:moc].name];
}

+ (NSManagedObject *)fetchWithPredict:(NSPredicate *)pre withMOC:(NSManagedObjectContext *)currentMoc {
    NSArray *arr = [self fetchAllWithPredict:pre withMOC:currentMoc];
    
    //#if DEBUG
    //    NSAssert([arr count] < 2, @"find more than one items, which expect to be one");
    //#else
    // 如果数据中出现重复的数据
    if ([arr count] > 1) {
        for (NSManagedObject *mobj in arr) {
            [mobj deleteItemAndSave];
        }
        return nil;
    }
    //#endif
    return arr.lastObject;
}

+ (NSArray *)fetchAllWithPredict:(NSPredicate *)pre withMOC:(NSManagedObjectContext *)currentMoc {
    if (currentMoc) {
        NSError *error = nil;
        NSFetchRequest *req = [self fetchRequestInMoc:currentMoc];
        req.predicate = pre;
        NSArray *arr = [currentMoc executeFetchRequest:req error:&error];
        if (error) {
            NSLog(@"%@-%@ with error %@", NSStringFromClass(self), NSStringFromSelector(_cmd), error);
            return nil;
        }
        return arr;
    }
    return nil;
}

+ (NSMutableArray *)allItemsWithPredict:(NSPredicate *)pre withMoc:(NSManagedObjectContext *)currentMoc {
    if (!currentMoc) {
        return nil;
    }
    
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:[self entityInMOC:currentMoc].name];
    req.predicate = pre;
    return  [NSMutableArray arrayWithArray:[currentMoc executeFetchRequest:req error:nil]];
}

+ (NSMutableArray *)allItemsWithPredict:(NSPredicate *)pre WithSortDescriptor:(NSSortDescriptor *)des withMoc:(NSManagedObjectContext *)currentMoc {
    if (!currentMoc) {
        return nil;
    }
    
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:[self entityInMOC:currentMoc].name];
    req.predicate = pre;
    
    if (des) {
        req.sortDescriptors = @[des];
    }
    return  [[currentMoc executeFetchRequest:req error:nil] mutableCopy];
}

+ (NSMutableArray *)allItemsWithMoc:(NSManagedObjectContext *)currentMoc {
    return [self allItemsWithPredict:nil withMoc:currentMoc];
}

+ (NSUInteger)allItemCount {
    NSManagedObjectContext *mainMoc = [MTDCoredataManager sharedManager].mainThreadManagedObjectContext;
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[self entityInMOC:mainMoc].name];
    return [mainMoc countForFetchRequest:req error:nil];
}

+ (id)itemWithMOC:(NSManagedObjectContext *)currentMoc {  // insert a new item
    if (currentMoc) {
        NSEntityDescription *ent = [self entityInMOC:currentMoc];
        if (ent) {
            return [NSEntityDescription insertNewObjectForEntityForName:ent.name inManagedObjectContext:currentMoc];
        }
    }
    return nil;
}

+ (id)itemWithDic:(NSDictionary *)dic inMOC:(NSManagedObjectContext *)moc {
    if (dic && moc) {
        @synchronized(moc) {
            NSError *error = nil;
            NSDictionary *originDic = [NSDictionary dictionaryWithDictionary:dic];
            
            dic = [self processDicBeforeUpdate:dic];
            
            NSPredicate *pre = [self predicateWithDic:dic];
            NSManagedObject *existItem = [self fetchWithPredict:pre withMOC:moc];
            
            // 如果不存在 insert 一个新的
            if (!existItem) {
                existItem = [self itemWithMOC:moc];
            }
            
            dic = [existItem processDataDicBeforeUpdate:dic withMOC:moc];
            
            [existItem _updateWithDictionary:dic error:&error];
            
            if (error) {
                NSLog(@"%@-%@ with error %@", NSStringFromClass(self), NSStringFromSelector(_cmd), error);
            }
            
            [existItem processOriginalDicAfterUpdate:originDic withMOC:moc];
            
            return existItem;
        }
    }
    return nil;
}

- (void)updateWithDic:(NSDictionary *)dic {
    // do nothing
}

- (void)deleteItemAndSave {
    NSManagedObjectContext *moc = self.managedObjectContext;
    NSManagedObject __weak *pself = self;
    
    [moc performBlockAndWait:^{
        [moc deleteObject:pself];
        [[MTDCoredataManager sharedManager] saveContext:moc ToPersistentStore:nil];
    }];
}

+ (void)cleanEntityWithMOCAndSave:(NSManagedObjectContext *)currentMoc {
    [currentMoc performBlockAndWait:^{
        NSEntityDescription *ent = [self entityInMOC:currentMoc];
        if (!ent) {
            return;
        }
        
        NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:ent.name];
        NSArray *arr = [currentMoc executeFetchRequest:req error:nil];
        for (NSManagedObject *item in arr) {
            [currentMoc deleteObject:item];
        }
        [[MTDCoredataManager sharedManager] saveContext:currentMoc ToPersistentStore:nil];
    }];
}

#pragma mark - kvc pharsing

- (void)_updateWithDictionary:(NSDictionary*)dictionary error:(NSError**)error {
    //introspect managed object
    Class class = [self class];
    NSMutableDictionary* moProperties = [@{} mutableCopy];
    
    while (class != [NSManagedObject class]) {
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
        
        //loop over the class properties
        for (unsigned int i = 0; i < propertyCount; i++) {
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            
            const char *attrs = property_getAttributes(property);
            NSString* propertyAttributes = @(attrs);
            NSScanner* scanner = [NSScanner scannerWithString: propertyAttributes];
            NSString* propertyType = nil;
            [scanner scanUpToString:@"T" intoString: nil];
            [scanner scanString:@"T" intoString:nil];
            
            //check if the property is an instance of a class
            if ([scanner scanString:@"@\"" intoString: &propertyType]) {
                
                [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"]
                                        intoString:&propertyType];
            }
            
            moProperties[@(propertyName)] = NSClassFromString(propertyType);
        }
        
        free(properties);
        class = [class superclass];
    }
    
    //copy values over
    NSArray *allPopertyKeys = [moProperties allKeys];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([allPopertyKeys containsObject:key]) {
            id value = obj;
            if ([value isKindOfClass:moProperties[key]]) {
                //exception classes - for core data should be NSDate by default
                if ([[moProperties[key]class] isEqual:[NSDate class]]) {
                    SEL NSDateFromNSStringSelector = sel_registerName("NSDateFromNSString:");
                    if ([self respondsToSelector:NSDateFromNSStringSelector]) {
                        IMP methodImpl = [self methodForSelector:NSDateFromNSStringSelector];
                        NSDate * (*method)(id, SEL, NSString *) = (void *)methodImpl;
                        //transform the value
                        value = method(self, NSDateFromNSStringSelector, dictionary[key]);
                    } else {
                        value = [self __NSDateFromNSString: dictionary[key]];
                    }
                }
                
                //copy the value to the managed object
                [self setValue:value forKey:key];
            }
            else if ([value isKindOfClass:[NSNumber class]] && [NSStringFromClass(moProperties[key]) isEqualToString:@"NSString"]) {
                [self setValue:[(NSNumber *)value stringValue] forKey:key];
            }
        }
    }];
}

#pragma mark - string <-> date
-(NSDate*)__NSDateFromNSString:(NSString*)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    string = [string stringByReplacingOccurrencesOfString:@":" withString:@""]; // this is such an ugly code, is this the only way?
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HHmmssZZZZ"];
    
    return [dateFormatter dateFromString: string];
}

#pragma mark - subClass

+ (NSDictionary *)processDicBeforeUpdate:(NSDictionary *)dic {
    if (dic) {
        NSMutableDictionary *cpDic = [dic mutableCopy];
        
        // 映射obj与数据对象的key map
        NSDictionary *keyMap = [self keyMap];
        [keyMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            id valueObj = [dic objectForKey:obj];
            if (valueObj) {
                [cpDic setObject:valueObj forKey:key];
                [cpDic removeObjectForKey:obj];
            }
        }];
        
        // ignore key对应的value
        NSArray *ignoreKeys = [self ignoreKeys];
        if (ignoreKeys.count > 0) {
            [cpDic removeObjectsForKeys:ignoreKeys];
        }
        
        // replace key value class
        NSDictionary *replaceKeyMap = [self replaceValueMap];
        [replaceKeyMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                Class cls = NSClassFromString(obj);
                [cpDic setObject:[cls new] forKey:key];
            }
        }];
        
        return cpDic;
    }
    return dic;
}

- (NSDictionary *)processDataDicBeforeUpdate:(NSDictionary *)dic withMOC:(NSManagedObjectContext *)moc {
    return dic;
}

- (void)processOriginalDicAfterUpdate:(NSDictionary *)dic withMOC:(NSManagedObjectContext *)moc {
    // do nothing
    // for subclass
}

+ (NSDictionary *)keyMap {
    return nil;
}

+ (NSArray *)ignoreKeys {
    return nil;
}

+ (NSDictionary *)replaceValueMap {
    return nil;
}

@end
