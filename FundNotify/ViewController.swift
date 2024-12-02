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
    var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var notifyTime: UIDatePicker!
    @IBOutlet weak var fundNameLabel: UILabel!
    @IBOutlet weak var navLabel: UILabel!
    @IBOutlet weak var cmpPrevDayLabel: UILabel!
    @IBOutlet weak var supplementLabel: UILabel!
    
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景色の設定
        view.backgroundColor = UIColor.systemBackground

        // ラベルのデザイン
        fundNameLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        fundNameLabel.textColor = UIColor.label

        navLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        navLabel.textColor = UIColor.label

        cmpPrevDayLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        cmpPrevDayLabel.textColor = UIColor.label

        // ボタンのデザイン
        updateButton.backgroundColor = UIColor.systemBlue
        updateButton.tintColor = UIColor.white
        updateButton.setTitleColor(.white, for: .normal)
        updateButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        updateButton.layer.cornerRadius = 8
        
        AuthenticationManager.authenticate { success, errorMessage in
            if success {
                print("Authentication successful!")
            } else {
                print("Authentication failed: \(errorMessage ?? "Unknown error")")
            }
        }
        setupManagers()
        setupActivityIndicator()
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
    
    // UIActivityIndicatorView のセットアップ
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    private func fetchFundData() {
        // データ更新中にインジケーターを表示
        activityIndicator.startAnimating()

        networkManager.fetchFundData { [weak self] result in
            
            // 非同期処理が完了したらメインスレッドでインジケーターを停止
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
            
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
        
        // メインスレッドでUI更新を行う
        DispatchQueue.main.async {
            self.fundNameLabel.numberOfLines = 0
            self.fundNameLabel.text = "ファンド名: \(fundData.fundName)"
            self.navLabel.text = "基準価額: \(fundData.nav)円"
            self.cmpPrevDayLabel.text = "前日比: \(fundData.cmpPrevDay)円 (\(fundData.percentageChange)%)"
            
            self.supplementLabel.lineBreakMode = .byWordWrapping
            self.supplementLabel.numberOfLines = 0
            self.supplementLabel.text = "初回約定: 24,348円(2024/5/7)\n基準価額最高値[設定来]: \(fundData.navMaxFull)円"
        }
    }
    
    @IBAction func updateData(_ sender: UIButton) {
        fetchFundData()
    }
    
    private func handleError(_ error: Error) {
        print("Error fetching data: \(error)")
        // エラー表示やリトライ機能などを追加できます
    }
}
