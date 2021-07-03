//
//  AppError.swift
//  SwiftUISample
//
//  Created by akiho on 2020/12/14.
//

import SwiftUI

enum AppError: Error {
    case unknown
    case needLogin
    
    static func from(_ error: Error) -> AppError {
        print("---------- raise error ----------")
        print(error.localizedDescription)
        return AppError.unknown
    }
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknown: return "エラーが発生しました"
        case .needLogin: return "ログインしてください"
        }
    }
}
