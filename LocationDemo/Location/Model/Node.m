//
//  LocationNode.m
//  LocationDemo
//
//  Created by 刘人榕 on 15/12/17.
//  Copyright (c) 2015年 LRR. All rights reserved.
//

#import "Node.h"
@interface Node()
@property (nonatomic, strong) NSMutableArray *childNodes;
@end

@implementation Node
- (instancetype)init{
    self = [super init];
    if (self) {
        self.childNodes = [NSMutableArray array];
    }
    return self;
}


+ (instancetype)nodeWithNodeName:(NSString *)name{
    Node *node = [[[self class] alloc]init];
    node.name = name;
    return node;
}


- (void)addNode:(Node *)node{
    NSParameterAssert(node);
    node.fatherNode = self;
    [self.childNodes addObject:node];
    
}

- (void)removeNode:(Node *)node{
    node.fatherNode = nil;
    [self.childNodes removeObject:node];
}

- (Node*)nodeAtIndex:(NSInteger)index{
    if (index >= self.childNodes.count) {
        return nil;
    } else {
        return self.childNodes[index];
    }
}

- (BOOL)hasChildNode{
    if (self.childNodes.count>0) {
        return YES;
    }else {
        return NO;
    }
}


- (NSString*)returnString{
    return nil;
}

@end

