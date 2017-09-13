//
//  UIControl+MTDLib.m
//  MTDLib
//
//  Created by wangyc on 5/28/15.
//  Copyright (c) 2015 MTD. All rights reserved.
//

#import <objc/runtime.h>
#import "UIControl+MTDLib.h"

@interface UIControlTarget : NSObject

@property (nonatomic, copy) UIControlBlock block;

+ (id)targetWithAction:(UIControlBlock)aBlock;
- (id)initWithAction:(UIControlBlock)aBlock;
- (void)eventReceiver:(id)sender;

@end

@implementation UIControlTarget

- (void)dealloc {
    Block_release(_block);
    [super dealloc];
}

+ (id)targetWithAction:(UIControlBlock)aBlock {
    return [[[UIControlTarget alloc] initWithAction:aBlock] autorelease];
}

- (id)initWithAction:(UIControlBlock)aBlock {
    self = [self init];
    if (self) {
        self.block = aBlock;
    }
    
    return self;
}

- (void)eventReceiver:(id)sender {
    if(_block) {
        _block(sender);
    }
}

@end

@interface UIControl(array)

@property (nonatomic, retain)NSMutableArray *blocks;

@end

@implementation UIControl (MTDLib)

- (void)addActionBlock:(UIControlBlock)actionBlock forControlEvents:(UIControlEvents)event {
    NSMutableArray *actions = self.blocks;
    UIControlTarget *target = [UIControlTarget targetWithAction:actionBlock];
    [self addTarget:target action:@selector(eventReceiver:) forControlEvents:event];
    [actions addObject:target];
}

- (void)setActionBlock:(UIControlBlock)actionBlock forControlEvents:(UIControlEvents)event {
    NSMutableArray *actions = self.blocks;
    [actions removeAllObjects];
    [self removeTarget:nil action:NULL forControlEvents:event];
    UIControlTarget *target = [UIControlTarget targetWithAction:actionBlock];
    [self addTarget:target action:@selector(eventReceiver:) forControlEvents:event];
    [actions addObject:target];
}

static char* key_blocks = "UIControlBlocks_key";

- (void)setBlocks:(NSMutableArray *)blocks {
    objc_setAssociatedObject(self, key_blocks, blocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)blocks {
    NSMutableArray *blocks = objc_getAssociatedObject(self, key_blocks);
    if (!blocks) {
        blocks = [NSMutableArray array];
        self.blocks = blocks;
    }
    
    return blocks;
}

@end
