//
//  ViewController.h
//  DemoEmpty_iOS
//
//  Created by Domy on 2020/10/28.
//  Copyright © 2020 Domy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>


@interface ViewController : UIViewController

- (void)printClasses:(Class)cls;
- (void)printClassAllMethod:(Class)cls;

@end

