//
//  ActivityGraph.swift
//  Banking
//
//  Created by Karen Mirakyan on 22.03.23.
//

import SwiftUI
import Charts


struct ActivityGraph: View {
    let points: [ExpensePointViewModel]
    let currencySymbol: String
    @State private var location: CGPoint = .zero
    @State private var amount: Decimal = 0
    @State private var selectedPoint: String? = nil
    @Environment(\.colorScheme) var colorScheme

    
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

            ForEach(points, id: \.self) { point in

                if let selectedPoint, selectedPoint == point.interval {
                    RectangleMark(
                        x: .value(LocalizedStringResource.weekDay, point.interval),
                        yStart: .value(LocalizedStringResource.amount, 0),
                        yEnd: .value(LocalizedStringResource.amount, point.amount + 1),
                        width: 24
                    ).foregroundStyle(rectangleMarkGradient)
                        .cornerRadius(8)
                        .opacity(0.8)

                    PointMark(
                        x: .value(LocalizedStringResource.weekDay, point.interval),
                        y: .value(LocalizedStringResource.amount, point.amount)
                        )
                    .annotation(alignment: .bottom, spacing: 0) {

                        VStack(spacing: 0) {
                            TextHelper(text: "\(currencySymbol) \(point.amount)", color: colorScheme == .light ? .white : .black, fontName: .medium, fontSize: 10)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 5)
                                .background {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(colorScheme == .light ? .black : .white)
                                }

                            Rectangle()
                                .fill(colorScheme == .light ? .black : .white)
                                .frame(width: 0.5, height: 40)
                        }

                    }.foregroundStyle(Color(.darkBlue))
                        .interpolationMethod(.catmullRom)

                }

                LineMark(
                    x: .value(LocalizedStringResource.weekDay, point.interval),
                    y: .value(LocalizedStringResource.amount, point.amount)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(Color(.appGreen))
                .lineStyle(StrokeStyle(lineWidth: 3))
                .accessibilityHidden(false)

                AreaMark(
                    x: .value(LocalizedStringResource.weekDay, point.interval),
                    y: .value(LocalizedStringResource.amount, point.amount)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(curGradient)

            }
        }.chartYAxis(.hidden)
            .chartPlotStyle { plotArea in
                plotArea
                    .background(colorScheme == .light ? .white : .black)
            }.chartYScale(domain: 0...Int((points.map{Int(truncating: $0.amount as NSNumber)}.max() ?? 75) ))
            .chartXAxis() {
                AxisMarks(position: .bottom) { value in
                    AxisValueLabel() {
                         if let strValue = value.as(String.self) {
                             Text("\(strValue)")
                                 .minimumScaleFactor(0.4)
                         }
                     }
                }
            }
            .frame(height:150)
            .chartOverlay { proxy in
                ChartOverlayView(chart: proxy, selectedPoint: $selectedPoint)
            }


    }
}

struct ChartOverlayView: View {
    let chart: ChartProxy
    @Binding var selectedPoint: String?

    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0).onChanged { value in
                        guard let plotAnchor = chart.plotFrame else {
                            return
                        }
                        let plotRect = geometry[plotAnchor]
                        let locX = value.location.x
                        let currentX = locX - plotRect.origin.x

                        guard currentX >= 0, currentX < chart.plotSize.width else {
                            return
                        }

                        if let index: String = chart.value(atX: currentX, as: String.self) {
                            selectedPoint = index
                        }
                    }
                )
        }
    }
}


struct ActivityGraph_Previews: PreviewProvider {
    static var previews: some View {
        ActivityGraph(points: PreviewModels.expensesPoints.map(ExpensePointViewModel.init), currencySymbol: "USD".currencySymbol)
    }
}
