//
//  ViewController.m
//  FMLoadingButton
//
//  Created by 范茂羽 on 16/2/22.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "ViewController.h"
#import "FMLoadingButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    FMLoadingButton *loadingBtn = [[FMLoadingButton alloc]initWithFrame:CGRectMake(100, 100, 200, 70)];
    [self.view addSubview:loadingBtn];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(300, 300, 100, 100)];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"btn" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    UIView *view = [[UIView alloc]initWithFrame:btn.bounds];
    view.userInteractionEnabled = NO;
    [btn addSubview:view];
    
}

-(void)btnAction
{
    NSLog(@"hehe");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
