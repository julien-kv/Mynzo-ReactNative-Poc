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
          //                    Logger.write(text:"sync date updated in start activity tracking method")
          UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "syncDate")
          //                    if activity.confidence == .high || activity.confidence == .medium{
          Logger.write(text:"\(activity.description) at \(activity.startDate.toString())")
          //                    }
          //                    let confidence = activity.confidence.rawValue
          // Handle the activity here
          //                    if activity.walking {
          //                        Logger.write(text:"User is walking, confidence: \(confidence) at \(activity.startDate.toString())")
          //                    } else if activity.running {
          //                        Logger.write(text:"User is running, confidence: \(confidence) at \(activity.startDate.toString())")
          //                    } else if activity.automotive {
          //                        Logger.write(text:"User is in a vehicle, confidence: \(confidence) at \(activity.startDate.toString())")
          //                    } else if activity.stationary {
          //                        Logger.write(text:"User is stationary, confidence: \(confidence) at \(activity.startDate.toString())")
          //                    } else if activity.unknown {
          //                        Logger.write(text:"unknown")
          //                    }
          //                    else{
          ////                        Logger.write(text:"in else condition")
          ////                        Logger.write(text:"\(activity)")
          //                        Logger.write(text:"\(activity.description)")
          //
          //                    }
        }
      }
    }
  }
  
  @objc func stopTracking() {
    activityManager.stopActivityUpdates()
    locationManager.stopMonitoringSignificantLocationChanges()
  }
  
  
  @objc func getactivitytracking(){
    //        Logger.write(text:"retrieved data")
    //        Logger.write(text:"requesting data from \(Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "syncDate"))) to \(Date())")
    if CMMotionActivityManager.isActivityAvailable() {
      activityManager.queryActivityStarting(from: Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "syncDate")),
                                            to: Date(),
                                            to: OperationQueue.main) { (motionActivities, error) in
        Logger.write(text:"\(motionActivities?.count ?? 0) activities detected")
        for activity in motionActivities! {
          //                if activity.confidence == .high || activity.confidence == .medium{
          Logger.write(text:"\(activity.description) at \(activity.startDate.toString())")
          //                }
          //                if activity.walking {
          //                    Logger.write(text:"User is walking, confidence: \(activity.confidence.rawValue) at \(activity.startDate.toString())")
          //                } else if activity.running {
          //                    Logger.write(text:"User is running, confidence: \(activity.confidence.rawValue) at \(activity.startDate.toString())")
          //                } else if activity.automotive {
          //                    Logger.write(text:"User is in a vehicle, confidence: \(activity.confidence.rawValue) at \(activity.startDate.toString())")
          //                } else if activity.stationary {
          //                    Logger.write(text:"User is stationary, confidence: \(activity.confidence.rawValue) at \(activity.startDate.toString())")
          //                } else if activity.unknown {
          //                    Logger.write(text:"unknown")
          //                }else if let error = error {
          //                    Logger.write(text:"error: \(error)")
          //                }
          //                else{
          //                    Logger.write(text:"\(activity.description)")
          //                }
        }
        //            Logger.write(text:"sync date updated in getactivity tracking method")
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
    locationManager.pausesLocationUpdatesAutomatically = false
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


