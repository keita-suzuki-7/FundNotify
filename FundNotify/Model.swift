//
//  Model.swift
//  FundNotify
//
//  Created by Keita Suzuki on 2024/11/09.
//
import Foundation

// レスポンスのデータモデル
struct FundResponse: Codable {
    let datasets: [Fund]
}

// ファンドのデータモデル
struct Fund: Codable {
    let nav: Int
    let cmp_prev_day: String
}

// UIに表示するためのデータモデル
struct FundData {
    let nav: Int
    let cmpPrevDay: Int
}
