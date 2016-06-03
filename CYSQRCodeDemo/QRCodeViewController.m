//
//  QRCodeViewController.m
//  CYSQRCodeDemo
//
//  Created by YS_Chan on 15/11/11.
//  Copyright © 2015年 YS_Chan. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "ScanView.h"

#define VIEW_WIDTH  [UIScreen  mainScreen].bounds.size.width
#define VIEW_HEIGHT [UIScreen  mainScreen].bounds.size.height
#define TINTCOLOR_ALPHA        0.5                           //浅色透明度
#define DARKCOLOR_ALPHA        0.8                           //深色透明度
#define SCANVIEW_WITH          300.f
#define SCANVIEW_HEIGHT        300.f
#define QRVIEW_DISTANCE_TOP    70.f



@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
//@property (strong, nonnull, nonatomic) UIView *qrCodeView;
@property (strong, nonnull, nonatomic) UIView *scanView;
@property (strong, nonnull, nonatomic) UIView *topView;
@property (strong, nonnull, nonatomic) UIView *bottomView;
@property (strong, nonnull, nonatomic) UIView *leftView;
@property (strong, nonnull, nonatomic) UIView *rightView;
@property (strong, nonnull, nonatomic) ScanView *subScanView;

@property (strong, nonatomic) AVCaptureSession           *captureSession;
@property (strong, nonatomic) AVCaptureSession           *captureSession2;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (strong, nonatomic) NSTimer                    *timer;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.2554 green:0.2554 blue:0.2554 alpha:1.0];
    self.captureSession = nil;
    //    //添加扫描view 以及 线框效果
    
    
    [self beginSCanQRCode];
    [self composeQRCodeCatchedUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setUI
- (void)composeQRCodeCatchedUI{
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, QRVIEW_DISTANCE_TOP)];
    self.topView.backgroundColor = [UIColor blackColor];
    self.topView.alpha = TINTCOLOR_ALPHA;
    [self.view addSubview:self.topView];
    
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, QRVIEW_DISTANCE_TOP, (VIEW_WIDTH - SCANVIEW_WITH)/2, SCANVIEW_HEIGHT)];
    self.leftView.backgroundColor = [UIColor blackColor];
    self.leftView.alpha = TINTCOLOR_ALPHA;
    [self.view addSubview:self.leftView];
    
    self.rightView = [[UIView alloc]initWithFrame:CGRectMake((VIEW_WIDTH + SCANVIEW_WITH)/2 , QRVIEW_DISTANCE_TOP, (VIEW_WIDTH - SCANVIEW_WITH)/2, SCANVIEW_HEIGHT)];
    self.rightView.backgroundColor = [UIColor blackColor];
    self.rightView.alpha = TINTCOLOR_ALPHA;
    [self.view addSubview:self.rightView];
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCANVIEW_HEIGHT + QRVIEW_DISTANCE_TOP, VIEW_WIDTH, VIEW_HEIGHT - SCANVIEW_HEIGHT - QRVIEW_DISTANCE_TOP)];
    self.bottomView.backgroundColor = [UIColor blackColor];
    self.bottomView.alpha = TINTCOLOR_ALPHA;
    [self.view addSubview:self.bottomView];
    
    self.scanView = [[UIView alloc]initWithFrame:CGRectMake((VIEW_WIDTH - SCANVIEW_WITH)/2, QRVIEW_DISTANCE_TOP, SCANVIEW_WITH, SCANVIEW_HEIGHT)];
    self.scanView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scanView];
    
    self.subScanView = [[ScanView alloc]initWithFrame:CGRectMake(10, 10, SCANVIEW_WITH - 20, SCANVIEW_HEIGHT - 20)];
    [self.scanView addSubview:self.subScanView];

   
}

#pragma mark - Function
- (void)beginSCanQRCode{
    NSError *error;
    
    //初始化捕捉设备(AVCaptureDevice)
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        //无输入则不继续下面操作
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    
    //创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadtaOutput = [[AVCaptureMetadataOutput alloc]init];
    
    //实例化捕捉会话
    self.captureSession = [[AVCaptureSession alloc] init];
    
    //将输入流添加到会话
    [self.captureSession addInput:input];
    
    //将媒体输出流添加到会话中
    [self.captureSession addOutput:captureMetadtaOutput];
    
    //设置视频输入每帧质量
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    //创建串行队列
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    
    //设置代理
    [captureMetadtaOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    //设置输出媒体数据类型为QRCode
    [captureMetadtaOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, nil]];
    
    //实例化预览图层
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    
    //设置预览图层填充方式
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    
    //设置图层frame
    [self.videoPreviewLayer setFrame:self.view.layer.bounds];
    
    //将图层添加到预览的view图层上
    [self.view.layer addSublayer:self.videoPreviewLayer];
    
    //设置扫描范围
    //相对于session的videoPreviewLayer的frame 的比例  以横屏的!!左上角!!为原点，宽高都是根据横屏比例。
    //videoPreviewLayer 的 VideoGravity 的类型， Aspect 和AspectFill ，上面说的原点取值是以Aspect为准
//    captureMetadtaOutput.rectOfInterest = CGRectMake(0.1, 0.1f, 0.6f, 0.4f);
    captureMetadtaOutput.rectOfInterest = CGRectMake(QRVIEW_DISTANCE_TOP/VIEW_HEIGHT,
                                                     (VIEW_WIDTH - SCANVIEW_WITH)/2/VIEW_WIDTH,
                                                     SCANVIEW_HEIGHT/VIEW_HEIGHT,
                                                     SCANVIEW_WITH/VIEW_WIDTH);


    
    //开始扫描
    [self.captureSession startRunning];
}

//ios6.0 后 是否支持转向
- (BOOL)shouldAutorotate{
    return NO;
}

- (void)stopScanQRCode:(NSString *)resultCode{
    [self.captureSession stopRunning];
    self.captureSession = nil;
    [self.videoPreviewLayer removeFromSuperlayer];
    
    [self.leftView removeFromSuperview];
    [self.topView removeFromSuperview];
    [self.bottomView removeFromSuperview];
    [self.rightView removeFromSuperview];
    [self.scanView removeFromSuperview];
    
    NSString *result = resultCode?:@"";
    NSLog(@"%@", result);
    [self.delegate finishedScanningWithResult:result];
    [self dismissViewControllerAnimated:YES completion:nil];

}




#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [self performSelectorOnMainThread:@selector(stopScanQRCode:) withObject:[metadataObj stringValue] waitUntilDone:YES];
            
        }
    }
}


@end
