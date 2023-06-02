//
//  ActivityModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 23.03.23.
//

import Foundation
import FirebaseFirestore

struct ActivityModel: Codable {
    var totalday: Decimal
    var totalweek: Decimal
    var totalmonth: Decimal
    var totalyear: Decimal
    var day: [ExpensePoint]
    var week: [ExpensePoint]
    var month: [ExpensePoint]
    var year: [ExpensePoint]
    var transactiions: [TransactionPreview]?
}


struct ActivityModelViewModel {
    var model: ActivityModel
    init(model: ActivityModel) {
        self.model = model
    }
    
    var dayTotal: Decimal                                { self.model.totalday }
    var weekTotal: Decimal                               { self.model.totalweek }
    var monthTotal: Decimal                              { self.model.totalmonth }
    var yearTotal: Decimal                               { self.model.totalyear }
    
    var day: [ExpensePointViewModel] {
        var points = self.model.day.map(ExpensePointViewModel.init).map { point in
            var cur = point
            cur.interval = point.timestamp.getHour()
            return cur
        }
        
        if points.last?.interval ?? "" < Date().getHour() {
            
            if let tmp = Int(points.last?.timestamp.getHour() ?? "0") {
                var cur = tmp + 1
                while points.last?.interval ?? "" < Date().getHour() {
                    points.append(ExpensePointViewModel(model: ExpensePoint(amount: 0, interval: String(cur), timestamp: Timestamp(date: Date()))))
                    cur += 1
                }
            }
        }
        
        return points
    }
    
    var week: [ExpensePointViewModel]         {
        self.model.week.map(ExpensePointViewModel.init).map { point in
            var cur = point
            cur.interval = point.timestamp.getWeekDay()
            return cur
        }
        
    }
    var month: [ExpensePointViewModel]        { self.model.month.map(ExpensePointViewModel.init) }
    var year: [ExpensePointViewModel]         {
        self.model.year.map(ExpensePointViewModel.init).map { point in
            var cur = point
            cur.interval = point.timestamp.getMonth()
            return cur
        }
    }
    
    var transactions: [TransactionPreviewViewModel] {
        if self.model.transactiions != nil {
            return self.model.transactiions!.map(TransactionPreviewViewModel.init)
        } else {
            return []
        }
    }
}
