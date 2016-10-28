//
//  AppDelegate.m
//  MP4Player
//
//  Created by Chentao on 2016/10/25.
//  Copyright © 2016年 Chentao. All rights reserved.
//

#import "AppDelegate.h"
#import "CRootNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    CRootNavigationController *rootNavigationController=[CRootNavigationController rootNavigationController];
    self.window.rootViewController=rootNavigationController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self systemNotificationListener];
    
    return YES;
}

-(void)systemNotificationListener{
    //静音模式继续播放
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *categorySetError = noErr;
    [audioSession setCategory: AVAudioSessionCategoryPlayback error: &categorySetError];
    if (categorySetError) {
        DEBUG_LOG(@"AVAudioSession设置类型失败：%@",categorySetError);
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioSessionInterruptionHandler:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioSessionRouteChangeHandler:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:nil];
    
}


-(void)audioSessionInterruptionHandler:(NSNotification*)notification{
    NSDictionary *interruptionDictionary = [notification userInfo];
    AVAudioSessionInterruptionType type =[interruptionDictionary [AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        DEBUG_LOG(@"声音打断开始");
        [[NSNotificationCenter defaultCenter] postNotificationName:kCNotificationApplicationAudioSessionBeginInterruption object:nil];
    } else if (type == AVAudioSessionInterruptionTypeEnded){
        DEBUG_LOG(@"声音打断结束");
        [[NSNotificationCenter defaultCenter] postNotificationName:kCNotificationApplicationAudioSessionEndInterruption object:nil];
    } else {
        DEBUG_LOG(@"AVAudioSessionInterruptionNotification 其它情况");
    }
}

-(void)audioSessionRouteChangeHandler:(NSNotification*)notification{
    NSDictionary *dic = notification.userInfo;
    int changeReason = [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription = dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription = [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([AVAudioSessionPortHeadphones isEqualToString:portDescription.portType] ||
            [AVAudioSessionPortBluetoothA2DP isEqualToString:portDescription.portType]
            ) {
            DEBUG_LOG(@"拔出耳机  %@ ", portDescription.portType);
            [[NSNotificationCenter defaultCenter] postNotificationName:kCNotificationApplicationHeadphonePullout object:nil];
        }
    }
    
    if (changeReason == AVAudioSessionRouteChangeReasonNewDeviceAvailable) {
        AVAudioSessionRouteDescription *routeDescription = dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription = [routeDescription.outputs firstObject];
        if ([AVAudioSessionPortBuiltInSpeaker isEqualToString:portDescription.portType]) {
            DEBUG_LOG(@"插入耳机  %@ ", portDescription.portType);
            [[NSNotificationCenter defaultCenter] postNotificationName:kCNotificationApplicationHeadphoneInsert object:nil];
        }
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
