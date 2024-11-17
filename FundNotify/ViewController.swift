//
//  ViewController.swift
//  FundNotify
//
//  Created by Keita Suzuki on 2024/11/09.
//

import UIKit

class ViewController: UIViewController {
    
    var fundData: FundData?
    var networkManager: NetworkManager!
    var notificationManager: NotificationManager!
    
    @IBOutlet weak var notifyTime: UIDatePicker!
    @IBOutlet weak var fundNameLabel: UILabel!
    @IBOutlet weak var navLabel: UILabel!
    @IBOutlet weak var cmpPrevDayLabel: UILabel!
    @IBOutlet weak var supplementLabel: UILabel!
    
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupManagers()
        fetchFundData()
    }
    
    deinit {
        // メモリリークを防ぐため、通知の監視を解除
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupManagers() {
        networkManager = NetworkManager()
        notificationManager = NotificationManager()
    }

    private func fetchFundData() {
        networkManager.fetchFundData { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.fundData = data
                self.updateUI()
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    @IBAction func scheduleDailyNotification(_ sender: UIDatePicker) {
        fetchFundData()
        guard let fundData = fundData else {
            print("Fund data is not available.")
            return
        }
        notificationManager.scheduleDailyNotification(at: sender.date, fundData: fundData)
    }

    private func updateUI() {
        guard let fundData = fundData else { return }
        
        fundNameLabel.numberOfLines = 0
        fundNameLabel.text = "ファンド名: \(fundData.fundName)"
        navLabel.text = "基準価額: \(fundData.nav)円"
        cmpPrevDayLabel.text = "前日比: \(fundData.cmpPrevDay)円 (\(fundData.percentageChange)%)"
        
        supplementLabel.lineBreakMode = .byWordWrapping
        supplementLabel.numberOfLines = 0
        supplementLabel.text = "初回約定: 24,348円(2024/5/7)\n基準価額最高値[設定来]: \(fundData.navMaxFull)円"
    }
    
    @IBAction func updateData(_ sender: UIButton) {
        fetchFundData()
    }
    
    private func handleError(_ error: Error) {
        print("Error fetching data: \(error)")
        // エラー表示やリトライ機能などを追加できます
    }
}
