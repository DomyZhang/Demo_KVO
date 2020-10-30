//
//  NSObject+My_KVO.h
//  DemoEmpty_iOS
//
//  Created by Domy on 2020/10/29.
//  Copyright © 2020 Domy. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "MyKVOInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (My_KVO)

// 添加 observer
- (void)my_addObserver:(NSObject *)observer
            forKeyPath:(NSString *)keyPath
               options:(MyKeyValueObservingOptions)options
               context:(nullable void *)context;

// observer 回调
- (void)my_observeValueForKeyPath:(nullable NSString *)keyPath
                         ofObject:(nullable id)object
                           change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change
                          context:(nullable void *)context;

// 移除监听
- (void)my_removeObserver:(NSObject *)observer
               forKeyPath:(NSString *)keyPath
                  context:(nullable void *)context;

@end

NS_ASSUME_NONNULL_END
