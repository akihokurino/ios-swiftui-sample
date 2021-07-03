//
//  ErrorAlert.swift
//  SwiftUISample
//
//  Created by akiho on 2020/12/14.
//

import Combine
import SwiftUI

class ErrorAlert: ObservableObject {
    @Published var isShowAlert: Bool = false
    @Published var message: String = ""
    
    func appError(_ error: AppError?) {
        guard let error = error else {
            return
        }
    
        isShowAlert = true
        message = error.errorDescription ?? ""
    }
    
    func validationError(_ message: String) {
        isShowAlert = true
        self.message = message
    }
}
