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
    func showFilterData()
}

protocol MainViewPresenterProtocol : class {
    init(view : MainViewProtocol, router : MainRouter, model : MainModelProtocol)
    var allCountriesInfo : [CountryInfo]? { get }
    var changedCountriesInfoArray : [CountryInfo]? { get }
    var isSearchBarEmpty : Bool? { get }
    var isFiltering      : Bool? { get }
    func getData()
    func presentDetailModule(daysInfo: [DayInfo]?, countryName : String)
    func filterArray (searchText : String)
}

final class MainViewPresenter : MainViewPresenterProtocol {
    
    private weak var view   : MainViewProtocol?
    private var router      : MainRouter
    private var model       : MainModelProtocol
    
    public var allCountriesInfo: [CountryInfo]?
    public var changedCountriesInfoArray: [CountryInfo]?
    
    var isFiltering      : Bool? = false
    var isSearchBarEmpty : Bool? = false
    
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
    
    func filterArray (searchText : String) {
        isSearchBarEmpty = searchText ==  "" ? true : false
        isFiltering      = searchText != "" && isSearchBarEmpty == false ? true : false
        
        changedCountriesInfoArray = allCountriesInfo?.filter { ($0.country?.lowercased().contains(searchText.lowercased()) ?? false)}
        self.view?.showFilterData()
    }
    
}
