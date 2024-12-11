//
//  NotificationManager.swift
//  FundNotify
//
//  Created by Keita Suzuki on 2024/11/09.
//
import UserNotifications
import Foundation

class NotificationManager {
    
    private let networkManager = NetworkManager()
    
    // ユーザー設定の時間に毎日通知を送る関数
    func scheduleDailyNotification(at notifyTime: Date) {
        // 既存の通知をキャンセル
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // 通知時刻の設定
        var dateComponents = DateComponents()
        let calendar = Calendar.current
        dateComponents.hour = calendar.component(.hour, from: notifyTime)
        dateComponents.minute = calendar.component(.minute, from: notifyTime)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // ユニークな識別子を生成
        let uniqueIdentifier = UUID().uuidString
        
        let request = UNNotificationRequest(
            identifier: uniqueIdentifier,
            content: generatePlaceholderContent(),
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Daily notification scheduled with ID \(uniqueIdentifier).")
            }
        }
        
        // 通知トリガー直前に最新データを取得して通知内容を更新
        UNUserNotificationCenter.current().getPendingNotificationRequests { [weak self] requests in
            for request in requests {
                if request.identifier == uniqueIdentifier {
                    self?.fetchAndUpdateNotification(request: request)
                }
            }
        }
    }
    
    private func fetchAndUpdateNotification(request: UNNotificationRequest) {
        // 最新のファンドデータを取得
        networkManager.fetchFundData { [weak self] result in
            switch result {
            case .success(let fundData):
                let content = self?.generateContent(for: fundData) ?? UNMutableNotificationContent()
                let updatedRequest = UNNotificationRequest(
                    identifier: request.identifier,
                    content: content,
                    trigger: request.trigger
                )
                
                // 通知リクエストを更新
                UNUserNotificationCenter.current().add(updatedRequest) { error in
                    if let error = error {
                        print("Error updating notification: \(error)")
                    } else {
                        print("Notification updated successfully.")
                    }
                }
            case .failure(let error):
                print("Failed to fetch data for notification: \(error)")
            }
        }
    }
    
    private func generatePlaceholderContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "ファンド情報を更新中..."
        content.body = "最新情報が取得され次第通知します。"
        content.sound = .default
        return content
    }
    
    private func generateContent(for fundData: FundData) -> UNMutableNotificationContent {
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
        content.sound = .default
        
        return content
    }
}
