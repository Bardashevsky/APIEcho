//
//  Validator.swift
//  APIEcho
//
//  Created by Oleksandr Bardashevskyi on 09.03.2021.
//

import Foundation

class Validator {
    static func isSignUpFilled(name: String?, email: String?, password: String?) -> Bool {
        guard let name = name, let email = email, let password = password,
              name != "", email != "", password != "" else {
            return false
        }
        
        return true
    }
    
    static func isSignInFilled(email: String?, password: String?) -> Bool {
        guard let email = email, let password = password,
              email != "", password != "" else {
            return false
        }
        
        return true
    }
    
    static func isSimpleEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
