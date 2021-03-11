//
//  AuthErrors.swift
//  APIEcho
//
//  Created by Oleksandr Bardashevskyi on 09.03.2021.
//

import Foundation

enum AuthLocalError {
    case notFilled
    case invalidateEmail
}

extension AuthLocalError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Fill in all the fields", comment: "")
        case .invalidateEmail:
            return NSLocalizedString("Invalid email format", comment: "")
        }
    }
    
}
