//
//  ActivityModel.swift
//  Banking
//
//  Created by Karen Mirakyan on 23.03.23.
//

import Foundation
import FirebaseFirestore

struct ActivityModel: Codable {
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
    
    func fixPoints(points: inout [ExpensePointViewModel], addBy: Calendar.Component) {
        if points.last?.timestamp ?? Date() < Date() {
            let calendar = Calendar.current
            if let startDate = points.last?.timestamp {
                var curDate = calendar.date(byAdding: addBy, value: 1, to: startDate) ?? Date()
                
                while curDate < Date() {
                    var interval: String
                    switch addBy {
                    case .hour:
                        interval = curDate.getHour()
                    case .day:
                        interval = curDate.getWeekDay()
                    case .month:
                        interval = curDate.getMonth()
                    default:
                        interval = "some interval \(UUID().uuidString)"
                    }
                    
                    if points.first?.interval == interval {
                        points.remove(at: 0)
                        points.append(ExpensePointViewModel(model: ExpensePoint(amount: 0, interval: interval, timestamp: Timestamp(date: Date()))))
                    }
                    curDate = calendar.date(byAdding: addBy, value: 1, to: curDate) ?? Date()
                }
            }
        }
    }
    
    var dayTotal: Decimal                                { self.day.map{$0.amount}.reduce(0, +) }
    var weekTotal: Decimal                               { self.week.map{$0.amount}.reduce(0, +) }
    var monthTotal: Decimal                              { self.month.map{$0.amount}.reduce(0, +) }
    var yearTotal: Decimal                               { self.year.map{$0.amount}.reduce(0, +) }
    
    var day: [ExpensePointViewModel] {
        var points = self.model.day.map(ExpensePointViewModel.init).map { point in
            var cur = point
            cur.interval = point.timestamp.getHour()
            return cur
        }
                
        self.fixPoints(points: &points, addBy: .hour)
        
        return points
    }
    
    var week: [ExpensePointViewModel]         {
        var points = self.model.week.map(ExpensePointViewModel.init).map { point in
            var cur = point
            cur.interval = point.timestamp.getWeekDay()
            return cur
        }
        
        self.fixPoints(points: &points, addBy: .day)
        
        return points
        
    }
    var month: [ExpensePointViewModel]        {
        self.model.month.map(ExpensePointViewModel.init).map { point in
            var cur = point
            cur.interval = point.timestamp.getWeek()
            return cur
        }
        
    }
    var year: [ExpensePointViewModel]         {
        var points = self.model.year.map(ExpensePointViewModel.init).map { point in
            var cur = point
            cur.interval = point.timestamp.getMonth()
            return cur
        }
        
        self.fixPoints(points: &points, addBy: .month)
        return points
    }
    
    var transactions: [TransactionPreviewViewModel] {
        if self.model.transactiions != nil {
            return self.model.transactiions!.map(TransactionPreviewViewModel.init)
        } else {
            return []
        }
    }
}
