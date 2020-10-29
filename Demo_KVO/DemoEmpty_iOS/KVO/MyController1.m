//
//  MyController1.m
//  DemoEmpty_iOS
//
//  Created by Domy on 2020/10/28.
//  Copyright © 2020 Domy. All rights reserved.
//

#import "MyController1.h"
#import "MyController2.h"
#import "MyPerson.h"
#import "MySubPerson.h"

@interface MyController1 ()

@property (nonatomic, strong) MyPerson *person;
//@property (nonatomic, strong) MySubPerson *person;

@end

@implementation MyController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeSystem];
    bt.frame = CGRectMake(10, 100, 100, 50);
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bt setTitle:@"back" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(200, 200, 100, 100);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(toNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
//    self.person = [MyPerson new];
////    self.person.name = @"initNick";
//    [self.person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
//
//    // 数组
//    self.person.mDataArray = [NSMutableArray array];
//    [self.person addObserver:self forKeyPath:@"mDataArray" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
//    NSLog(@"newkey=%@ - oldKey=%@",change[NSKeyValueChangeNewKey],change[NSKeyValueChangeOldKey]);
    NSLog(@"%@",change);

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.person.name = [NSString stringWithFormat:@"%@-",self.person.name];
    [[self.person mutableArrayValueForKey:@"mDataArray"] addObject:@"one"]; //[self.person.mDataArray addObject:@"one"];
}

- (void)toNext {
    
    MyController2 *vc = [[MyController2 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
//    
//    [self.person removeObserver:self forKeyPath:@"name" context:NULL];
//    [self.person removeObserver:self forKeyPath:@"mDataArray" context:NULL];

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
