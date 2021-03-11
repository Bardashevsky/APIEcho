//
//  AuthManager.swift
//  APIEcho
//
//  Created by Oleksandr Bardashevskyi on 09.03.2021.
//

import Foundation

class AuthManager {
    static let shared = AuthManager()
    private init() {}
    
    func signUp(name: String?, email: String?, password: String?, complition: @escaping (Result<ResponseModel, Error>) -> Void) {
        
        guard Validator.isSignUpFilled(name: name, email: email, password: password) else {
            complition(.failure(AuthLocalError.notFilled))
            return
        }
        
        guard Validator.isSimpleEmail(email: email!) else {
            complition(.failure(AuthLocalError.invalidateEmail))
            return
        }
        NetworkManager.shared.signUp(name: name!, email: email!, password: password!) { (response) in
            switch response {
            case .success(let response):
                complition(.success(response))
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
    
    func signIn(email: String?, password: String?, complition: @escaping (Result<ResponseModel, Error>) -> Void) {
        guard Validator.isSignInFilled(email: email, password: password) else {
            complition(.failure(AuthLocalError.notFilled))
            return
        }
        
        guard Validator.isSimpleEmail(email: email!) else {
            complition(.failure(AuthLocalError.invalidateEmail))
            return
        }
        NetworkManager.shared.signIn(email: email!, password: password!) { (response) in
            switch response {
            case .success(let response):
                complition(.success(response))
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
}

