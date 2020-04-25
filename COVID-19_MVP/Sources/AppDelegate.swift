//
//  AppDelegate.swift
//  COVID-19_MVP
//
//  Created by Дмитрий Марченков on 17.04.2020.
//  Copyright © 2020 Дмитрий Марченков. All rights reserved.
//

import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate{

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        registerForPushNotifications()

        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "refreshData",
            using: DispatchQueue.global()
        ) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
            
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    
    public func scheduleAppRefresh() {
        do {
            let request = BGAppRefreshTaskRequest(identifier: "refreshData")
            request.earliestBeginDate = Date(timeIntervalSinceNow: 1440 * 60)
            try BGTaskScheduler.shared.submit(request)
            print("Refresh trigger complete")
        } catch {
            print(error)
        }
    }

    func handleAppRefresh(task: BGAppRefreshTask) {
        print("refresh start")

        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }

        let mainModel = MainModel()

        mainModel.getLastData { (result) in
            switch result {
            case .success(let data):
                print(data)
                let russia = data.filter{$0.country == "Russia"}
                let countryName = russia.first?.country ?? "MainLand"
                let confirmedCases = russia.first?.dayInfo?.allDaysInfo.last?.confirmed ?? 0

                Helper.createLocalPush(country: countryName, confirmedCases: confirmedCases)

                task.setTaskCompleted(success: true)
            case .failure(let err):
                print(err)
                task.setTaskCompleted(success: true)
            }
        }

        scheduleAppRefresh()
    }
    

}

//MARK:-Configuration Push Notification
extension AppDelegate {
    func registerForPushNotifications() {
        let centre = UNUserNotificationCenter.current()

        centre.requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")

            guard granted else { return }
            self.getNotificationSettings()
            centre.delegate = self
        }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

}


