//
//  MySubPerson+forSwizz.m
//  Demo_appload
//
//  Created by Domy on 2020/10/26.
//  Copyright © 2020 Domy. All rights reserved.
//

#import "MySubPerson+forSwizz.h"

#import "My_RunTimeTool.h"

@implementation MySubPerson (forSwizz)

// 1、+load 中交换方法
//+ (void)load {
//
//    NSLog(@"%s",__func__);
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [My_RunTimeTool my_methodSwizzlingWithClass:self oriSEL:@selector(personInstanceOne) swizzledSEL:@selector(my_subPersonInstanceOne)];
//    });
//}
//+ (void)initialize
//{
//    if (self == [super class]) {
//        NSLog(@"%s",__func__);
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            [My_RunTimeTool my_best_methodSwizzlingWithClass:self oriSEL:@selector(personInstanceOne) swizzledSEL:@selector(my_subPersonInstanceOne)];
//        });
//    }
//}

//- (void)my_subPersonInstanceOne {
//    NSLog(@"%s",__func__);
//    [self my_subPersonInstanceOne];
//    NSLog(@"MySubPerson 分类添加的对象方法:%s",__func__);
//}

@end
