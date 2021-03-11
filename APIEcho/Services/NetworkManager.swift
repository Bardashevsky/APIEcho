//
//  AuthManager.swift
//  APIEcho
//
//  Created by Oleksandr Bardashevskyi on 09.03.2021.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let baseURL: String = "https://apiecho.cf/api/"
    
    func textRequest(accessToken: String, complition: @escaping ((Result<ResponseTextModel, Error>) -> Void)) {
        
        guard let url = URL(string: baseURL+"get/text/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                complition(.failure(error!))
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ResponseTextModel.self, from: data)
                complition(.success(response))
            } catch let error {
                complition(.failure(error))
            }
        }.resume()
    }
    
    func signUp(name: String, email: String, password: String, complition: @escaping ((Result<ResponseModel, Error>) -> Void)) {
        authRequest(parameters: ["name": name, "email": email, "password": password], suffixUrl: "signup/") { (response) in
            switch response {
            case .success(let response):
                complition(.success(response))
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
    
    func signIn(email: String, password: String, complition: @escaping ((Result<ResponseModel, Error>) -> Void)) {
        authRequest(parameters: ["email": email, "password": password], suffixUrl: "login/") { (response) in
            switch response {
            case .success(let response):
                complition(.success(response))
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
    
    private func authRequest(parameters: [String: String], suffixUrl: String, complition: @escaping ((Result<ResponseModel, Error>) -> Void)) {
        let parameters = parameters
        
        let url = URL(string: baseURL+suffixUrl)!
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            complition(.failure(error))
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                complition(.failure(error!))
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ResponseModel.self, from: data)
                complition(.success(response))
            } catch let error {
                complition(.failure(error))
            }
        }).resume()
    }
}
