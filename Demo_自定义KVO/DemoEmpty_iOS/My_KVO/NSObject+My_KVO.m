//
//  NSObject+My_KVO.m
//  DemoEmpty_iOS
//
//  Created by Domy on 2020/10/29.
//  Copyright © 2020 Domy. All rights reserved.
//

#import "NSObject+My_KVO.h"
#import <objc/message.h>

static NSString *const kMyKVOPrefix = @"MyKVONotifying_";
static NSString *const kMyKVOAssiociateKey = @"kMyKVO_AssiociateKey";

@implementation NSObject (My_KVO)

- (void)my_addObserver:(NSObject *)observer
            forKeyPath:(NSString *)keyPath
               options:(MyKeyValueObservingOptions)options
               context:(nullable void *)context {
    
    // 1、setter 方法判断存在不
    [self checkSetterMethodFromKeyPath:keyPath];
    
    // 2、动态生成子类
    Class newCls = [self createSubClassWithKeyPath:keyPath];
    
    // 3、isa 指向新类
    object_setClass(self, newCls);
    // 4、父类的 setter 方法要调 - 给父类发消息
    // 5、观察者去响应
    // 5.1 关联对象 用来拿到观察者
    MyKVOInfo *info = [[MyKVOInfo alloc] initWitObserver:observer forKeyPath:keyPath options:options];
    
    // 拿到 关联对象 objc_getAssociatedObject
//    // array
//    NSMutableArray *observerArr = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kMyKVOAssiociateKey));
//    if (!observerArr) {
//        observerArr = [NSMutableArray array];
//        [observerArr addObject:info];
//        // 添加关联对象
//        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kMyKVOAssiociateKey), observerArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
    //
//    NSMapTable
    
    // hashTable
    NSHashTable *map = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kMyKVOAssiociateKey));
    if (!map) {
        map = [NSHashTable hashTableWithOptions:NSPointerFunctionsStrongMemory];
    }
    [map addObject:info];
    // 添加关联对象
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kMyKVOAssiociateKey), map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 监察响应
- (void)my_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
}

// 移除监听
- (void)my_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context {
    
    // 拿到所有关联
    NSHashTable *map = objc_getAssociatedObject(self, (__bridge const void *)(kMyKVOAssiociateKey));
    if (map.count > 0) {
        
        for (MyKVOInfo *info in map) {
            
            if ([keyPath isEqualToString:info.keyPath]) {
                [map removeObject:info];
                objc_setAssociatedObject(self, (__bridge const void *)(kMyKVOAssiociateKey), map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                break;
            }
        }
    }
    
    if (map.count==0) {// 都移除了
        // isa 指回父类 MyPerson
        object_setClass(self, [self class]);
    }
    
}

// 检查 setter 方法存在与否
- (void)checkSetterMethodFromKeyPath:(NSString *)keyPath {
    
    Class superCls = object_getClass(self);
    SEL setterSelector = NSSelectorFromString(setterFromGetter(keyPath));
    
    Method setterMethod = class_getInstanceMethod(superCls, setterSelector);
    if (!setterMethod) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:[NSString stringWithFormat:@"当前%@的没有 setter",keyPath] userInfo:nil];
    }
}

// 创建一个类
- (Class)createSubClassWithKeyPath:(NSString *)keyPath {
    
    // 拿到当前的类
    NSString *oldClsName = NSStringFromClass([self class]);
    // 新类的名字
    NSString *newClsName = [NSString stringWithFormat:@"%@%@",kMyKVOPrefix,oldClsName];
    // 新类
    Class newCls = NSClassFromString(newClsName);
    
    // 新类不存在
    if (!newCls) {
        
        // 申请类
        //    newCls = objc_allocateClassPair(Class  _Nullable __unsafe_unretained superclass, const char * _Nonnull name, size_t extraBytes)
        newCls = objc_allocateClassPair([self class], newClsName.UTF8String, 0);
        
        // 注册类 ： 在注册前可添加 ivar 成员变量,因为此时类还未信道内存，但注册后类已写入内存，ivar变量就不可在添加了 - (ivar <- ro)
        objc_registerClassPair(newCls);
    };
    
    // 给类添加方法 rwe
    // 1、添加 class 方法 : class 指向 MyPerson
    SEL classSEL = NSSelectorFromString(@"class");
    Method classMethod = class_getInstanceMethod([self class], classSEL);
    const char *classTypes = method_getTypeEncoding(classMethod);
    class_addMethod(newCls, classSEL, (IMP)my_class, classTypes);
    
    // 2、setter 方法
    SEL setterSel = NSSelectorFromString(setterFromGetter(keyPath));
    // 拿到 MyPerson 的 setter 方法
    Method setMethod = class_getInstanceMethod([self class], setterSel);
    // 得到方法签名
    const char *type = method_getTypeEncoding(setMethod);
    // 添加方法
    class_addMethod(newCls, setterSel, (IMP)my_setter, type);
    
    // 3、dealloc 方法
    SEL deallocSel = NSSelectorFromString(@"dealloc");
    // 拿到 MyPerson 的 setter 方法
    Method deallocMethod = class_getInstanceMethod([self class], deallocSel);
    // 得到方法签名
    const char *deallocType = method_getTypeEncoding(deallocMethod);
    // 添加方法
    class_addMethod(newCls, deallocSel, (IMP)my_dealloc, deallocType);
    
    return newCls;
}

#pragma mark -  子类重写的 imp -
static void my_setter(id self,SEL _cmd,id newValue){
    NSLog(@"要开始转给父类消息了:%@",newValue);
    
    // 4、消息转发 : 转发给父类
    NSString *keyPath = getterFormSetter(NSStringFromSelector(_cmd));
    id oldValue = [self valueForKey:keyPath];
    // 重定义 objc_super
    void (*my_msgSendSuper)(void *, SEL, id) = (void *)objc_msgSendSuper;
    struct objc_super superStruct = {
        // 定义俩 属性
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self)),
    };
    
    my_msgSendSuper(&superStruct,_cmd,newValue);
    
    // 5、VC 响应
    // 这里如何拿到观察者呢？--> 关联对象 --> 在 addObserver 方法中添加关联对象
//    [observer my_observeValueForKeyPath:keyPath ofObject:self change:@{key:Value} context:NULL];
    // 拿到关联对象
//    NSMutableArray *observerArr = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kMyKVOAssiociateKey));
    NSHashTable *map = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kMyKVOAssiociateKey));
    // 遍历 array
    for (MyKVOInfo *info in map) {
                
        if ([keyPath isEqualToString:info.keyPath]) {
        
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                // 对新旧值进行处理
                NSMutableDictionary<NSKeyValueChangeKey,id> *change = [NSMutableDictionary dictionary];
                if (info.options & MyKeyValueObservingOptionNew) {// 新值
                    [change setObject:newValue forKey:NSKeyValueChangeNewKey];
                }
                if (info.options & MyKeyValueObservingOptionOld) {// 旧值
                    
                    // 旧值
                    [change setObject:@"" forKey:NSKeyValueChangeOldKey];
                    if (oldValue) {
                        [change setObject:oldValue forKey:NSKeyValueChangeOldKey];
                    }
                }
                
                // 消息发给观察者
                SEL observerSEL = @selector(my_observeValueForKeyPath:ofObject:change:context:);
                objc_msgSend(info.observer,observerSEL,info.keyPath,self,change,NULL);// 报错 -> 把严格检查设为NO 即可
            });
        }
    }
}

#pragma mark - 获取 class -
Class my_class(id self, SEL _cmd) {
    return class_getSuperclass(object_getClass(self));
}

#pragma mark - my_dealloc isa 指回MyPerson类，-
static void my_dealloc(id self,SEL _cmd){
    
    NSLog(@"VC走了，自动销毁observer %s",__func__);
    // isa 指回 MyPerson
    object_setClass(self, [self class]);/**
                                         (lldb) p self
                                         (MyKVONotifying_MyPerson *) $0 = 0x000060000336b990
                                         (lldb) p self
                                         (MyPerson *) $1 = 0x000060000336b990
                                         (lldb)
                                         */
}



#pragma mark - 通过 getter 方法得到 setter 的名字 -
static NSString * setterFromGetter(NSString *getter){
    // 例：name --> setName
    if (getter.length <= 0) return nil;
    NSString *firstStr = [[getter substringToIndex:1] uppercaseString];// N
    NSString *othersStr = [getter substringFromIndex:1];// ame

    return [NSString stringWithFormat:@"set%@%@:",firstStr,othersStr];
}

#pragma mark - 通过 set 方法获取 getter 方法的名称 set<Key>:==> key
static NSString *getterFormSetter(NSString *setter){
    
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) { return nil;}
    
    NSRange range = NSMakeRange(3, setter.length-4);
    NSString *getter = [setter substringWithRange:range];
    NSString *firstString = [[getter substringToIndex:1] lowercaseString];
    return  [getter stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstString];
}


@end
