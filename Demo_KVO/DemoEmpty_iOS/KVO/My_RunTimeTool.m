//
//  My_RunTimeTool.m
//  Demo_appload
//
//  Created by Domy on 2020/10/26.
//  Copyright © 2020 Domy. All rights reserved.
//
/**
 处理方法交换
 */

#import "My_RunTimeTool.h"
#import <objc/runtime.h>

@implementation My_RunTimeTool

// 1、
+ (void)my_methodSwizzlingWithClass:(Class)cls oriSEL:(SEL)oriSEL swizzledSEL:(SEL)swizzledSEL {
    
    if (!cls) NSLog(@"传入的交换类不能为空");

    Method oriMethod = class_getInstanceMethod(cls, oriSEL);
    Method swiMethod = class_getInstanceMethod(cls, swizzledSEL);
    method_exchangeImplementations(oriMethod, swiMethod);
}

// 2、父类实现 子类未实现 oriSEL
+ (void)my_resolve_methodSwizzlingWithClass:(Class)cls oriSEL:(SEL)oriSEL swizzledSEL:(SEL)swizzledSEL {
    
    if (!cls) NSLog(@"传入的交换类不能为空");

    Method oriMethod = class_getInstanceMethod(cls, oriSEL);
    Method swiMethod = class_getInstanceMethod(cls, swizzledSEL);
    
    // 尝试添加我们要交换的方法 swiMethod: my_subPersonInstanceOne
    BOOL success = class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(oriMethod));
    
    if (success) {// 加成功了，那么就是自己没有方法：swiMethod - 用自己替换
        class_replaceMethod(cls, swizzledSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    }else{ // 自己有，正常交换
        method_exchangeImplementations(oriMethod, swiMethod);
    }
}

// 3、父类子类未实现 oriSEL
+ (void)my_best_methodSwizzlingWithClass:(Class)cls oriSEL:(SEL)oriSEL swizzledSEL:(SEL)swizzledSEL {
    
    if (!cls) NSLog(@"传入的交换类不能为空");

    Method oriMethod = class_getInstanceMethod(cls, oriSEL);
    Method swiMethod = class_getInstanceMethod(cls, swizzledSEL);
    
    if (!oriMethod) {// 避免动作没有意义
        // 在 oriMethod 为 nil 时，替换后将 swizzledSEL 赋值一个不做任何事的空实现,代码如下:
        class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
        method_setImplementation(swiMethod, imp_implementationWithBlock(^(id self, SEL _cmd){
            NSLog(@"来了一个空的 imp");
        }));
    }
    
    // 尝试添加我们要交换的方法 swiMethod: my_subPersonInstanceOne
    BOOL success = class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(oriMethod));
    
    if (success) {// 加成功了，那么就是自己没有方法：swiMethod - 用自己替换
        class_replaceMethod(cls, swizzledSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    }else{ // 自己有，正常交换
        method_exchangeImplementations(oriMethod, swiMethod);
    }
}


@end
