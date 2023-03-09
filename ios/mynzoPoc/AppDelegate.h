#import <RCTAppDelegate.h>
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : RCTAppDelegate <CLLocationManagerDelegate,UIApplicationDelegate>

@property (nonatomic, strong) CMMotionActivityManager *activityManager;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) NSOperationQueue *queue;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundUpdateTask;
@property (nonatomic, strong) NSTimer *bgtimer;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) NSTimeInterval current_time;


@end
