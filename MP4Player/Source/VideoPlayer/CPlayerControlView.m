//
//  CPlayerControlView.m
//  CVideoPlayer
//
//  Created by Chentao on 16/7/26.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "CPlayerControlView.h"
#import "CVideoPlayerSliderView.h"
#import "CVideoPlayerSpeedMenuView.h"
#import "NSObject+CEventDispatcher.h"

@interface CPlayerControlView () <CVideoPlayerSliderViewDelegate, BoxDelegate>

@property (nonatomic, strong) UIView *gestureRecognizerView;

@property (nonatomic, strong) UIView *loadingView;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) Group *titleBar;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) Group *controlBar;

@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) CVideoPlayerSliderView *progressSlider;

@property (nonatomic, strong) Group *timeTipView;

@property (nonatomic, strong) UIImageView *timeTipIconView;

@property (nonatomic, strong) UILabel *timeTipLabel;

@property (nonatomic, strong) UIButton *speedButton; //加速按钮

//@property (nonatomic, strong) UIButton *speedDownButton; //减速按钮

@property (nonatomic, strong) UILabel *currentTimeLabel;

@property (nonatomic, strong) UILabel *durationTimeLabel;

@property (nonatomic, strong) CVideoPlayerSpeedMenuView *speedMenu;

@property (nonatomic, strong) NSMutableArray<CVideoPlayerSpeedMenuItem *> *speedArray;

@property (nonatomic, strong) NSTimer *controlBarHidenTimer;

@end

@implementation CPlayerControlView {
    CGPoint startPanPoint;
    CGPoint beginPanPoint;
    BOOL startPan;
    BOOL controlBarHiden;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
        [self initData];
    }
    return self;
}

- (void)initData {
    NSArray *speeds = [NSArray arrayWithObjects:
                       [NSNumber numberWithFloat:1.8],
                       [NSNumber numberWithFloat:1.6],
                       [NSNumber numberWithFloat:1.4],
                       [NSNumber numberWithFloat:1.2],
                       [NSNumber numberWithFloat:1.0], nil];
    self.speedArray = [NSMutableArray arrayWithCapacity:speeds.count];

    CVideoPlayerSpeedMenuItem *defaultSelecteItem;

    for (NSInteger index = 0; index < speeds.count; index++) {
        CVideoPlayerSpeedMenuItem *item = [[CVideoPlayerSpeedMenuItem alloc] init];
        NSNumber *speedNumber = [speeds objectAtIndex:index];
        item.speed = [speedNumber floatValue];
        if (1.0 == item.speed) {
            defaultSelecteItem = item;
        }
        [self.speedArray addObject:item];
    }
    self.speedMenu.speedArray = self.speedArray;

    defaultSelecteItem.selected = YES;
    [self setSpeedButtonTitle:defaultSelecteItem];
}

- (Group *)timeTipView {
    if (!_timeTipView) {

        CGFloat tipViewWidth = 178;
        CGFloat tipViewHeight = 128;
        CGFloat radius = 5.0;

        _timeTipView = [[Group alloc] init];
        _timeTipView.backgroundColor=[ColorMake(0x000000) colorWithAlphaComponent:0.7];
        _timeTipView.layer.cornerRadius = 10.0;
        _timeTipView.layer.shadowColor =ColorMake(0x000000).CGColor;
        _timeTipView.layer.shadowOpacity = 0.2f;
        _timeTipView.layer.shadowOffset = CGSizeMake(0, 2);

        _timeTipView.layout_height = tipViewHeight;
        _timeTipView.layout_width = tipViewWidth;
        _timeTipView.layer.cornerRadius = radius;
        _timeTipView.clipsToBounds = YES;
        _timeTipView.includeInLayout = YES;
        _timeTipView.layout_verticalCenter = [NSNumber numberWithFloat:0.0];
        _timeTipView.layout_horizontalCenter = [NSNumber numberWithFloat:0.0];

        [_timeTipView addSubview:self.timeTipIconView];
        [_timeTipView addSubview:self.timeTipLabel];
    }
    return _timeTipView;
}


- (UIImageView *)timeTipIconView {
    if (!_timeTipIconView) {
        _timeTipIconView = [[UIImageView alloc] init];
        _timeTipIconView.contentMode = UIViewContentModeScaleAspectFit;
        _timeTipIconView.image = [UIImage imageNamed:@"videoplayer_playbutton_normal"];
        _timeTipIconView.layout_width = 90;
        _timeTipIconView.layout_height = 66;
        _timeTipIconView.includeInLayout = YES;
        _timeTipIconView.layout_top = [NSNumber numberWithFloat:16.0];
        _timeTipIconView.layout_horizontalCenter = [NSNumber numberWithFloat:0.0];
    }
    return _timeTipIconView;
}

- (UILabel *)timeTipLabel {
    if (!_timeTipLabel) {
        _timeTipLabel = [[UILabel alloc] init];
        _timeTipLabel.layout_height = 25;
        _timeTipLabel.textAlignment = NSTextAlignmentCenter;
        _timeTipLabel.textColor = ColorMake(0xFFFFFF);
        _timeTipLabel.font = FontMake(14);
        _timeTipLabel.includeInLayout = YES;
        _timeTipLabel.layout_left = [NSNumber numberWithFloat:5.0];
        _timeTipLabel.layout_right = [NSNumber numberWithFloat:5.0];
        _timeTipLabel.layout_top = [NSNumber numberWithFloat:91.0];
    }
    return _timeTipLabel;
}

- (void)createSubviews {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerHandler)];
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognizerHandler:)];

    self.gestureRecognizerView = [[UIView alloc] init];
    [self.gestureRecognizerView addGestureRecognizer:tapRecognizer];
    [self.gestureRecognizerView addGestureRecognizer:panRecognizer];
    self.gestureRecognizerView.backgroundColor = [ColorMake(0x000000) colorWithAlphaComponent:0.0];
    self.gestureRecognizerView.includeInLayout = YES;
    self.gestureRecognizerView.layout_left = [NSNumber numberWithFloat:0.0];
    self.gestureRecognizerView.layout_right = [NSNumber numberWithFloat:0.0];
    self.gestureRecognizerView.layout_bottom = [NSNumber numberWithFloat:0.0];
    self.gestureRecognizerView.layout_top = [NSNumber numberWithFloat:0.0];
    [self addSubview:self.gestureRecognizerView];

    self.loadingView = [[Group alloc] init];
    self.loadingView.backgroundColor = ColorMake(0xFFFFFF);
    self.loadingView.alpha = 0;
    self.loadingView.hidden = YES;
    self.loadingView.includeInLayout = YES;
    self.loadingView.layout_left = [NSNumber numberWithFloat:0.0];
    self.loadingView.layout_right = [NSNumber numberWithFloat:0.0];
    self.loadingView.layout_bottom = [NSNumber numberWithFloat:0.0];
    self.loadingView.layout_top = [NSNumber numberWithFloat:0.0];
    [self addSubview:self.loadingView];

    self.indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.indicatorView.includeInLayout = YES;
    self.indicatorView.layout_verticalCenter = [NSNumber numberWithFloat:0.0];
    self.indicatorView.layout_horizontalCenter = [NSNumber numberWithFloat:0.0];
    [self.indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.loadingView addSubview:self.indicatorView];

    CGFloat titleBarHeight = 44.0;

    self.titleBar = [[Group alloc] init];
    self.titleBar.backgroundColor = [ColorMake(0xFFFFFF) colorWithAlphaComponent:0.8];
    self.titleBar.layout_height = titleBarHeight;
    self.titleBar.includeInLayout = YES;
    self.titleBar.layout_top = [NSNumber numberWithFloat:0.0];
    self.titleBar.layout_left = [NSNumber numberWithFloat:0.0];
    self.titleBar.layout_right = [NSNumber numberWithFloat:0.0];

    UIButton *backButton = [[UIButton alloc] init];
    [backButton addTarget:self action:@selector(backButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"videoplayer_backbutton"] forState:UIControlStateNormal];
    backButton.layout_width = 36;
    backButton.layout_height = 36;
    backButton.includeInLayout = YES;
    backButton.layout_verticalCenter = [NSNumber numberWithFloat:0.0];
    backButton.layout_left = [NSNumber numberWithFloat:4.0];
    [self.titleBar addSubview:backButton];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = ColorMake(0x000000);
    self.titleLabel.font =BoldFontMake(16);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.includeInLayout = YES;
    self.titleLabel.layout_left = [NSNumber numberWithFloat:50.0];
    self.titleLabel.layout_right = [NSNumber numberWithFloat:50.0];
    self.titleLabel.layout_top = [NSNumber numberWithFloat:5.0];
    self.titleLabel.layout_bottom = [NSNumber numberWithFloat:5.0];
    [self.titleBar addSubview:self.titleLabel];

    UIView *titleBottomLine = [[UIView alloc] init];
    titleBottomLine.layout_height = 0.5;
    titleBottomLine.backgroundColor = [ColorMake(0x000000) colorWithAlphaComponent:0.2];
    titleBottomLine.includeInLayout = YES;
    titleBottomLine.layout_bottom = [NSNumber numberWithFloat:0.0];
    titleBottomLine.layout_left = [NSNumber numberWithFloat:0.0];
    titleBottomLine.layout_right = [NSNumber numberWithFloat:0.0];
    [self.titleBar addSubview:titleBottomLine];

    [self addSubview:self.titleBar];

    CGFloat controlBarHeight = 45;

    self.controlBar = [[Group alloc] init];
    self.controlBar.backgroundColor = [ColorMake(0x000000) colorWithAlphaComponent:0.8];
    self.controlBar.layout_height = controlBarHeight;
    self.controlBar.includeInLayout = YES;
    self.controlBar.layout_left = [NSNumber numberWithFloat:0.0];
    self.controlBar.layout_right = [NSNumber numberWithFloat:0.0];
    self.controlBar.layout_bottom = [NSNumber numberWithFloat:0.0];


    self.currentTimeLabel = [[UILabel alloc] init];
    self.currentTimeLabel.text = @"00:00:00";
    self.currentTimeLabel.layout_height = 25;
    self.currentTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.currentTimeLabel.textColor = ColorMake(0xFFFFFF);
    self.currentTimeLabel.font = FontMake(12);
    self.currentTimeLabel.includeInLayout = YES;
    self.currentTimeLabel.layout_left = [NSNumber numberWithFloat:50.0];
    self.currentTimeLabel.layout_right = [NSNumber numberWithFloat:5.0];
    self.currentTimeLabel.layout_verticalCenter = [NSNumber numberWithFloat:0.0];
    [self.controlBar addSubview:self.currentTimeLabel];

    self.durationTimeLabel = [[UILabel alloc] init];
    self.durationTimeLabel.text = @"00:00:00";
    self.durationTimeLabel.layout_height = 25;
    self.durationTimeLabel.textAlignment = NSTextAlignmentRight;
    self.durationTimeLabel.textColor = ColorMake(0xFFFFFF);
    self.durationTimeLabel.font = FontMake(12);
    self.durationTimeLabel.includeInLayout = YES;
    self.durationTimeLabel.layout_left = [NSNumber numberWithFloat:5.0];
    self.durationTimeLabel.layout_right = [NSNumber numberWithFloat:80.0];
    self.durationTimeLabel.layout_verticalCenter = [NSNumber numberWithFloat:0.0];
    [self.controlBar addSubview:self.durationTimeLabel];

    self.playButton = [[UIButton alloc] init];
    [self.playButton setImage:[UIImage imageNamed:@"videoplayer_playbutton_normal"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"videoplayer_playbutton_pause"] forState:UIControlStateSelected];
    [self.playButton addTarget:self action:@selector(playButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    self.playButton.layout_height = 36;
    self.playButton.layout_width = 36;
    self.playButton.includeInLayout = YES;
    self.playButton.layout_left = [NSNumber numberWithFloat:8.0];
    self.playButton.layout_verticalCenter = [NSNumber numberWithFloat:0.0];
    [self.controlBar addSubview:self.playButton];    
    
    UITapGestureRecognizer *speedButtonGroupTapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(speedButtonTouchHandler)];
    
    Group *speedButtonGroup=[[Group alloc]init];
    speedButtonGroup.backgroundColor=[ColorMake(0x000000) colorWithAlphaComponent:0.0];
    speedButtonGroup.userInteractionEnabled=YES;
    [speedButtonGroup addGestureRecognizer:speedButtonGroupTapRecognizer];
    speedButtonGroup.layout_height = 40;
    speedButtonGroup.layout_width = 76;
    speedButtonGroup.includeInLayout = YES;
    speedButtonGroup.layout_right = [NSNumber numberWithFloat:0.0];
    speedButtonGroup.layout_verticalCenter = [NSNumber numberWithFloat:0.0];
    [self.controlBar addSubview:speedButtonGroup];
    
    
    self.speedButton = [[UIButton alloc] init];
    self.speedButton.userInteractionEnabled=NO;
    [self.speedButton setTitleColor:ColorMake(0xFAC842) forState:UIControlStateNormal];
    self.speedButton.titleLabel.font = FontMake(12);
    self.speedButton.backgroundColor = [ColorMake(0x000000) colorWithAlphaComponent:0.6];
    //[self.speedButton addTarget:self action:@selector(speedButtonTouchHandler) forControlEvents:UIControlEventTouchUpInside];
    self.speedButton.layout_height = 28;
    self.speedButton.layout_width = 60;
    self.speedButton.layer.cornerRadius = 0.5 * self.speedButton.layout_height;
    self.speedButton.clipsToBounds = YES;
    self.speedButton.includeInLayout = YES;
    self.speedButton.layout_horizontalCenter = [NSNumber numberWithFloat:0.0];
    self.speedButton.layout_verticalCenter = [NSNumber numberWithFloat:0.0];
    [speedButtonGroup addSubview:self.speedButton];

    self.progressSlider = [[CVideoPlayerSliderView alloc] init];
    self.progressSlider.progressHeight = 2;
    self.progressSlider.delegate = self;
    self.progressSlider.userInteractionEnabled = YES;
    self.progressSlider.includeInLayout = YES;
    self.progressSlider.layout_left = [NSNumber numberWithFloat:113.0];
    self.progressSlider.layout_right = [NSNumber numberWithFloat:142.0];
    self.progressSlider.layout_top = [NSNumber numberWithFloat:0.0];
    self.progressSlider.layout_bottom = [NSNumber numberWithFloat:0.0];
    [self.controlBar addSubview:self.progressSlider];

    [self addSubview:self.controlBar];

    self.speedMenu = [[CVideoPlayerSpeedMenuView alloc] init];
    self.speedMenu.hidden = YES;
    [self.speedMenu addEventListenerWithType:CVideoPlayerSpeedMenuView_DidSelected target:self action:@selector(speedMenuDidSelectedHandler:)];
    self.speedMenu.boxDelegate = self;
    self.speedMenu.includeInLayout = YES;
    self.speedMenu.layout_right = [NSNumber numberWithFloat:8.0];
    self.speedMenu.layout_bottom = [NSNumber numberWithFloat:controlBarHeight];
    self.speedMenu.measureSizes = YES;
    [self addSubview:self.speedMenu];
}

- (void)backButtonTouchHandler:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerControlViewBackButtonOnTouch:)]) {
        [self.delegate playerControlViewBackButtonOnTouch:self];
    }
}

- (void)speedMenuDidSelectedHandler:(CEvent *)event {
    CVideoPlayerSpeedMenuItem *item = event.data;
    [self setSpeedButtonTitle:item];

    if (self.delegate && [self.delegate respondsToSelector:@selector(playerControlView:rateChange:)]) {
        [self.delegate playerControlView:self rateChange:item.speed];
    }

    [self.speedMenu hidenMenuView];
}

- (void)setSpeedButtonTitle:(CVideoPlayerSpeedMenuItem *)item {
    NSString *titleText = [NSString stringWithFormat:@"x%.1f", item.speed];
    [self.speedButton setTitle:titleText forState:UIControlStateNormal];
}

- (void)playButtonTouchHandler {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerControlViewPlayButtonTouch:)]) {
        [self.delegate playerControlViewPlayButtonTouch:self];
    }
}

- (void)speedButtonTouchHandler {
    [self restTimer];
    if (self.speedMenu.show) {
        [self.speedMenu hidenMenuView];
    } else {
        [self.speedMenu showMenuView];
    }
}

- (void)showOrHidenControlBar {
    if (!controlBarHiden) {
        [self hidenControlBarAnimation];
    } else {
        [self showControlBarAnimation];
    }
}

- (void)showControlBarAnimation {
    //显示
    self.controlBar.alpha = 0;
    self.titleBar.alpha = 0;
    [self hidenControlBar:NO];
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3
    animations:^{
        weakSelf.controlBar.alpha = 1;
        weakSelf.titleBar.alpha = 1;
    }
    completion:^(BOOL finished) {
        controlBarHiden = NO;
        [self restTimer];
    }];
}

- (void)hidenControlBarAnimation {
    //隐藏
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3
    animations:^{
        weakSelf.controlBar.alpha = 0;
        weakSelf.titleBar.alpha = 0;
    }
    completion:^(BOOL finished) {
        [weakSelf hidenControlBar:YES];
        controlBarHiden = YES;
    }];

    if (self.speedMenu.show) {
        [self.speedMenu hidenMenuView];
    }
}

- (void)hidenControlBar:(BOOL)hiden {
    self.controlBar.hidden = hiden;
    self.titleBar.hidden = hiden;
    // self.speedMenu.hidden = hiden;
}

- (void)startTimer {
    if (self.controlBarHidenTimer) {
        [self.controlBarHidenTimer invalidate];
    }
    self.controlBarHidenTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(controlBarHidenTimerHandler) userInfo:nil repeats:NO];
}

- (void)restTimer {
    [self startTimer];
}

- (void)stopTimer {
    if (self.controlBarHidenTimer) {
        [self.controlBarHidenTimer invalidate];
        self.controlBarHidenTimer = nil;
    }
}

- (void)controlBarHidenTimerHandler {
    self.controlBarHidenTimer = nil;
    if (!controlBarHiden) {
        [self hidenControlBarAnimation];
    }
}

- (void)tapRecognizerHandler {
    [self showOrHidenControlBar];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (!controlBarHiden) {
        [self restTimer];
    }
}

- (void)panRecognizerHandler:(UIPanGestureRecognizer *)recognizer {
    CGPoint newPanPoint = [recognizer locationInView:recognizer.view];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            beginPanPoint = newPanPoint;
            startPanPoint = newPanPoint;
            //            if (self.delegate && [self.delegate respondsToSelector:@selector(playerControlViewBeginPan:)]) {
            //                [self.delegate playerControlViewBeginPan:self];
            //            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            float diffX = fabs(newPanPoint.x - startPanPoint.x);
            float diffY = fabs(newPanPoint.y - startPanPoint.y);
            //            CLogDebug(@"diffX:%f   diffY:%f ", diffX, diffY);

            if (diffX > 5 * diffY) {
                if (!startPan) {
                    startPan = YES;
                    if (self.delegate && [self.delegate respondsToSelector:@selector(playerControlViewBeginPan:)]) {
                        [self.delegate playerControlViewBeginPan:self];
                    }
                }

                if (startPan) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(playerControlView:panDirection:offsetX:)]) {

                        CGFloat offsetSpace = 0;

                        CGFloat offsetX = newPanPoint.x - beginPanPoint.x;

                        //                    CLogDebug(@"offsetX:%f",offsetX);

                        if (offsetX > offsetSpace) {
                            [self.delegate playerControlView:self panDirection:CPlayerControlPanDirectionRight offsetX:fabs(offsetX)];
                        }

                        if (offsetX < offsetSpace) {
                            [self.delegate playerControlView:self panDirection:CPlayerControlPanDirectionLeft offsetX:fabs(offsetX)];
                        }
                    }
                }
            }

            break;
        }

        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            startPan = NO;
            if (self.delegate && [self.delegate respondsToSelector:@selector(playerControlViewEndPan:)]) {
                [self.delegate playerControlViewEndPan:self];
            }
            break;
        }

        default: {
            startPan = NO;
            if (self.delegate && [self.delegate respondsToSelector:@selector(playerControlViewEndPan:)]) {
                [self.delegate playerControlViewEndPan:self];
            }
            break;
        }
    }

    beginPanPoint = newPanPoint;
    if (!controlBarHiden) {
        [self restTimer];
    }
}

/**
 *  调用此方法播放按钮显示为暂停状态
 */
- (void)play {
    self.playButton.selected = YES;
}

/**
 *  调用此方法播放按钮显示为播放状态
 */
- (void)pause {
    self.playButton.selected = NO;
}

- (void)setProgress:(float)progress {
    self.progressSlider.sliderValue = progress;
}

- (float)progress {
    return self.progressSlider.sliderValue;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (NSString *)title {
    return self.titleLabel.text;
}

#pragma mark -video loading
- (void)showVideoLoading {
    self.loadingView.alpha = 1.0;
    self.loadingView.hidden = NO;
    [self.indicatorView startAnimating];
}

- (void)hidenVideoLoading {
    [self.indicatorView stopAnimating];

    [UIView animateWithDuration:0.3
    animations:^{
        self.loadingView.alpha = 0.0;
    }
    completion:^(BOOL finished) {
        self.loadingView.hidden = YES;
    }];
}

#pragma mark -CVideoPlayerSliderViewDelegate

- (void)sliderView:(CVideoPlayerSliderView *)sliderView startDragValue:(float)value {
    // NSLog(@"%s  %f", __FUNCTION__, value);
    [self restTimer];
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerControlView:beginDragProgress:)]) {
        [self.delegate playerControlView:self beginDragProgress:value];
    }
}

- (void)sliderView:(CVideoPlayerSliderView *)sliderView moveDragValue:(float)value {
    // NSLog(@"%s  %f", __FUNCTION__, value);
    [self restTimer];
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerControlView:moveDragProgress:)]) {
        [self.delegate playerControlView:self moveDragProgress:value];
    }
}

- (void)sliderView:(CVideoPlayerSliderView *)sliderView endDragValue:(float)value {
    // NSLog(@"%s  %f", __FUNCTION__, value);
    [self restTimer];
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerControlView:endDragProgress:)]) {
        [self.delegate playerControlView:self endDragProgress:value];
    }
}

#pragma mark - BoxDelegate
- (void)reSizeWithBox:(Box *)box {
    [self setNeedsLayout];
}

#pragma mark -Time Tips
/**
 *  显示时间tips
 */
- (void)showTimeTip {
    [self addSubview:self.timeTipView];

    if (controlBarHiden) {
        [self showControlBarAnimation];
    }

    [UIView animateWithDuration:0.5
    animations:^{
        self.timeTipView.alpha = 1.0;
    }
    completion:^(BOOL finished){
    }];
}

/**
 *  隐藏时间tips
 */
- (void)hidenTimeTip {

    [UIView animateWithDuration:0.5
    animations:^{
        self.timeTipView.alpha = 0.0;
    }
    completion:^(BOOL finished){
    //[self.timeTipView removeFromSuperview];
    }];
}

- (void)setTimeTipCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration panDirection:(CPlayerControlPanDirection)direction {

    if (CPlayerControlPanDirectionRight == direction) {
        self.timeTipIconView.image = [UIImage imageNamed:@"videoplayer_speedup"];
    }

    if (CPlayerControlPanDirectionLeft == direction) {
        self.timeTipIconView.image = [UIImage imageNamed:@"videoplayer_speeddown"];
    }

    [self setTime:currentTime duration:duration];
}

- (void)setTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration {
    NSString *currentTimeText = [NSString timeIntervalFormat:currentTime];
    NSString *durationText = [NSString timeIntervalFormat:duration];

    NSString *timeText = [NSString stringWithFormat:@"%@/%@", currentTimeText, durationText];

    self.currentTimeLabel.text = currentTimeText;
    self.durationTimeLabel.text = durationText;

    self.timeTipLabel.text = timeText;

    float progress = currentTime / duration;
    if (isnan(progress)) {
        progress = 0.0;
    }
    self.progress = progress;
}

//- (NSString *)timeIntervalFormat:(unsigned long long)time {
//    unsigned long long second = time % 60;
//    unsigned long long minute = (time / 60) % 60;
//    unsigned long long hour = time / 3600;
//
//    NSString *secondText = [NSString stringWithFormat:@"%llu", second];
//    if (second < 10) {
//        secondText = [NSString stringWithFormat:@"0%llu", second];
//    }
//
//    NSString *minuteText = [NSString stringWithFormat:@"%llu", minute];
//    if (minute < 10) {
//        minuteText = [NSString stringWithFormat:@"0%llu", minute];
//    }
//
//    NSString *hourText = [NSString stringWithFormat:@"%llu", hour];
//    if (hour < 10) {
//        hourText = [NSString stringWithFormat:@"0%llu", hour];
//    }
//
//    NSString *timeText = [NSString stringWithFormat:@"%@:%@:%@", hourText, minuteText, secondText];
//    return timeText;
//}

- (void)destroy {
    [self stopTimer];
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
