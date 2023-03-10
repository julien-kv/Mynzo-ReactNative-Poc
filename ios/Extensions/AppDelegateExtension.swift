//
//  AppDelegateExtension.swift
//  mynzoPoc
//
//  Created by Julien on 09/03/23.
//

import Foundation

@objc public extension AppDelegate {
  
  
  @objc func startTracking() {
    if CMMotionActivityManager.isActivityAvailable() {
      activityManager.startActivityUpdates(to: OperationQueue.main) { (activity: CMMotionActivity?) in
        if let activity = activity {
          UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "syncDate")
          Logger.write(text:"\(activity.description) at \(activity.startDate.toString())")
          
        }
      }
    }
  }
  
  @objc func stopTracking() {
    activityManager.stopActivityUpdates()
    locationManager.stopMonitoringSignificantLocationChanges()
  }
  
  @objc func getactivitytracking(){
    if CMMotionActivityManager.isActivityAvailable() {
      activityManager.queryActivityStarting(from: Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "syncDate")),
                                            to: Date(),
                                            to: OperationQueue.main) { (motionActivities, error) in
        Logger.write(text:"\(motionActivities?.count ?? 0) activities detected")
        for activity in motionActivities! {
          Logger.write(text:"\(activity.description) at \(activity.startDate.toString())")
        }
        Logger.write(text:"sync date updated in getactivity tracking method")
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "syncDate")
      }
      self.startTracking()
    }
  }
  
  
  @objc func doBackgroundTask() {
    DispatchQueue.main.async {
      self.beginBackgroundUpdateTask()
      self.StartupdateLocation()
      self.bgtimer = Timer.scheduledTimer(timeInterval: 1*60, target: self, selector: #selector(AppDelegate.bgtimer(_:)), userInfo: nil, repeats: true)
      RunLoop.current.add(self.bgtimer, forMode: RunLoop.Mode.default)
      RunLoop.current.run()
      self.endBackgroundUpdateTask()
    }
  }
  
  @objc func beginBackgroundUpdateTask() {
    self.backgroundUpdateTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
      self.endBackgroundUpdateTask()
    })
  }
  
  @objc func endBackgroundUpdateTask() {
    UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
    self.backgroundUpdateTask = UIBackgroundTaskIdentifier.invalid
  }
  
  @objc func StartupdateLocation() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.distanceFilter = kCLDistanceFilterNone
    locationManager.requestAlwaysAuthorization()
    locationManager.allowsBackgroundLocationUpdates = true
    locationManager.pausesLocationUpdatesAutomatically = true
    locationManager.startUpdatingLocation()
  }
  
  
  @objc func bgtimer(_ timer:Timer!){
    self.updateLocation()
  }
  
  @objc func updateLocation() {
    self.locationManager.startUpdatingLocation()
    self.locationManager.stopUpdatingLocation()
  }
}


