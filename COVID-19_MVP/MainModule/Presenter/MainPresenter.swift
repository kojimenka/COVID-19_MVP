//
//  MainPresenter.swift
//  COVID-19_MVP
//
//  Created by Дмитрий Марченков on 17.04.2020.
//  Copyright © 2020 Дмитрий Марченков. All rights reserved.
//

import Foundation

protocol MainViewProtocol : class {
    func successDownloadData ()
    func failureDownloadData ()
}

protocol MainViewPresenterProtocol : class {
    init(view : MainViewProtocol, router : MainRouter, model : MainModelProtocol)
    var allCountriesInfo : [CountryInfo]? { get }
    func getData()
    func presentDetailModule(daysInfo: [DayInfo]?, countryName : String)
}

final class MainViewPresenter : MainViewPresenterProtocol {
    
    private weak var view   : MainViewProtocol?
    private var router      : MainRouter
    private var model       : MainModelProtocol
    
    public var allCountriesInfo: [CountryInfo]?
    
    init(view: MainViewProtocol, router: MainRouter, model : MainModelProtocol) {
        self.view   = view
        self.router = router
        self.model  = model
        getData()
    }
    
    func getData() {
        model.getLastData { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let err):
                print(err)
                self.allCountriesInfo = nil
                self.view?.failureDownloadData()
            case .success(let data):
                self.allCountriesInfo = data
                self.view?.successDownloadData()
            }
        }
    }
    
    func presentDetailModule(daysInfo: [DayInfo]?, countryName : String) {
        router.detailController(daysInfo: daysInfo, countryName: countryName)
    }
    
}
