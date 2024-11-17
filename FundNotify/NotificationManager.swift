//
//  NotificationManager.swift
//  FundNotify
//
//  Created by Keita Suzuki on 2024/11/09.
//
import UserNotifications
import UIKit

class NotificationManager {
    // ユーザー設定の時間に毎日通知を送る関数
    func scheduleDailyNotification(at notifyTime: Date, fundData: FundData) {
        let content = UNMutableNotificationContent()
        content.title = "\(fundData.fundName)"
        content.body = "基準日: \(fundData.baseDate) 基準価額: \(fundData.nav)円\n前日比: \(fundData.cmpPrevDay)円(\(fundData.percentageChange)%) 基準価額最高値[設定来]: \(fundData.navMaxFull)円"
        
        // 時刻のみを指定して毎日同じ時刻に通知する
        var dateComponents = DateComponents()
        let calendar = Calendar.current
        
        dateComponents.hour = calendar.component(.hour, from: notifyTime)
        dateComponents.minute = calendar.component(.minute, from: notifyTime)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Daily notification scheduled at \(dateComponents.hour ?? 0):\(dateComponents.minute ?? 0).")
            }
        }
    }
}
