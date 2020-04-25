//
//  Helper.swift
//  COVID-19_MVP
//
//  Created by Дмитрий Марченков on 17.04.2020.
//  Copyright © 2020 Дмитрий Марченков. All rights reserved.
//

import Foundation
import UIKit

final class Helper {
    public static func createLocalPush (country : String, confirmedCases : Int) {
        let centre = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        content.title = "COVID-19"
        content.body = "Today in \(country) \(confirmedCases) confirmed cases"
        content.sound = .default
        content.threadIdentifier = "local-notifications temp"
        
        let date = Date(timeIntervalSinceNow: 10)
        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let requst = UNNotificationRequest(identifier: "content", content: content, trigger: trigger)
        
        centre.add(requst) { (_) in
        }
    }
}

extension Date {
    static func currentDay () -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "MSK") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd" //Specify your format that you want
        let date = dateFormatter.string(from: Date())
        return Int(date)!
    }
}

enum UserDefaultsName : String {
    case lastUpdate
}

enum ImageNames : String {
    case growDown
    case growUp
    case confirmed
    case death
    case recovered
}

enum ColorsNames : String{
    case textColor
    case darkRedColor
    case darkGreenColor
}

extension UIColor {
    static let cellColor       = UIColor(named: "cellColor")
    static let backgroundColor = UIColor(named: "tableBackGroundColor")
    static let chartColor      = UIColor(named: "chartColor")
    static let textColor       = UIColor(named: "textColor")
    static let darkGreenColor  = UIColor(displayP3Red:  0 / 255, green: 180 / 255, blue: 0 / 255, alpha: 1.0)
    static let darkRedColor    = UIColor(named: "darkRedColor")
}

