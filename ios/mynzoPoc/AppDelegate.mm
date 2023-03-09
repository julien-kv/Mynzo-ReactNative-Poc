#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "mynzoPoc-Swift.h"

#define kLogsFile @"TestingLogs"
#define kLogsDirectory @"TestingLogsData"


@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  //initialise variabled
  self.activityManager = [[CMMotionActivityManager alloc] init];
  self.motionManager = [[CMMotionManager alloc] init];
  self.queue = [[NSOperationQueue alloc] init];
  self.locationManager = [[CLLocationManager alloc] init];
  self.latitude = 0.0;
  self.longitude = 0.0;
  self.current_time = [[NSDate date] timeIntervalSince1970];
  
  self.moduleName = @"mynzoPoc";
  // You can add your custom initial props in the dictionary below.
  // They will be passed down to the ViewController used by React Native.
  self.initialProps = @{};
  [Logger writeWithText:@"<<<<<<<<application launched after final update >>>>>>>>>>>>>" to:kLogsFile folder:kLogsDirectory];
  
  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstTime"] == false) {
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"firstTime"];
    [[NSUserDefaults standardUserDefaults] setDouble:[[NSDate date] timeIntervalSince1970] forKey:@"syncDate"];
  }
  
  [application registerForRemoteNotifications];

  [self StartupdateLocation];
  [self getactivitytracking];
  return YES;
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  // Start a background task
  self.backgroundUpdateTask = [application beginBackgroundTaskWithName:@"MyBackgroundTask" expirationHandler:^{
    // Handle the expiration of the background task
    completionHandler(UIBackgroundFetchResultFailed);
    [self getactivitytracking];
  }];
  [self getactivitytracking];
  
  // Perform your task here
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    completionHandler(UIBackgroundFetchResultNewData);
    [application endBackgroundTask:self.backgroundUpdateTask];
    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
  });
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
  
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
  CLLocation *location = locations.lastObject;
  self.latitude = location.coordinate.latitude;
  self.longitude = location.coordinate.longitude;
  [Logger writeWithText:[NSString stringWithFormat:@"updated location - Latitude: %a , Longitude: %a",self.latitude,self.longitude ] to:kLogsFile folder:kLogsDirectory];
  //  Logger.write(text: ("updated location - Latitude: \(self.latitude) , Longitude: \(self.longitude)"))
  
  
  NSLog(@"updated location - Latitude: %f , Longitude: %f", self.latitude, self.longitude);
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
  
}




- (void)applicationWillTerminate:(UIApplication *)application{
  [self.locationManager startMonitoringSignificantLocationChanges];
  [self.activityManager stopActivityUpdates];
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
  [self doBackgroundTask];
}





- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

/// This method controls whether the `concurrentRoot`feature of React18 is turned on or off.
///
/// @see: https://reactjs.org/blog/2022/03/29/react-v18.html
/// @note: This requires to be rendering on Fabric (i.e. on the New Architecture).
/// @return: `true` if the `concurrentRoot` feature is enabled. Otherwise, it returns `false`.
- (BOOL)concurrentRootEnabled
{
  return true;
}

@end
