//
//  RepaymentScheduleDTO.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

struct RepaymentScheduleDTO: Decodable {
    let installments: [RepaymentInstallmentDTO]
}
