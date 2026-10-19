//
//  BillModel.swift
//  Bill Splitter
//
//  Created by Nicholas Lim on 15/10/26.
//

import Foundation

enum RoundingStrategy {
    case none
    case roundUp
    case roundToNearestDollar
}

struct BillModel {
    var billAmount: Decimal
    var gstEnabled: Bool
    var serviceEnabled: Bool
    let serviceRate: Decimal = 0.1
    let gstRate: Decimal = 0.09
    var partySize: Int
    var roundingStrategy: RoundingStrategy

    var serviceChargeAmount: Decimal {
        billAmount * serviceRate * (serviceEnabled ? 1 : 0)
    }
    var gstAmount: Decimal {
        billAmount * gstRate * (gstEnabled ? 1 : 0)
    }
    var totalAmount: Decimal {
        billAmount + serviceChargeAmount + gstAmount
    }
    var perPersonAmount: Decimal {
        totalAmount / Decimal(partySize)
    }
    var displayPerPerson: Decimal {
        var amount = perPersonAmount
        var rounded = Decimal()

        switch roundingStrategy {
        case .none:
            return amount
        case .roundToNearestDollar:
            NSDecimalRound(&rounded, &amount, 0, .plain)
        case .roundUp:
            NSDecimalRound(&rounded, &amount, 0, .up)
        }

        return rounded
    }
}
