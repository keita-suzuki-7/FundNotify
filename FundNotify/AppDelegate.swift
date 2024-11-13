//
//  AppDelegate.swift
//  FundNotify
//
//  Created by Keita Suzuki on 2024/11/09.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // 通知の許可をリクエストする
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("通知が許可されました")
            } else {
                // 許可されなかった場合、ユーザーに通知設定を促すことができます
                if let error = error {
                    print("通知の許可でエラーが発生しました: \(error.localizedDescription)")
                } else {
                    print("通知が許可されませんでした")
                    DispatchQueue.main.async {
                        // 設定画面に遷移する、またはアラートを表示するなど
                        self.showNotificationSettingsAlert()
                    }
                }
            }
        }
    }

    // 設定画面への遷移を促すアラート表示
    private func showNotificationSettingsAlert() {
        let alert = UIAlertController(title: "通知設定", message: "アプリの通知設定が許可されていません。設定を変更しますか？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "設定", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            rootVC.present(alert, animated: true, completion: nil)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 通知の許可をリクエスト
        requestNotificationPermission()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // 不要なリソースの解放等を行います
    }
}
