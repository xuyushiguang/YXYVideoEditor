//
//  YXYViewController.m
//  YXYVideoModel
//
//  Created by LiuGen on 2018/9/18.
//  Copyright © 2018年 Test. All rights reserved.
//
/**
 视频录制
 
 */
#import "YXYViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface YXYViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    
    UIView *_playView;
    dispatch_queue_t _queue_t;
}
@property (strong,nonatomic) AVCaptureSession *captureSession;//负责输入和输出设置之间的数据传递
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;//视频输出流
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机拍摄预览图层
@property (nonatomic,strong) AVCaptureVideoDataOutput *videoOutput;

@property(nonatomic,strong) AVSampleBufferDisplayLayer *sampleLayer;

@end

@implementation YXYViewController
-(void)applicationFonter
{
    [_sampleLayer flush];
}
-(void)applicationback
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationFonter) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationback) name:UIApplicationDidEnterBackgroundNotification object:nil];
    //
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(0, 0, 100, 50);
    bt.backgroundColor = [UIColor redColor];
    [bt addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
    _playView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:_playView];
    
    _sampleLayer = [AVSampleBufferDisplayLayer layer];
    _sampleLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _sampleLayer.frame = _playView.bounds;
#pragma mark =设置视频方向=
    [_sampleLayer setAffineTransform:CGAffineTransformMakeRotation(M_PI_2)];
    [_playView.layer addSublayer:_sampleLayer];
    
    _captureSession = [[AVCaptureSession alloc] init];
//    _captureSession.sessionPreset = AVCaptureSessionPreset640x480;
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    _captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    [_captureSession addInput:_captureDeviceInput];
   
    // 2.2 获取音频输入设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    // 2.4 创建音频输入源
   AVCaptureDeviceInput * audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice error:nil];
    // 2.6 将音频输入源添加到会话
    if ([_captureSession canAddInput:audioInput]) {
        [_captureSession addInput:audioInput];
    }
    
 
    self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.videoOutput.alwaysDiscardsLateVideoFrames = YES; //立即丢弃旧帧，节省内存，默认YES
    _queue_t = dispatch_queue_create("com.gdu.123", 0);
    [self.videoOutput setSampleBufferDelegate:self queue:_queue_t];
    if ([_captureSession canAddOutput:self.videoOutput]) {
        [_captureSession addOutput:self.videoOutput];
    }
   
    
}
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"===%ld",(long)connection.videoOrientation);
    [_sampleLayer enqueueSampleBuffer:sampleBuffer];
}



-(void)openCamera
{
    [self.captureSession startRunning];
    
}

-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}

#pragma mark =另外一种录制视频=
-(void)builderCamera
{
    _captureSession = [[AVCaptureSession alloc] init];
    _captureSession.sessionPreset = AVCaptureSessionPreset640x480;
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    
    _captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    //添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    AVCaptureDeviceInput *audioCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:nil];
    
    
    //初始化设备输出对象，用于获得输出数据
    _captureMovieFileOutput=[[AVCaptureMovieFileOutput alloc]init];
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
        [_captureSession addInput:audioCaptureDeviceInput];
        AVCaptureConnection *captureConnection=[_captureMovieFileOutput connectionWithMediaType: AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported ]) {
            captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;
        }
    }
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
        [_captureSession addOutput:_captureMovieFileOutput];
    }
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer=[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    
    CALayer *layer=_playView.layer;
    layer.masksToBounds=YES;
    
    _captureVideoPreviewLayer.frame=layer.bounds;
    _captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//填充模式
    //将视频预览层添加到界面中
    [layer addSublayer:_captureVideoPreviewLayer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
