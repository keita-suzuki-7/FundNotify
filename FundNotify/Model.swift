//
//  Model.swift
//  FundNotify
//
//  Created by Keita Suzuki on 2024/11/09.
//
import Foundation

// レスポンスのデータモデル
struct FundResponse: Codable {
    let datasets: [FundData]
}

// ファンドのデータモデル
struct FundData: Codable {
    let associationFundCd: String
    let baseDate: String
    let cancellationPrice: Int
    let cmpPrevDay: String
    let fundCd: String
    let fundName: String
    let isinCd: String
    let netassets: Int
    let netassetsChangeCmpPrevDay: String
    let percentageChange: String
    let percentageChange1M: String
    let percentageChange1Y: String
    let percentageChange3M: String
    let percentageChange3Y: String
    let percentageChange6M: String
    let percentageChangeFull: String
    let percentageChangeMax1M: String
    let percentageChangeMax1Y: String
    let percentageChangeMax3M: String
    let percentageChangeMax3Y: String
    let percentageChangeMax6M: String
    let percentageChangeMaxFull: String
    let percentageChangeMin1M: String
    let percentageChangeMin1Y: String
    let percentageChangeMin3M: String
    let percentageChangeMin3Y: String
    let percentageChangeMin6M: String
    let percentageChangeMinFull: String
    let risk1Y: String
    let risk3Y: String
    let riskFull: String
    let riskReturn1Y: String
    let riskReturn3Y: String
    let riskReturnFull: String
    let nav: Int
    let navMax1M: String
    let navMax1MDt: String
    let navMax1Y: String
    let navMax1YDt: String
    let navMax3M: String
    let navMax3MDt: String
    let navMax3Y: String
    let navMax3YDt: String
    let navMax6M: String
    let navMax6MDt: String
    let navMaxFull: String
    let navMaxFullDt: String
    let navMin1M: String
    let navMin1MDt: String
    let navMin1Y: String
    let navMin1YDt: String
    let navMin3M: String
    let navMin3MDt: String
    let navMin3Y: String
    let navMin3YDt: String
    let navMin6M: String
    let navMin6MDt: String
    let navMinFull: String
    let navMinFullDt: String
}
