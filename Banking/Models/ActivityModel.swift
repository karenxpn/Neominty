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
                var curDate = calendar.date(byAdding: addBy == .weekOfYear ? .day : addBy,
                                            value: addBy == .weekOfYear ? 7 : 1, to: startDate) ?? Date()
                
                while curDate < Date() {

                    var interval: String
                    switch addBy {
                    case .hour:
                        interval = curDate.getDayTime()
                    case .day:
                        interval = curDate.getWeekDay()
                    case .month:
                        interval = curDate.getMonth()
                    case .weekOfYear:
                        interval = curDate.getWeek()
                    default:
                        interval = "some interval \(UUID().uuidString)"
                    }
                    
                    if points.first?.interval == interval {
                        points.remove(at: 0)
                    }
                    
                    points.append(ExpensePointViewModel(model: ExpensePoint(amount: 0, interval: interval, timestamp: Timestamp(date: Date()))))
                    
                    curDate = calendar.date(byAdding: addBy == .weekOfYear ? .day : addBy,
                                            value: addBy == .weekOfYear ? 7 : 1, to: curDate) ?? Date()
                }
            }
        }
    }
    
    func fixDayPoints(points: inout [ExpensePointViewModel]) {
        if points.last?.timestamp ?? Date() < Date() {
            let calendar = Calendar.current
            if let startDate = points.last?.timestamp {
                var curDate = calendar.date(byAdding: .hour,
                                            value: 1, to: startDate) ?? Date()
                
                while curDate < Date() {

                    let interval = curDate.getDayTime()

                    if points.first?.interval.components(separatedBy: "\n").first == interval {
                        points.remove(at: 0)
                    }
                    
                    let formattedInterval = "\(curDate.getDayTime())\n\(curDate.getDayOfYear())"

                    if points.contains(where: {$0.interval == formattedInterval}) == false {
                        points.append(ExpensePointViewModel(model: ExpensePoint(amount: 0, interval: formattedInterval, timestamp: Timestamp(date: Date()))))
                    }

                    curDate = calendar.date(byAdding: .hour,
                                            value: 1, to: curDate) ?? Date()
                }
            }
        }
    }
    
    var dayTotal: Decimal                                { self.day.map{$0.amount}.reduce(0, +) }
    var weekTotal: Decimal                               { self.week.map{$0.amount}.reduce(0, +) }
    var monthTotal: Decimal                              { self.month.map{$0.amount}.reduce(0, +) }
    var yearTotal: Decimal                               { self.year.map{$0.amount}.reduce(0, +) }
    
    var day: [ExpensePointViewModel] {
        let points = self.model.day.map(ExpensePointViewModel.init)
        
        var formattedPoints = [ExpensePointViewModel]()
        for point in points {
            
            let formattedInterval = "\(point.timestamp.getDayTime())\n\(point.timestamp.getDayOfYear())"
            if let index = formattedPoints.firstIndex(where:
                                                        {$0.interval == formattedInterval}) {
                formattedPoints[index].amount += point.amount
            } else {
                var cur = point
                cur.interval = "\(point.timestamp.getDayTime())\n\(point.timestamp.getDayOfYear())"
                formattedPoints.append(cur)
            }
        }
        
        if formattedPoints.first?.interval.components(separatedBy: "\n").first == formattedPoints.last?.interval.components(separatedBy: "\n").first  &&
            formattedPoints.first != formattedPoints.last {
            formattedPoints.removeFirst()
        }
            
        self.fixDayPoints(points: &formattedPoints)
        
        return formattedPoints
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
        var points = self.model.month.map(ExpensePointViewModel.init).map { point in
            var cur = point
            cur.interval = point.timestamp.getWeek()
            return cur
        }
        
        self.fixPoints(points: &points, addBy: .weekOfYear)
        
        return points
        
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
