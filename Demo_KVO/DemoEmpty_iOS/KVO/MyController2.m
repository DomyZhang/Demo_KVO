//
//  MyController2.m
//  DemoEmpty_iOS
//
//  Created by Domy on 2020/10/28.
//  Copyright © 2020 Domy. All rights reserved.
//

#import "MyController2.h"
#import "MyPerson.h"
#import "MySubPerson.h"

@interface MyController2 ()

@property (nonatomic, strong) MyPerson *person;
//@property (nonatomic, strong) MySubPerson *person;

@end

@implementation MyController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];

//    [self printClasses:[MyPerson class]];
//    [self printClassAllMethod:[MyPerson class]];
    self.person = [[MyPerson alloc]init];
    [self.person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
//    [self.person addObserver:self forKeyPath:@"ivarName" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
//    [self printClasses:[MyPerson class]];
//    [self printClassAllMethod:objc_getClass("NSKVONotifying_MyPerson")];
//    [self printClassAllMethod:[MySubPerson class]];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    NSLog(@"赋值前 name=%@ - ivarName=%@",self.person.name,self.person->ivarName);

    self.person.name = @"名字";
//    self.person->ivarName = @"昵称";
    
//    NSLog(@"赋值后 name=%@ / ivarName=%@",self.person.name,self.person->ivarName);

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"obeserver %@",change);
    NSLog(@"newkey=%@ / oldKey=%@",change[NSKeyValueChangeNewKey],change[NSKeyValueChangeOldKey]);
}

- (void)dealloc {
//    [self printClassAllMethod:objc_getClass("NSKVONotifying_MyPerson")];

    [self.person removeObserver:self forKeyPath:@"name" context:NULL];
//    [self.person removeObserver:self forKeyPath:@"ivarName" context:NULL];
//    [self printClassAllMethod:objc_getClass("NSKVONotifying_MyPerson")];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
