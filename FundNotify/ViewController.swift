//
//  ViewController.swift
//  FundNotify
//
//  Created by Keita Suzuki on 2024/11/09.
//

import UIKit

class ViewController: UIViewController {
    var fundData: FundData?
    @IBOutlet weak var notifyDate: UIDatePicker!
    @IBOutlet weak var fundNameLabel: UILabel!
    @IBOutlet weak var navLabel: UILabel!
    @IBOutlet weak var cmpPrevDayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // キーボード表示・非表示の通知を監視
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        fetchFundData()
        updateUI()
        
    }
    
    // キーボードが表示される前に呼ばれる
    @objc func keyboardWillShow(_ notification: Notification) {
        print("キーボードが表示されます")
        // 必要に応じて、ビューのレイアウトやスクロールビューの調整などを行う
    }
    
    // キーボードが非表示になる前に呼ばれる
    @objc func keyboardWillHide(_ notification: Notification) {
        print("キーボードが非表示になります")
        // 必要に応じてビューを元の状態に戻す
    }
    
    deinit {
        // メモリリークを防ぐため、通知の監視を解除
        NotificationCenter.default.removeObserver(self)
    }

    func fetchFundData() {
        let networkManager = NetworkManager()
        networkManager.fetchFundData { result in
            switch result {
            case .success(let data):
                self.fundData = data
                DispatchQueue.main.async {
                    self.updateUI()
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
    @IBAction func scheduleNotification(_ sender: UIDatePicker) {
        let notificationTime = notifyDate.date
        let notificationManager = NotificationManager()
        notificationManager.scheduleDailyNotification(at: notificationTime)
    }

    func updateUI() {
        guard let fundData = fundData else { return }
        
        // 例: ラベルの更新
        fundNameLabel.text = "ファンド名: \(fundData.fundName)"
        navLabel.text = "基準価額: \(fundData.nav)"
        cmpPrevDayLabel.text = "前日比: \(fundData.cmpPrevDay)"
    }
}
