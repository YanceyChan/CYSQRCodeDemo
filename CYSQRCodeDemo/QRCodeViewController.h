//
//  QRCodeViewController.h
//  CYSQRCodeDemo
//
//  Created by YS_Chan on 15/11/11.
//  Copyright © 2015年 YS_Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QRCodeViewControllerDelegate <NSObject>

- (void)finishedScanningWithResult:(NSString *)result;

@end


@interface QRCodeViewController : UIViewController
@property (weak, nonatomic) id<QRCodeViewControllerDelegate> delegate;
- (void)beginSCanQRCode;
- (void)stopScanQRCode:(NSString *)resultCode;
@end
