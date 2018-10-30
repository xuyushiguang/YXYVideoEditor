//
//  ViewController.m
//  YXYVideoModel
//邮箱：939607134@qq.com
//  Created by yxy on 2018/9/13.
//  Copyright © 2018年 yxy. All rights reserved.
//
//    AVAsset：素材库里的素材；
//    AVAssetTrack：素材的轨道；
//    AVMutableComposition ：一个用来合成视频的工程文件；
//    AVMutableCompositionTrack ：工程文件中的轨道，有音频轨、视频轨等，里面可以插入各种对应的素材
//    AVMutableVideoCompositionLayerInstruction：视频轨道中的一个视频，可以缩放、旋转等
//    AVMutableVideoCompositionInstruction：一个视频轨道，包含了这个轨道上的所有视频素材
//    AVMutableVideoComposition：管理所有视频轨道，可以决定最终视频的尺寸，裁剪需要在这里进行
//    AVAssetExportSession：配置渲染参数并渲染
//    AVMutableAudioMix 管理所有音频
//    AVMutableAudioMixInputParameters 音频参数设定



#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#define kPathDocument1 [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject]
#define Cache_PATH_IN_DOMAINS [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@" \n  %@",kPathDocument1);
    // !!!: 建议使用模拟器运行这个工程，可以根据打印出来的文件路径(kPathDocument1是上面的宏定义)找到合成的视频文件;
    
    /**
     首先把一段视频放在一个临时文件夹里面(Cache_PATH_IN_DOMAINS是上面的宏定义)，以备后面测试使用;
     最终编辑完成的视频放在（kPathDocument1是上面的宏定义）文件里面，
     */
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"2018" ofType:@"mp4"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *fp = [Cache_PATH_IN_DOMAINS stringByAppendingString:@"/2018.mp4"];
    unlink([fp UTF8String]);
    [data writeToFile:fp atomically:YES];
    
    NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"2017" ofType:@"mp4"];
    NSData *data2 = [NSData dataWithContentsOfFile:filePath2];
    NSString *fp2 = [Cache_PATH_IN_DOMAINS stringByAppendingString:@"/2017.mp4"];
    unlink([fp2 UTF8String]);
    [data2 writeToFile:fp2 atomically:YES];
    
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.backgroundColor = [UIColor redColor];
    bt.frame = CGRectMake(100, 50, 100, 50);
    [bt setTitle:@"2倍快放" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(actionForButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
    UIButton *bt2 = [UIButton buttonWithType:UIButtonTypeCustom];
    bt2.backgroundColor = [UIColor redColor];
    bt2.frame = CGRectMake(100, 120, 100, 50);
    [bt2 setTitle:@"图像旋转" forState:UIControlStateNormal];
    [bt2 addTarget:self action:@selector(actionForButton2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt2];
    
    UIButton *bt3 = [UIButton buttonWithType:UIButtonTypeCustom];
    bt3.backgroundColor = [UIColor redColor];
    bt3.frame = CGRectMake(100, 190, 100, 50);
    [bt3 setTitle:@"视频裁剪" forState:UIControlStateNormal];
    [bt3 addTarget:self action:@selector(actionForButton3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt3];
  
    
    UIButton *bt4 = [UIButton buttonWithType:UIButtonTypeCustom];
    bt4.backgroundColor = [UIColor redColor];
    bt4.frame = CGRectMake(100, 260, 150, 50);
    [bt4 setTitle:@"视频拼接音频" forState:UIControlStateNormal];
    [bt4 addTarget:self action:@selector(actionForButton4) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt4];
    
    UIButton *bt5 = [UIButton buttonWithType:UIButtonTypeCustom];
    bt5.backgroundColor = [UIColor redColor];
    bt5.frame = CGRectMake(100, 330, 100, 50);
    [bt5 setTitle:@"水印" forState:UIControlStateNormal];
    [bt5 addTarget:self action:@selector(actionForButton5) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt5];
    
    
    UIButton *bt6 = [UIButton buttonWithType:UIButtonTypeCustom];
    bt6.backgroundColor = [UIColor redColor];
    bt6.frame = CGRectMake(100, 400, 100, 50);
    [bt6 setTitle:@"滤镜" forState:UIControlStateNormal];
    [bt6 addTarget:self action:@selector(actionForButton6) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt6];
    
    UIButton *bt7 = [UIButton buttonWithType:UIButtonTypeCustom];
    bt7.backgroundColor = [UIColor redColor];
    bt7.frame = CGRectMake(100, 470, 100, 50);
    [bt7 setTitle:@"视频压缩" forState:UIControlStateNormal];
    [bt7 addTarget:self action:@selector(actionForButton7) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt7];
}
#pragma mark =视频压缩=
-(void)actionForButton7
{
    NSString *fp = [Cache_PATH_IN_DOMAINS stringByAppendingString:@"/2018.mp4"];
    //            [data writeToFile:fp atomically:YES];
    NSString *filePath = fp;
    
    //1.将素材拖入到素材库中
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
    
   
    NSString *outputFilePath = [kPathDocument1 stringByAppendingString:@"/2018_7.mp4"];
    unlink([outputFilePath UTF8String]);
    //4.导出
    /**
     AVAssetExportPresetMediumQuality
     AVAssetExportPresetLowQuality
     AAVAssetExportPresetHighestQuality
     三种压缩自己选择
     */
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
   
    exporter.outputURL = [NSURL fileURLWithPath:outputFilePath isDirectory:YES];
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        if (exporter.error) {
            //...
            NSLog(@"error: %@",exporter.error);
        }else{
            //...
            NSLog(@"success");
        }
    }];
    
}

#pragma mark =滤镜=
-(void)actionForButton6
{
    //            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"2018" ofType:@"mp4"];
    //
    //            NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *fp = [Cache_PATH_IN_DOMAINS stringByAppendingString:@"/2018.mp4"];
    //            [data writeToFile:fp atomically:YES];
    NSString *filePath = fp;
    
    //1.将素材拖入到素材库中
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
   
    CIFilter *filter = [CIFilter filterWithName:@"CIMaskToAlpha"];
    //查看有哪些滤镜效果
    //   NSLog(@"%@",[CIFilter filterNamesInCategory:kCICategoryVideo]) ;
    
    /**
     cpu占用200%多，太可怕了。非常耗时间了；
     */
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoCompositionWithAsset:asset applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest * _Nonnull request) {
        CIImage *source = request.sourceImage.imageByClampingToExtent;
        float currentTime = request.compositionTime.value / request.compositionTime.timescale;
        /*
         可以根据currentTime视频时间设置哪些时间段添加滤镜
         **/
        if (currentTime < 3) {
            [request finishWithImage:source context:nil];
        } else {
            [filter setValue:source forKey:kCIInputImageKey];
            //4
            CIImage *output = [filter.outputImage imageByCroppingToRect:request.sourceImage.extent];
            [request finishWithImage:output context:nil];
        }
       
    }];
    

    NSString *outputFilePath = [kPathDocument1 stringByAppendingString:@"/2018_6.mp4"];
    unlink([outputFilePath UTF8String]);
    //4.导出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = videoComposition;
    exporter.outputURL = [NSURL fileURLWithPath:outputFilePath isDirectory:YES];
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        if (exporter.error) {
            //...
            NSLog(@"error: %@",exporter.error);
        }else{
            //...
            NSLog(@"success");
        }
    }];
}

#pragma mark =水印=
-(void)actionForButton5
{
    
    //            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"2018" ofType:@"mp4"];
    //
    //            NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *fp = [Cache_PATH_IN_DOMAINS stringByAppendingString:@"/2018.mp4"];
    //            [data writeToFile:fp atomically:YES];
    NSString *filePath = fp;
    
    //1.将素材拖入到素材库中
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
    //素材的视频轨
    AVAssetTrack *videoAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo]objectAtIndex:0];
    //素材的音频轨
    AVAssetTrack *audioAssertTrack = [[asset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];
    
    //2.将素材的视频插入视频轨，音频插入音频轨
    //这是工程文件
    AVMutableComposition *composition = [AVMutableComposition composition];
    //视频轨道
    AVMutableCompositionTrack *videoCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    //在视频轨道插入一个时间段的视频
    [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];

    //音频轨道
    AVMutableCompositionTrack *audioCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //插入音频数据，否则没有声音
    [audioCompositionTrack insertTimeRange: CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:audioAssertTrack atTime:kCMTimeZero error:nil];

    
    //3.裁剪视频，就是要将所有视频轨进行裁剪，就需要得到所有的视频轨，而得到一个视频轨就需要得到它上面所有的视频素材
    AVMutableVideoCompositionLayerInstruction *videoCompositionLayerIns = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoAssetTrack];
    [videoCompositionLayerIns setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    //得到视频素材（这个例子中只有一个视频）
    AVMutableVideoCompositionInstruction *videoCompositionIns = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    [videoCompositionIns setTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetTrack.timeRange.duration)];
    videoCompositionIns.layerInstructions = @[videoCompositionLayerIns];
   
    //得到视频轨道（这个例子中只有一个轨道）
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.instructions = @[videoCompositionIns];
    videoComposition.renderSize = CGSizeMake(960, 544);
    //裁剪出对应的大小
    videoComposition.frameDuration = CMTimeMake(1, 30);
#pragma mark =添加水印=
    /**
     注意：坐标原点是左下角。
     backgroundLayer 是水印layer，可以添加动画，[layer1 addAnimation: CABaseAnimation forKey: nil];layer能做的事情都可以。
     parentLayer 的frame和视频的大小要一样，是存放水印layer和视频layer的视图；
     videoLayer  的frame和视频的大小要一样,videolayer是用来播放视频的图层，如果想设置成九个画面，可以创建
     九个videolayer，修改frame的位置，一定要把videolayer添加到parentlayer上；然后调用+ (instancetype)videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayers:(NSArray<CALayer *> *)videoLayers inLayer:(CALayer *)animationLayer
     这个方法第一个参数是数组，用来存放videolayer的，下面的用例我在屏幕上播放两个画面。你可以去掉注释尝试一下。
     **/
    UIImage *img = [UIImage imageNamed:@"ico.jpeg"];
    CALayer *backgroundLayer = [CALayer layer];
    [backgroundLayer setContents:(id)[img CGImage]];
    backgroundLayer.frame = CGRectMake(CGSizeMake(960, 544).width-img.size.width, 0, img.size.width, img.size.height);
    [backgroundLayer setMasksToBounds:YES];
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    
    parentLayer.frame = CGRectMake(0, 0, CGSizeMake(960, 544).width, CGSizeMake(960, 544).height);
    videoLayer.frame = CGRectMake(0, 0, CGSizeMake(960, 544).width, CGSizeMake(960, 544).height);
    
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:backgroundLayer];
    //单个画面播放
    videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    //去掉注释，试试两个画面播放，注意要修改videolayer的frame，否则会被遮挡
//    CALayer *videoLayer2 = [CALayer layer];
//    videoLayer2.frame = CGRectMake(CGSizeMake(960, 544).width/2, 0, CGSizeMake(960, 544).width/2, CGSizeMake(960, 544).height);
//    [parentLayer addSublayer:videoLayer2];
//    videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayers:@[videoLayer,videoLayer2] inLayer:parentLayer];
    
    
    NSString *outputFilePath = [kPathDocument1 stringByAppendingString:@"/2018_5.mp4"];
    unlink([outputFilePath UTF8String]);
    //4.导出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = videoComposition;
    exporter.outputURL = [NSURL fileURLWithPath:outputFilePath isDirectory:YES];
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        if (exporter.error) {
            //...
            NSLog(@"error: %@",exporter.error);
        }else{
            //...
            NSLog(@"success");
        }
    }];
}

#pragma mark =视频拼接=
-(void)actionForButton4
{
    //            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"2018" ofType:@"mp4"];
    //
    //            NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *fp = [Cache_PATH_IN_DOMAINS stringByAppendingString:@"/2018.mp4"];
    NSString *fp2 = [Cache_PATH_IN_DOMAINS stringByAppendingString:@"/2017.mp4"];
    //            [data writeToFile:fp atomically:YES];
    NSString *filePath = fp;
    NSString *filePath2 = fp2;
    
    NSDictionary *opstDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    
    //1.将素材拖入到素材库中
    AVAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:filePath] options:opstDict];
    AVAsset *asset2 = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:filePath2] options:opstDict];
    
    //素材的视频轨
    AVAssetTrack *videoAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo]objectAtIndex:0];
    //素材的音频轨
    AVAssetTrack *audioAssertTrack = [[asset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];
    
    //素材的视频轨
    AVAssetTrack *videoAssetTrack2 = [[asset2 tracksWithMediaType:AVMediaTypeVideo]objectAtIndex:0];
    
    //素材的音频轨
//    AVAssetTrack *audioAssertTrack2 = [[asset2 tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];
    
    //2.将素材的视频插入视频轨，音频插入音频轨
    //这是工程文件
    AVMutableComposition *composition = [AVMutableComposition composition];
    //视频轨道
    AVMutableCompositionTrack *videoCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
#pragma mark =视频轨道合并=
    //在视频轨道插入一个时间段的视频
    //由于没有计算当前CMTime的起始位置，现在插入0的位置,所以合并出来的视频是后添加在前面，
    [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset2.duration) ofTrack:videoAssetTrack2 atTime:kCMTimeZero error:nil];
    [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];
#pragma mark =音频轨道合并=
    //音频轨道
    AVMutableCompositionTrack *audioCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //插入音频数据，否则没有声音
    [audioCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset2.duration) ofTrack:audioAssertTrack atTime:kCMTimeZero error:nil];
    [audioCompositionTrack insertTimeRange: CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:audioAssertTrack atTime:kCMTimeZero error:nil];
    
    
    //3.裁剪视频，就是要将所有视频轨进行裁剪，就需要得到所有的视频轨，而得到一个视频轨就需要得到它上面所有的视频素材
    AVMutableVideoCompositionLayerInstruction *videoCompositionLayerIns = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoAssetTrack];
    /**
     两个视频合并成一个的时候，如果都在一个视频轨道上面，在这里设置旋转和缩放，整个轨道上的视频都会变化。所以想要添加功能，就分时间段
     设置。- (void)setTransformRampFromStartTransform:(CGAffineTransform)startTransform toEndTransform:(CGAffineTransform)endTransform timeRange:(CMTimeRange)timeRange
     */
    [videoCompositionLayerIns setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
   
//    [videoCompositionLayerIns setTransformRampFromStartTransform:CGAffineTransformIdentity toEndTransform:CGAffineTransformMakeRotation(M_PI_4) timeRange:CMTimeRangeMake(CMTimeMake(7*30, 30), CMTimeMake(1*30, 30))];
    
    //得到视频素材
    AVMutableVideoCompositionInstruction *videoCompositionIns = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
#pragma mark =视频的总时间=
    /**
     总时间是两段视频时间总和
     **/
    [videoCompositionIns setTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeAdd(videoAssetTrack.timeRange.duration, videoAssetTrack2.timeRange.duration))];
    videoCompositionIns.layerInstructions = @[videoCompositionLayerIns];
    //得到视频轨道（这个例子中只有一个轨道）
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.instructions = @[videoCompositionIns];
    videoComposition.renderSize = CGSizeMake(960, 544);
    //裁剪出对应的大小
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    
    NSString *outputFilePath = [kPathDocument1 stringByAppendingString:@"/2018_4.mp4"];
    unlink([outputFilePath UTF8String]);
    //4.导出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = videoComposition;
    exporter.outputURL = [NSURL fileURLWithPath:outputFilePath isDirectory:YES];
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        if (exporter.error) {
            //...
            NSLog(@"error: %@",exporter.error);
        }else{
            //...
            NSLog(@"success");
        }
    }];
}

#pragma mark =视频裁剪=
-(void)actionForButton3
{
    
    //            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"2018" ofType:@"mp4"];
    //
    //            NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *fp = [Cache_PATH_IN_DOMAINS stringByAppendingString:@"/2018.mp4"];
    //            [data writeToFile:fp atomically:YES];
    NSString *filePath = fp;
    
    //1.将素材拖入到素材库中
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:filePath]];

    
    NSString *outputFilePath = [kPathDocument1 stringByAppendingString:@"/2018_3.mp4"];
    unlink([outputFilePath UTF8String]);
    //4.导出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];

    exporter.outputURL = [NSURL fileURLWithPath:outputFilePath isDirectory:YES];
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
#pragma mark =在这里裁剪=
    /**
     需要裁剪的时间段，
     */
    exporter.timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(0, asset.duration.timescale), CMTimeMakeWithSeconds(4, asset.duration.timescale));
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        if (exporter.error) {
            //...
            NSLog(@"error: %@",exporter.error);
        }else{
            //...
            NSLog(@"success");
        }
    }];
}

#pragma mark =图像旋转=
-(void)actionForButton2
{
    //            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"2018" ofType:@"mp4"];
    //
    //            NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *fp = [Cache_PATH_IN_DOMAINS stringByAppendingString:@"/2018.mp4"];
    //            [data writeToFile:fp atomically:YES];
    NSString *filePath = fp;
    
    //1.将素材拖入到素材库中
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
    //素材的视频轨
    AVAssetTrack *videoAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo]objectAtIndex:0];
    //素材的音频轨
    AVAssetTrack *audioAssertTrack = [[asset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];
    
    //2.将素材的视频插入视频轨，音频插入音频轨
    //这是工程文件
    AVMutableComposition *composition = [AVMutableComposition composition];
    //视频轨道
    AVMutableCompositionTrack *videoCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    //在视频轨道插入一个时间段的视频
    [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];
//    [videoCompositionTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) toDuration:CMTimeMake(asset.duration.value/2, asset.duration.timescale)];
    //音频轨道
    AVMutableCompositionTrack *audioCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //插入音频数据，否则没有声音
    [audioCompositionTrack insertTimeRange: CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:audioAssertTrack atTime:kCMTimeZero error:nil];

//    [audioCompositionTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) toDuration:CMTimeMake(asset.duration.value/2, asset.duration.timescale)];
    
    //3.裁剪视频，就是要将所有视频轨进行裁剪，就需要得到所有的视频轨，而得到一个视频轨就需要得到它上面所有的视频素材
    AVMutableVideoCompositionLayerInstruction *videoCompositionLayerIns = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoAssetTrack];
//    [videoCompositionLayerIns setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
#pragma mark =图像旋转=
    /**
     StartTransform：开始旋转的角度，我这里是0度
     EndTransform：最终的角度，我这里是顺时针45度，
     timeRange：旋转持续的时间，CMTimeRangeMake(CMTimeMake(4*30, 30), CMTimeMake(1*30, 30))第一个参数CMTimeMake(4*30, 30)表示在视频第四秒的时候开始开始旋转，第二个参数CMTimeMake(1*30, 30)表示旋转的过程持续的时间，我的是1秒，视频图像旋转是个动画的
     过程，会在1秒内完成。如果第二个参数改成CMTimeMake(2*30, 30)，则图像在2秒内完成旋转。
     注意:图像旋转的锚点是在左上角。
     */
    [videoCompositionLayerIns setTransformRampFromStartTransform:CGAffineTransformIdentity toEndTransform:CGAffineTransformMakeRotation(M_PI_4) timeRange:CMTimeRangeMake(CMTimeMake(4*30, 30), CMTimeMake(1*30, 30))];
    /**
     设置透明度，0~1.0之间，值越小，图像越黑暗，
     **/
//    [videoCompositionLayerIns setOpacity:0.1 atTime:kCMTimeZero];
    /**
     裁剪视频，根据参数CGRect裁剪相同大小的矩形图像。只是图像裁剪，并不是视频时间长度的裁剪。
     注意：此方法和AVMutableVideoComposition的renderSize属性并不一样，renderSize裁剪的是整个视频的大小，而CGRect裁剪
     之外的地方图像是黑色的。
     **/
//    [videoCompositionLayerIns setCropRectangle:CGRectMake(0, 0, 100, 100) atTime:kCMTimeZero];
    
    
    //得到视频素材（这个例子中只有一个视频）
    AVMutableVideoCompositionInstruction *videoCompositionIns = [AVMutableVideoCompositionInstruction videoCompositionInstruction];[videoCompositionIns setTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetTrack.timeRange.duration)];
    videoCompositionIns.layerInstructions = @[videoCompositionLayerIns];
    //得到视频轨道（这个例子中只有一个轨道）
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.instructions = @[videoCompositionIns];
    videoComposition.renderSize = CGSizeMake(960, 544);
    //裁剪出对应的大小
    videoComposition.frameDuration = CMTimeMake(1, 30);
    

    NSString *outputFilePath = [kPathDocument1 stringByAppendingString:@"/2018_2.mp4"];
    unlink([outputFilePath UTF8String]);
    //4.导出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = videoComposition;
    exporter.outputURL = [NSURL fileURLWithPath:outputFilePath isDirectory:YES];
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        if (exporter.error) {
            //...
            NSLog(@"error: %@",exporter.error);
        }else{
            //...
            NSLog(@"success");
        }
    }];
    
}

#pragma mark =2倍快放=
-(void)actionForButton
{
    
//            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"2018" ofType:@"mp4"];
    //
//            NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *fp = [Cache_PATH_IN_DOMAINS stringByAppendingString:@"/2018.mp4"];
//            [data writeToFile:fp atomically:YES];
    NSString *filePath = fp;
    
    //1.将素材拖入到素材库中
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
    //素材的视频轨
    AVAssetTrack *videoAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo]objectAtIndex:0];
    //素材的音频轨
    AVAssetTrack *audioAssertTrack = [[asset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];
    
    //2.将素材的视频插入视频轨，音频插入音频轨
    //这是工程文件
    AVMutableComposition *composition = [AVMutableComposition composition];
    //视频轨道
    AVMutableCompositionTrack *videoCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    //在视频轨道插入一个时间段的视频
    [videoCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];
#pragma mark 在这里修改快放速度
    [videoCompositionTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) toDuration:CMTimeMake(asset.duration.value/2, asset.duration.timescale)];
    //音频轨道
    AVMutableCompositionTrack *audioCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //插入音频数据，否则没有声音
    [audioCompositionTrack insertTimeRange: CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:audioAssertTrack atTime:kCMTimeZero error:nil];
#pragma mark 在这里修改快放速度
    [audioCompositionTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) toDuration:CMTimeMake(asset.duration.value/2, asset.duration.timescale)];
    
    //3.裁剪视频，就是要将所有视频轨进行裁剪，就需要得到所有的视频轨，而得到一个视频轨就需要得到它上面所有的视频素材
    AVMutableVideoCompositionLayerInstruction *videoCompositionLayerIns = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoAssetTrack];
    [videoCompositionLayerIns setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    //得到视频素材（这个例子中只有一个视频）
    AVMutableVideoCompositionInstruction *videoCompositionIns = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    [videoCompositionIns setTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetTrack.timeRange.duration)];
    videoCompositionIns.layerInstructions = @[videoCompositionLayerIns];
    //得到视频轨道（这个例子中只有一个轨道）
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.instructions = @[videoCompositionIns];
    videoComposition.renderSize = CGSizeMake(960, 544);
    //裁剪出对应的大小
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    NSString *outputFilePath = [kPathDocument1 stringByAppendingString:@"/2018_1.mp4"];
    unlink([outputFilePath UTF8String]);
    //4.导出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = videoComposition;
    exporter.outputURL = [NSURL fileURLWithPath:outputFilePath isDirectory:YES];
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        if (exporter.error) {
            //...
            NSLog(@"error: %@",exporter.error);
        }else{
            //...
            NSLog(@"success");
        }
    }];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
