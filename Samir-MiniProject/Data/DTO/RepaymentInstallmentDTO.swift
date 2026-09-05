//
//  RepaymentInstallmentDTO.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import Foundation

struct RepaymentInstallmentDTO: Decodable {
    let dueDate: String
    let amountDue: Decimal
}
