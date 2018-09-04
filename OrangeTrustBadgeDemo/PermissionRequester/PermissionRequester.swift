//
//  PermissionRequester.swift
//  ESSTrustBadge_iOS
//
//  Created by Marc Beaudoin on 23/08/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import Foundation

import CoreLocation
import Contacts
import Photos
import MediaPlayer
import EventKit
import CoreBluetooth
import AVFoundation
import Speech
import UserNotifications
import HomeKit
import CoreMotion
import HealthKit

extension ViewController: PermissionRequesterDelegate {
    
    // Request speech recognition authorization
    public func requestSpeechRecognitionAuthorization(completionHandler: @escaping ()->Void) {
        if #available(iOS 10.0, *) {
            SFSpeechRecognizer.requestAuthorization { _ in
                completionHandler()
            }
        } else {
            completionHandler()
        }
    }
    
    public func requestMediaLibraryAuthorization(completionHandler: @escaping ()->Void) {
        if #available(iOS 9.3, *) {
            MPMediaLibrary.requestAuthorization({ (_) in
                completionHandler()
            })
        } else {
            completionHandler()
        }
    }
    
    public func requestMotionActivityAuthorization(completionHandler: @escaping ()->Void) {
        let manager = CMMotionActivityManager()
        manager.queryActivityStarting(from: Date(), to: Date(), to: OperationQueue()) { _,_  in
            completionHandler()
        }
    }
    
    public func requestHealthKitAuthorization(completionHandler: @escaping ()->Void) {
        guard HKHealthStore.isHealthDataAvailable() else { completionHandler(); return }
        HKHealthStore().requestAuthorization(toShare: PersonalData.shared.hkShareTypes, read: PersonalData.shared.hkReadTypes) { _,_ in
            completionHandler()
        }
    }
    
    // Request photoLibrary authorization
    public func requestPhotoLibraryAuthorization(completionHandler: @escaping ()->Void) {
        PHPhotoLibrary.requestAuthorization { _ in
            completionHandler()
        }
    }
    
    // Request camera authorization
    public func requestCameraAuthorization(completionHandler: @escaping ()->Void) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { _ in
            completionHandler()
        }
    }
    
    // Request calendar authorization
    public func requestCalendarAuthorization(completionHandler: @escaping ()->Void) {
        EKEventStore().requestAccess(to: .event) { _,_  in
            completionHandler()
        }
    }
    
    // Request reminders authorization
    public func requestReminderAuthorization(completionHandler: @escaping ()->Void) {
        EKEventStore().requestAccess(to: .reminder) { _,_  in
            completionHandler()
        }
    }
    
    // Request microphone authorization
    public func requestMicrophoneAuthorization(completionHandler: @escaping ()->Void) {
        AVAudioSession().requestRecordPermission {_ in
            completionHandler()
        }
    }
    
    // Request contacts authorization
    public func requestContactAuthorization(completionHandler: @escaping ()->Void) {
        
        CNContactStore().requestAccess(for: .contacts) { _,_  in
            completionHandler()
        }
    }
    
    // Request homekit authorization
    public func requestHomeKitAuthorization(completionHandler: @escaping ()->Void) {
        _ = PersonalData.shared.homeManager.homes
        completionHandler()
    }
    
    
    // Request Access to UserLocation in order to show them in iOS Preferences Panel
    public func requestLocationAuthorization(completionHandler: @escaping ()->Void) {
        PersonalData.shared.requestLocationAuthorization(completionHandler: completionHandler)
    }
    
    // Request Bluetooh Sharing authorization
    func requestBluetoothSharingAuthorization(completionHandler: @escaping ()->Void) {
        PersonalData.shared.startAdvertising (completionHandler: completionHandler)
    }

    
    func didFinishPerformRequests() {
        startDemo()
    }
}
