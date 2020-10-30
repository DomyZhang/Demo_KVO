//
//  My_RunTimeTool.h
//  Demo_appload
//
//  Created by Domy on 2020/10/26.
//  Copyright © 2020 Domy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface My_RunTimeTool : NSObject

+ (void)my_methodSwizzlingWithClass:(Class)cls oriSEL:(SEL)oriSEL swizzledSEL:(SEL)swizzledSEL;
+ (void)my_resolve_methodSwizzlingWithClass:(Class)cls oriSEL:(SEL)oriSEL swizzledSEL:(SEL)swizzledSEL;
+ (void)my_best_methodSwizzlingWithClass:(Class)cls oriSEL:(SEL)oriSEL swizzledSEL:(SEL)swizzledSEL;

@end

NS_ASSUME_NONNULL_END
