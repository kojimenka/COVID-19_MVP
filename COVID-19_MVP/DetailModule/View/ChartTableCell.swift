//
//  ChartTableCell.swift
//  COVID-19_MVP
//
//  Created by Дмитрий Марченков on 19.04.2020.
//  Copyright © 2020 Дмитрий Марченков. All rights reserved.
//

import UIKit
import AAInfographics

final class DetailChartCell: UITableViewCell {
    
    public var dataForChart : [DayInfo]? {
        didSet {
            guard let unwrappedData = dataForChart else { return }
            drawChart(unwrappedData: unwrappedData.reversed())
        }
    }
    
    private var aaChartView : AAChartView = {
        let chartView = AAChartView()
        chartView.scrollEnabled = false
        chartView.isClearBackgroundColor = true
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.backgroundColor = .chartColor
        return chartView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: .default, reuseIdentifier: "DetailCell")
        setLocalConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLocalConstraints() {
        contentView.addSubview(aaChartView)
        
        NSLayoutConstraint.activate([
            aaChartView.topAnchor.constraint(equalTo: contentView.topAnchor),
            aaChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            aaChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            aaChartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func drawChart (unwrappedData : [DayInfo]) {
        let chart = AAChartModel()
        chart
            .chartType(.spline)//Can be any of the chart types listed under `AAChartType`.
            .animationType(.linear)
            .title("")//The chart title
            .subtitle("")//The chart subtitle
            .colorsTheme(["#003366"])
            .backgroundColor("#00000000")
            .legendEnabled(false)
            .xAxisVisible(true)
            .yAxisVisible(true)
            .xAxisLabelsEnabled(false)
            .zoomType(.x)
            .animationDuration(900)
            .yAxisGridLineWidth(0)
            .tooltipValueSuffix(" Человек")
            .colorsTheme(["#fe117c","#ffc069","#06caf4"])
            .categories(unwrappedData.compactMap{$0.date})
            .series([
                AASeriesElement()
                    .name("Заболевших")
                    .data(unwrappedData.compactMap{$0.confirmed}),
                AASeriesElement()
                    .name("Умерших")
                    .data(unwrappedData.compactMap{$0.deaths}),
                AASeriesElement()
                    .name("Выздоровевших")
                    .data(unwrappedData.compactMap{$0.recovered}),
            ])
        
        
        aaChartView.aa_drawChartWithChartModel(chart)
    }
    
}
