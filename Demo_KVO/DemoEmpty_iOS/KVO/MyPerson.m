//
//  MyPerson.m
//  Demo_appload
//
//  Created by Domy on 2020/10/26.
//  Copyright © 2020 Domy. All rights reserved.
//

#import "MyPerson.h"

@implementation MyPerson



+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    return YES;
}

//- (void)setName:(NSString *)name {
//    [self willChangeValueForKey:@"name"];
//    _name = name;
//    [self didChangeValueForKey:@"name"];
//}


- (void)personInstanceOne {
    NSLog(@"%s",__func__);
}
+ (void)personClassOne {
    NSLog(@"%s",__func__);
}

@end
