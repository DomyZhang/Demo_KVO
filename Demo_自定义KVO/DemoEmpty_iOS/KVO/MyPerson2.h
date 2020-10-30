//
//  MyPerson2.h
//  DemoEmpty_iOS
//
//  Created by Domy on 2020/10/28.
//  Copyright © 2020 Domy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyPerson2 : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, assign) NSInteger age;

- (void)personInstance2;
+ (void)personClass2;

@end

NS_ASSUME_NONNULL_END
