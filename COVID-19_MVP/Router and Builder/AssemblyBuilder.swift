//
//  AssemblyBuilder.swift
//  COVID-19_MVP
//
//  Created by Дмитрий Марченков on 17.04.2020.
//  Copyright © 2020 Дмитрий Марченков. All rights reserved.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule (router: MainRouter) -> UIViewController
    func createDetailModule (router : MainRouter, daysInfo: [DayInfo]?, countryName : String) -> UIViewController
}

final class AssemblyBuilder : AssemblyBuilderProtocol {
    
    func createMainModule(router: MainRouter) -> UIViewController {
        let mainVC    = MainViewController()
        let mainModel = MainModel()
        let presenter = MainViewPresenter(view: mainVC,
                                          router: router,
                                          model: mainModel)
        mainVC.presenter = presenter
        return mainVC
    }
    
    func createDetailModule(router: MainRouter, daysInfo: [DayInfo]?, countryName : String) -> UIViewController {
        let view = DetailViewController()
        let presenter = DetailViewPresenter(view: view,
                                            router: router,
                                            daysInfo: daysInfo?.reversed(),
                                            countryName: countryName)
        view.presenter = presenter
        return view
    }
    
}

