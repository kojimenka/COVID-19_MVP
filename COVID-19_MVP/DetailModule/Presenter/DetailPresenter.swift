//
//  DetailPresenter.swift
//  COVID-19_MVP
//
//  Created by Дмитрий Марченков on 17.04.2020.
//  Copyright © 2020 Дмитрий Марченков. All rights reserved.
//

import Foundation

enum EditChart : String {
    case firstDead
    case firstRecovered
    case firstConfirmed
}

protocol DetailViewProtocol : class {
    func showUpdateChart()
}

protocol DetailPresenterProtocol {
    init(view : DetailViewProtocol, router : MainRouter, daysInfo : [DayInfo]?, countryName : String)
    var daysInfo : [DayInfo]? { get }
    var countryName : String  { get }
    
    func updateChart (edit : EditChart)
}

final class DetailViewPresenter : DetailPresenterProtocol {
        
    private weak var view : DetailViewProtocol?
    public var router       : MainRouter?
    
    var daysInfo: [DayInfo]?
    var countryName: String
    
    init(view: DetailViewProtocol, router: MainRouter, daysInfo: [DayInfo]?, countryName : String) {
        self.view        = view
        self.router      = router
        self.daysInfo    = daysInfo
        self.countryName = countryName
    }
    
    func updateChart(edit: EditChart) {
        switch edit {
        case .firstConfirmed:
            daysInfo = daysInfo?.filter{$0.confirmed! > 0}
        case .firstDead:
            daysInfo = daysInfo?.filter{$0.deaths! > 0}
        case .firstRecovered:
            daysInfo = daysInfo?.filter{$0.recovered! > 0}
        }
        view?.showUpdateChart()
    }
        
}
