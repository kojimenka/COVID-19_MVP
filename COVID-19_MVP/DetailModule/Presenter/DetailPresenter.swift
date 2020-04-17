//
//  DetailPresenter.swift
//  COVID-19_MVP
//
//  Created by Дмитрий Марченков on 17.04.2020.
//  Copyright © 2020 Дмитрий Марченков. All rights reserved.
//

import Foundation

protocol DetailViewProtocol : class {
    
}

protocol DetailPresenterProtocol {
    init(view : DetailViewProtocol, router : MainRouter, daysInfo : [DayInfo]?, countryName : String)
    var daysInfo : [DayInfo]? { get }
    var countryName : String  { get }
}

final class DetailViewPresenter : DetailPresenterProtocol {
    
    private weak var view : DetailViewProtocol?
    var router       : MainRouter?
    
    var daysInfo: [DayInfo]?
    var countryName: String
    
    init(view: DetailViewProtocol, router: MainRouter, daysInfo: [DayInfo]?, countryName : String) {
        self.view        = view
        self.router      = router
        self.daysInfo    = daysInfo
        self.countryName = countryName
    }
    
}
