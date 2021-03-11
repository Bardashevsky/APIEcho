//
//  Response.swift
//  APIEcho
//
//  Created by Oleksandr Bardashevskyi on 09.03.2021.
//

import Foundation

struct ResponseModel: Decodable {
    let success: Bool
    let data: ResponseDataModel
    let errors: [ResponseErrorModel]
}

struct ResponseDataModel: Decodable {
    let uid: Int?
    let name: String?
    let email: String?
    let access_token: String?
    let role: Int?
    let status: Int?
    let created_at: Int?
    let updated_at: Int?
}
	
struct ResponseErrorModel: Decodable {
    let name: String?
    let message: String?
    let code: Int?
    let status: Int?
}

struct ResponseTextModel: Decodable {
    let success: Bool
    let data: String?
    let errors: [ResponseErrorModel]?
}
