//
//  LoanMapper.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import Foundation

enum LoanMappingError: Error, Equatable {
    case invalidRepaymentDate(String)
    case invalidDocumentURL(String)
}

struct LoanMapper {
    private let documentURLResolver: DocumentURLResolver

    init(documentURLResolver: DocumentURLResolver) {
        self.documentURLResolver = documentURLResolver
    }

    func map(_ dto: LoanDTO) throws -> Loan {
        let documents = try dto.documents.map { documentDTO in
            let url: URL

            do {
                url = try documentURLResolver.resolve(documentDTO.url)
            } catch {
                throw LoanMappingError.invalidDocumentURL(documentDTO.url)
            }

            return LoanDocument(type: documentDTO.type, url: url)
        }

        let installments = try dto.repaymentSchedule.installments.map { installmentDTO in
            guard let dueDate = Self.makeDateFormatter().date(from: installmentDTO.dueDate) else {
                throw LoanMappingError.invalidRepaymentDate(installmentDTO.dueDate)
            }

            return RepaymentInstallment(
                dueDate: dueDate,
                amountDue: installmentDTO.amountDue
            )
        }

        return Loan(
            id: dto.id,
            amount: dto.amount,
            interestRate: dto.interestRate,
            termInMonths: dto.term,
            purpose: dto.purpose,
            riskRating: RiskRating(rawValue: dto.riskRating),
            borrower: Borrower(
                id: dto.borrower.id,
                name: dto.borrower.name,
                email: dto.borrower.email,
                creditScore: dto.borrower.creditScore
            ),
            collateral: Collateral(
                type: dto.collateral.type,
                value: dto.collateral.value
            ),
            documents: documents,
            installments: installments
        )
    }

    private static func makeDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
