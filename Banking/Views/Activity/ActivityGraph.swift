//
//  ActivityGraph.swift
//  Banking
//
//  Created by Karen Mirakyan on 22.03.23.
//

import SwiftUI
import Charts


struct ActivityGraph: View {
    let points: [ExpensePoint]
    let currencySymbol: String
    @State private var location: CGPoint = .zero
    @State private var amount: Double = 0
    @State private var selectedPoint: String? = nil

    
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
        
        let rectangleMarkGradient = LinearGradient(
            gradient: Gradient (
                colors: [
                    Color(uiColor: UIColor(red: 159/255, green: 214/255, blue: 200/255, alpha: 1)),
                    Color(uiColor: UIColor(red: 47/255, green: 162/255, blue: 185/255, alpha: 0))
                ]
            ),
            startPoint: .top,
            endPoint: .bottom
        )
        
        Chart {
            
            ForEach(points, id: \.id) { point in
                
                if let selectedPoint, selectedPoint == point.period {
                    RectangleMark(
                        x: .value("Week Day", point.period),
                        yStart: .value("Amount", 0),
                        yEnd: .value("Amount", point.amount + 1),
                        width: 24
                    ).foregroundStyle(rectangleMarkGradient)
                        .cornerRadius(8)
                        .opacity(0.8)
                    
                    PointMark(
                        x: .value("Week Day", point.period),
                        y: .value("Amount", point.amount)
                        )
                    .annotation(alignment: .bottom, spacing: 0) {
                        
                        VStack(spacing: 0) {
                            TextHelper(text: "\(currencySymbol) \(String(format: "%.2f", point.amount))", color: .white, fontName: Roboto.medium.rawValue, fontSize: 10)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 5)
                                .background {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.black)
                                }

                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 0.5, height: 40)
                        }
                        
                    }.foregroundStyle(.black)
                        .interpolationMethod(.catmullRom)

                }
                
                LineMark(
                    x: .value("Week Day", point.period),
                    y: .value("Amount", point.amount)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(AppColors.green)
                .lineStyle(StrokeStyle(lineWidth: 3))
                .accessibilityHidden(false)
                
                AreaMark(
                    x: .value("Week Day", point.period),
                    y: .value("Amount", point.amount)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(curGradient)
                
            }
        }.chartYAxis(.hidden)
            .chartPlotStyle { plotArea in
                plotArea
                    .background(.white)
            }.chartYScale(domain: 0...Int((points.map{Int($0.amount)}.max() ?? 75) ))
            .chartXAxis() {
                AxisMarks(position: .bottom)
            }
            .frame(height:150)
        
            .chartOverlay { chart in
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .onTapGesture(perform: { value in
                            
                            let currentX = value.x - geometry[chart.plotAreaFrame].origin.x
                            guard currentX >= 0, currentX < chart.plotAreaSize.width else {
                                return
                            }
                            
                            guard let index = chart.value(atX: currentX, as: String.self) else {
                                return
                            }
                            
                            selectedPoint = index
                        })
                }
            }
    }
}

struct ActivityGraph_Previews: PreviewProvider {
    static var previews: some View {
        ActivityGraph(points: PreviewModels.expensesPoints, currencySymbol: "USD".currencySymbol)
    }
}
