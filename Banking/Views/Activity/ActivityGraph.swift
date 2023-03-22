//
//  ActivityGraph.swift
//  Banking
//
//  Created by Karen Mirakyan on 22.03.23.
//

import SwiftUI
import Charts

struct ExpensePoint {
    let id: String = UUID().uuidString
    var day: String
    var amount: Double
}

struct ActivityGraph: View {
    @EnvironmentObject var activityVM: ActivityViewModel
    var body: some View {
        
        let curGradient = LinearGradient(
            gradient: Gradient (
                colors: [
                    Color(uiColor: UIColor(red: 29/255, green: 171/255, blue: 135/255, alpha: 1)),
                    Color(uiColor: UIColor(red: 47/255, green: 162/255, blue: 185/255, alpha: 0))
                ]
            ),
            startPoint: .top,
            endPoint: .bottom
        )
        
        Chart {
            
            ForEach(activityVM.plot, id: \.id) {
                LineMark(
                    x: .value("Week Day", $0.day),
                    y: .value("Step Count", $0.amount)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(AppColors.green)
                .lineStyle(StrokeStyle(lineWidth: 3))
                .accessibilityHidden(false)
                
                AreaMark(
                    x: .value("Week Day", $0.day),
                    y: .value("Step Count", $0.amount)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(curGradient)

            }
        }.chartYAxis(.hidden)
        .chartLegend(position: .overlay, alignment: .top)
        .chartPlotStyle { plotArea in
            plotArea
                .background(.white)
        }
        .chartXAxis() {
            AxisMarks(position: .bottom)
        }
        .frame(height:150)
        
    }
}

struct ActivityGraph_Previews: PreviewProvider {
    static var previews: some View {
        ActivityGraph()
            .environmentObject(ActivityViewModel())
    }
}
