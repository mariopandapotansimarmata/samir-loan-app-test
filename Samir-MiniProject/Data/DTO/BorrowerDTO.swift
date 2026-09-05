//
//  BorrowerDTO.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

struct BorrowerDTO: Decodable {
    let id: String
    let name: String
    let email: String
    let creditScore: Int
}
