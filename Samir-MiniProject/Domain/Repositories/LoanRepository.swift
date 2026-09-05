//
//  LoanRepository.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

protocol LoanRepository: AnyObject {
    func fetchLoans(forceRefresh: Bool) async throws -> [Loan]
}
