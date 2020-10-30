//
//  MyPerson.h
//  Demo_appload
//
//  Created by Domy on 2020/10/26.
//  Copyright © 2020 Domy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyPerson : NSObject {
    @public
    NSString *ivarName;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, strong) NSMutableArray *mDataArray;

@property (nonatomic, assign) NSInteger age;


- (void)personInstanceOne;
+ (void)personClassOne;


@end

NS_ASSUME_NONNULL_END
