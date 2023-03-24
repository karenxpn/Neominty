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
    @State private var location: CGPoint = .zero
    @State private var amount: Double = 0
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
            
            ForEach(points, id: \.id) {
                LineMark(
                    x: .value("Week Day", $0.unit),
                    y: .value("Step Count", $0.amount)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(AppColors.green)
                .lineStyle(StrokeStyle(lineWidth: 3))
                .accessibilityHidden(false)
                
                AreaMark(
                    x: .value("Week Day", $0.unit),
                    y: .value("Step Count", $0.amount)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(curGradient)
                
            }
        }.chartYAxis(.hidden)
            .chartPlotStyle { plotArea in
                plotArea
                    .background(.white)
            }
            .chartXAxis() {
                AxisMarks(position: .bottom)
            }
            .frame(height:150)
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .onTapGesture(perform: { value in
                            let origin = geometry[proxy.plotAreaFrame].origin
                            
                            location = CGPoint(
                                x: value.x - origin.x,
                                y: value.y - origin.y
                            )
                            // Get the x (date) and y (price) value from the location.
                            let (unit, amount) = proxy.value(at: location, as: (String, Double).self) ?? ("", 0)
                            self.amount = points.first(where: { $0.unit == unit})?.amount ?? 0
                            print("Location: \(unit), \(amount)")
                        }).overlay {
                            if location != .zero {
                                VStack(spacing: 0) {
                                    TextHelper(text: "$ \(self.amount)", color: .white, fontName: Roboto.medium.rawValue, fontSize: 10)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 5)
                                        .background {
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(.black)
                                        }
                                    
                                    Rectangle()
                                        .fill(Color.black)
                                        .frame(width: 0.5, height: 48)
                                    
                                    
                                    ZStack {
                                        
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 4, height: 4)
                                        
                                        Circle()
                                            .strokeBorder(Color.black, lineWidth: 2)
                                            .frame(width: 8, height: 8)
                                        
                                    }
                                }.position(location)
                                
                            }
                        }
                }
            }
    }
}

struct ActivityGraph_Previews: PreviewProvider {
    static var previews: some View {
        ActivityGraph(points: PreviewModels.expensesPoints)
    }
}
