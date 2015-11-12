//
//  ViewController.m
//  CYSQRCodeDemo
//
//  Created by YS_Chan on 15/11/11.
//  Copyright © 2015年 YS_Chan. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeViewController.h"

@interface ViewController ()<QRCodeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)jumpToQRView:(UIButton *)sender {
    QRCodeViewController *qrVC = [[QRCodeViewController alloc] init];
    qrVC.delegate = self;
    [self presentViewController:qrVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - QRCodeViewControllerDelegate
- (void)finishedScanningWithResult:(NSString *)result{
    self.infoLabel.text = result;
}

@end
