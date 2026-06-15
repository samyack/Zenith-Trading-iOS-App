//
//  FinancialCharView.swift
//  Zenith Trading
//
//  Created by Samyack on 27/05/26.
//

import SwiftUI
import Charts

// MARK: - Data Model
struct OHLCData: Identifiable {
    let id = UUID()
    let date: Date
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    
    var isBullish: Bool { close >= open }
}

// MARK: - Main View
struct FinancialChartView: View {
    // Your raw API response
    let rawResponse: [[Double]] = [[1779793200000,77113.0,77448.0,77113.0,77398.0],[1779795000000,77363.0,77363.0,77157.0,77163.0],[1779796800000,77185.0,77185.0,77109.0,77125.0],[1779798600000,77125.0,77125.0,76893.0,76893.0],[1779800400000,76964.0,77015.0,76950.0,77004.0],[1779802200000,77042.0,77042.0,76731.0,76731.0],[1779804000000,76701.0,77148.0,76701.0,77148.0],[1779805800000,77146.0,77881.0,77134.0,77881.0],[1779807600000,77514.0,77514.0,76778.0,76869.0],[1779809400000,76728.0,76839.0,76612.0,76631.0],[1779811200000,76369.0,76450.0,76223.0,76384.0],[1779813000000,76348.0,76416.0,76262.0,76416.0],[1779814800000,76471.0,76581.0,76364.0,76364.0],[1779816600000,76436.0,76512.0,76142.0,76142.0],[1779818400000,76004.0,76004.0,75810.0,75906.0],[1779820200000,75843.0,76128.0,75843.0,75999.0],[1779822000000,75999.0,75999.0,75724.0,75724.0],[1779823800000,75758.0,75801.0,75745.0,75801.0],[1779825600000,75823.0,75962.0,75823.0,75931.0],[1779827400000,75948.0,76037.0,75939.0,76037.0],[1779829200000,76004.0,76004.0,75938.0,75995.0],[1779831000000,75994.0,75994.0,75916.0,75916.0],[1779834600000,75856.0,75856.0,75686.0,75686.0],[1779836400000,75723.0,75723.0,75607.0,75637.0],[1779840000000,75846.0,75848.0,75822.0,75822.0],[1779843600000,75870.0,75870.0,75870.0,75870.0],[1779845400000,75921.0,75958.0,75749.0,75779.0],[1779847200000,75768.0,75851.0,75764.0,75787.0],[1779849000000,75739.0,75739.0,75629.0,75680.0],[1779850800000,75664.0,75710.0,75627.0,75710.0],[1779852600000,75802.0,75847.0,75722.0,75735.0],[1779854400000,75713.0,75713.0,75555.0,75555.0],[1779856200000,75549.0,75583.0,75405.0,75411.0],[1779858000000,75259.0,75478.0,75220.0,75478.0],[1779859800000,75505.0,75571.0,75501.0,75571.0],[1779861600000,75543.0,75610.0,75521.0,75610.0],[1779863400000,75630.0,75675.0,75607.0,75627.0],[1779865200000,75651.0,75752.0,75651.0,75719.0],[1779867000000,75754.0,75754.0,75671.0,75744.0],[1779868800000,75752.0,75858.0,75752.0,75858.0],[1779870600000,75874.0,75944.0,75796.0,75944.0],[1779872400000,75904.0,75904.0,75784.0,75784.0],[1779874200000,75755.0,75755.0,75622.0,75712.0],[1779876000000,75745.0,75827.0,75745.0,75795.0],[1779877800000,75774.0,75896.0,75774.0,75896.0]]
    
    // Parsed data
    var chartData: [OHLCData] {
        rawResponse.compactMap { point in
            guard point.count == 5 else { return nil }
            return OHLCData(
                date: Date(timeIntervalSince1970: point[0] / 1000),
                open: point[1],
                high: point[2],
                low: point[3],
                close: point[4]
            )
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Asset Price Chart")
                .font(.title2.bold())
                .padding([.top, .leading])
            
            Chart {
                ForEach(chartData) { item in
                    // Wick (High/Low)
                    RuleMark(
                        x: .value("Date", item.date),
                        yStart: .value("Low", item.low),
                        yEnd: .value("High", item.high)
                    )
                    .foregroundStyle(item.isBullish ? .green : .red)
                    
                    // Body (Open/Close)
                    BarMark(
                        x: .value("Date", item.date),
                        yStart: .value("Open", item.open),
                        yEnd: .value("Close", item.close),
                        width: .fixed(4)
                    )
                    .foregroundStyle(item.isBullish ? .green : .red)
                }
            }
            // Essential: Zoom into the price range
            .chartYScale(domain: .automatic(includesZero: false))
            // Format X-Axis for time
            .chartXAxis {
                AxisMarks(values: .stride(by: .hour, count: 6)) { value in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.hour().minute())
                }
            }
            .frame(height: 400)
            .padding()
            
            Spacer()
        }
    }
}

// MARK: - Preview
#Preview {
    FinancialChartView()
}
