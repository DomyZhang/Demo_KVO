//
//  MyKVOInfo.m
//  DemoEmpty_iOS
//
//  Created by Domy on 2020/10/29.
//  Copyright © 2020 Domy. All rights reserved.
//

#import "MyKVOInfo.h"

@implementation MyKVOInfo


- (instancetype)initWitObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(MyKeyValueObservingOptions)options {
    self = [super init];
    if (self) {
        self.observer = observer;
        self.keyPath  = keyPath;
        self.options  = options;
    }
    return self;
}

@end

