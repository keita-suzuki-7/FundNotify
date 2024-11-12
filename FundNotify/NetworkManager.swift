//
//  Untitled.swift
//  FundNotify
//
//  Created by Keita Suzuki on 2024/11/09.
//

import Foundation

class NetworkManager {
    func fetchFundData(completion: @escaping (Result<FundData, Error>) -> Void) {
        let url = URL(string: "https://developer.am.mufg.jp/fund_information_latest/fund_cd/253425")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error)) // エラーを返す
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error)) // エラーを返す
                return
            }
            
            do {
                // JSONデータをデコード
                let decoder = JSONDecoder()
                let response = try decoder.decode(FundResponse.self, from: data)
                
                // データが存在すれば成功を返す
                if let fund = response.datasets.first {
                    let fundData = FundData(fundName: fund.fund_name,
                                            nav: fund.nav,
                                            cmpPrevDay: Int(fund.cmp_prev_day) ?? 0)
                    completion(.success(fundData))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No fund data found"])
                    completion(.failure(error)) // データがない場合のエラーを返す
                }
            } catch {
                completion(.failure(error)) // デコードエラーを返す
            }
        }
        
        task.resume()
    }
}
