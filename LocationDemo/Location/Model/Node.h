//
//  LocationNode.h
//  LocationDemo
//
//  Created by 刘人榕 on 15/12/17.
//  Copyright (c) 2015年 LRR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject

@property (nonatomic, weak) Node *fatherNode;

@property (nonatomic, strong) NSString *name;
+ (instancetype)nodeWithNodeName:(NSString *)name;


// 只能存放Node对象
@property (nonatomic, strong, readonly) NSMutableArray   *childNodes;

- (void)addNode:(Node*)node;
- (void)removeNode:(Node*)node;
- (Node *)nodeAtIndex:(NSInteger)index;
- (BOOL)hasChildNode;

- (NSString*)returnString;

@end


