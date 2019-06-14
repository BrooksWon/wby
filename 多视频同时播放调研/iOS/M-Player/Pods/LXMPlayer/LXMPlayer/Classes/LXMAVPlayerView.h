//
//  LXMAVPlayerView.h
//  LXMPlayer
//
//  Created by luxiaoming on 2018/8/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, LXMAVPlayerContentMode) {
    LXMAVPlayerContentModeScaleAspectFit = 0,    //AVLayerVideoGravityResizeAspect;
    LXMAVPlayerContentModeScaleAspectFill = 1,   //AVLayerVideoGravityResizeAspectFill;
    LXMAVPlayerContentModeScaleToFill = 2,       //AVLayerVideoGravityResize;
};


/*
 思考了很久，感觉AVFoundation的AVPlayerItemStatus的定义是对的，即AVPlayerItemStatus跟player的status其实不是同一个东西，不应该统一到一起；
 AVPlayerItemStatus表示的是这个item是否可以播放，它只有unknown，readToPlay，fail三种状态，针对的是这个item的可用性；
 而播放器的status可能有unknown,playing，stalling，paused,stopped,failed,等状态，针对的是播放器，是在item可用的前提下才有意义的，播放器当然也可能有fail的情况，但这个fail跟item的fail不一样。
 从这个意义上来说，AVPlayerItemStatus应该是播放器状态内部的一个状态，比如播放器播放失败了，可能是itemStatus是failed，也可能是其他原因。
 */
/*
 在itemStatus变为readyToPlay之前，player的status都应该是Unknown
 */
typedef NS_ENUM(NSInteger, LXMAVPlayerStatus) {
    LXMAVPlayerStatusUnknown = 0,
    LXMAVPlayerStatusStalling,
    LXMAVPlayerStatusPlaying,
    LXMAVPlayerStatusPaused,
    LXMAVPlayerStatusStopped,
    LXMAVPlayerStatusFailed,
    
};


typedef void(^LXMAVPlayerTimeDidChangeBlock)(NSTimeInterval currentTime, NSTimeInterval totalTime);
typedef void(^LXMAVPlayerDidPlayToEndBlock)(AVPlayerItem *item);
typedef void(^LXMAVPlayerStatusDidChangeBlock)(LXMAVPlayerStatus status);
typedef void(^AVPlayerItemReadyToPlayBlock)(void);

@interface  LXMAVPlayerView : UIView

@property (nonatomic, strong, nullable) NSURL *assetURL;
@property (nonatomic, copy) AVLayerVideoGravity videoGravity;

//readonly的属性，方便外部调用
@property (nonatomic, strong, readonly, nullable) AVPlayerItem *playerItem;
@property (nonatomic, assign, readonly) LXMAVPlayerStatus playerStatus;
@property (nonatomic, assign, readonly) NSTimeInterval currentSeconds;//当前播放到的时间，以秒为单位，如果取不到会返回0
@property (nonatomic, assign, readonly) NSTimeInterval totalSeconds;//当前PlayerItem的总时长，以秒为单位，如果取不到会返回0
@property (nonatomic, assign, readonly) BOOL isReadyToPlay; //playerItem的状态是否已经到了readyToPlay，没到之前执行seek操作会crash,内部已经做了判断，如果是false时，不会响应seek操作

//callback
@property (nonatomic, copy, nullable) LXMAVPlayerTimeDidChangeBlock playerTimeDidChangeBlock;
@property (nonatomic, copy, nullable) LXMAVPlayerDidPlayToEndBlock playerDidPlayToEndBlock;
@property (nonatomic, copy, nullable) LXMAVPlayerStatusDidChangeBlock playerStatusDidChangeBlock;
@property (nonatomic, copy, nullable) AVPlayerItemReadyToPlayBlock playerItemReadyToPlayBlock;


#pragma mark - PublicMethod

- (void)play;

- (void)pause;

- (void)stop;

- (void)reset;

- (void)replay;

- (void)seekToTimeAndPlay:(CMTime)time;

- (void)seekToTime:(CMTime)time completion:(void(^)(BOOL finished))completion;

- (nullable UIImage *)thumbnailAtCurrentTime;


@end



/* 遇到的问题
 1，AVPlayerItem cannot service a seek request with a completion handler until its status is AVPlayerItemStatusReadyToPlay.
 所以在seek之前需要判断一下，如果还没有readyToPlay就直接return。
 2，Seeking is not possible to time {INDEFINITE}。
 3，注意AVPlayerLayer会retain其相关的AVPlayer，所以释放的时候，必须主动将AVPlayerView的player设置为nil，否则即使player被设置为nil了，player还是不会释放（因为还有其他地方强引用嘛）
 4, 如果本地保存的文件没有后缀，会报错，打不开：Error Domain=AVFoundationErrorDomain Code=-11828 "Cannot Open" UserInfo={NSLocalizedFailureReason=This media format is not supported., NSLocalizedDescription=Cannot Open, NSUnderlyingError=0x6000012a2730 {Error Domain=NSOSStatusErrorDomain Code=-12847 "(null)"}}
 5，测试的时候发现，在真机上，APP从后台返回前台，会观察到playerItem的status变化，但新旧值都是readToPlay,模拟器上没有这个问题。。。
 */
