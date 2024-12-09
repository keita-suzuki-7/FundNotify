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
        // 既存の通知をキャンセル
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        
        let cmpPrevDay = NumberFormatterUtil.formatSignedInt(fundData.cmpPrevDay)
        let percentageChange = NumberFormatterUtil.formatSignedPercentage(fundData.percentageChange)
        let percentageChange1M = NumberFormatterUtil.formatSignedPercentage(fundData.percentageChange1M)
        let percentageChange3M = NumberFormatterUtil.formatSignedPercentage(fundData.percentageChange3M)
        let percentageChange6M = NumberFormatterUtil.formatSignedPercentage(fundData.percentageChange6M)
        let percentageChange1Y = NumberFormatterUtil.formatSignedPercentage(fundData.percentageChange1Y)
        let percentageChange3Y = NumberFormatterUtil.formatSignedPercentage(fundData.percentageChange3Y)
        let percentageChangeFULL = NumberFormatterUtil.formatSignedPercentage(fundData.percentageChangeFull)
        
        content.title = "\(fundData.fundName)"
        content.body = "基準価額   : \(fundData.nav)円 基準日: \(fundData.baseDate)\n" +
                       "最高値　   : \(fundData.navMaxFull)円 前日比: \(cmpPrevDay)円(\(percentageChange)%)\n" +
                       "騰落率[1M]: \(percentageChange1M)% 騰落率[3M]: \(percentageChange3M)%\n" +
                       "騰落率[6M]: \(percentageChange6M)% 騰落率[1Y]: \(percentageChange1Y)%\n" +
                       "騰落率[3Y]: \(percentageChange3Y)% 騰落率[SI]: \(percentageChangeFULL)%\n"
        
        // 時刻のみを指定して毎日同じ時刻に通知する
        var dateComponents = DateComponents()
        let calendar = Calendar.current
        
        dateComponents.hour = calendar.component(.hour, from: notifyTime)
        dateComponents.minute = calendar.component(.minute, from: notifyTime)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        // ユニークな識別子を生成
        let uniqueIdentifier = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uniqueIdentifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Daily notification scheduled with ID \(uniqueIdentifier).")
            }
        }
    }
}
