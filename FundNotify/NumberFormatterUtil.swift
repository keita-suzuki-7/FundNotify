//
//  NumberFormatterUtil.swift
//  FundNotify
//
//  Created by Keita Suzuki on 2024/12/04.
//
class NumberFormatterUtil {
    
    /// 文字列型の騰落率に符号を付ける
    /// - Parameter value: String型の数値
    /// - Returns: 符号付きの文字列 ("+5.67" や "-3.45")。数値変換できない場合は元の値を返す。
    static func formatSignedPercentage(_ value: String) -> String {
        guard let doubleValue = Double(value) else {
            // 数値に変換できない場合はそのまま返す
            return value
        }
        return doubleValue > 0 ? "+\(value)" : value
    }
    
    /// 文字列型の整数値に符号を付ける
    /// - Parameter value: String型の数値
    /// - Returns: 符号付きの文字列 ("+123" や "-456")。数値変換できない場合は元の値を返す。
    static func formatSignedInt(_ value: String) -> String {
        guard let intValue = Int(value) else {
            // 数値に変換できない場合はそのまま返す
            return value
        }
        return intValue > 0 ? "+\(value)" : value
    }
    
}
