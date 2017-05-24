//
//  ViewController.m
//  MaskTitle
//
//  Created by 叶一帆 on 2017/5/24.
//  Copyright © 2017年 guanKaiTech.com. All rights reserved.
//

#import "ViewController.h"
#import "CustomTitleView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[@"Hello", @"Apple", @"Swift", @"Objc",@"Php"];
    CustomTitleView *titleView = [[CustomTitleView alloc] initWithFrame:CGRectMake(20, 200, self.view.frame.size.width - 40, 50) titles:array];
    [self.view addSubview:titleView];
}


@end
