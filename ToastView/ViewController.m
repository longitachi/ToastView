//
//  ViewController.m
//  ToastView
//
//  Created by long on 16/5/9.
//  Copyright © 2016年 long. All rights reserved.
//

#import "ViewController.h"
#import "ToastUtils.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /**
     注意：一般一个界面的提示不会一会出现在上方一会出现在下方，该界面只是演示用，所以当快速点击上方和下方的toastview时候 会出现先出现的toastview的frame.origin.y跟随后点击的toastview方向进行变化
     */
}

static int i = 0;
- (IBAction)btnShowToastAtTop:(id)sender {
    ShowToastLongAtTop(@"第%d次显示（上方的toastview）", i++);
}

static int j = 0;
- (IBAction)btnShowToastAtBottom:(id)sender {
    ShowToastLong(@"我是显示在下方的toastview，次数:%d", j++);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
