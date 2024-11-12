//
//  NotificationManager.swift
//  FundNotify
//
//  Created by Keita Suzuki on 2024/11/09.
//
import UserNotifications

class NotificationManager {
    // 通常の通知を送る関数
    func sendNotification(nav: Int, cmpPrevDay: Int) {
        let content = UNMutableNotificationContent()
        content.title = "ファンド情報"
        content.body = "基準価額: \(nav) 前日比: \(cmpPrevDay)"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "fundNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }

    // ユーザー設定の時間に毎日通知を送る関数
    func scheduleDailyNotification(at time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "ファンド情報"
        content.body = "指定した時刻に基準価額や前日比をお知らせします！"
        
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
        dateComponents.second = 0  // 秒を0に設定
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "dailyNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling daily notification: \(error.localizedDescription)")
            } else {
                print("Daily notification scheduled.")
            }
        }
    }
    
    // 1分おきに通知を送る関数
    func sendRecurringNotifications() {
        let content = UNMutableNotificationContent()
        content.title = "定期的な通知"
        content.body = "1分ごとに通知をお送りします！"
        
        // 1分おきに通知をトリガー
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        let request = UNNotificationRequest(identifier: "recurringNotification", content: content, trigger: trigger)
        
        // 通知をスケジュール
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling recurring notification: \(error.localizedDescription)")
            } else {
                print("Recurring notification scheduled.")
            }
        }
    }
}
