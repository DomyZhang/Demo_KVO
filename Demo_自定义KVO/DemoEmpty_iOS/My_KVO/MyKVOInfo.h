//
//  MyKVOInfo.h
//  DemoEmpty_iOS
//
//  Created by Domy on 2020/10/29.
//  Copyright © 2020 Domy. All rights reserved.
//

///用来保存 监听相关的一些信息

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_OPTIONS(NSUInteger, MyKeyValueObservingOptions) {
    
    MyKeyValueObservingOptionNew = 0x01,
    MyKeyValueObservingOptionOld = 0x02,
};

@interface MyKVOInfo : NSObject 

@property (nonatomic, weak) NSObject  *observer;
@property (nonatomic, copy) NSString  *keyPath;
@property (nonatomic, assign) MyKeyValueObservingOptions options;

- (instancetype)initWitObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(MyKeyValueObservingOptions)options;

@end

NS_ASSUME_NONNULL_END
