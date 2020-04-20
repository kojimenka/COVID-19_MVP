//
//  Router.swift
//  COVID-19_MVP
//
//  Created by Дмитрий Марченков on 17.04.2020.
//  Copyright © 2020 Дмитрий Марченков. All rights reserved.
//

import UIKit

protocol RouterProtocol {
    var navigationController : UINavigationController? { get set }
    var assemblyBuilder      : AssemblyBuilder? { get set }
}

protocol MainRouter : RouterProtocol {
    func initialController()
    func detailController(daysInfo: [DayInfo]?, countryName : String)
}

final class Router : MainRouter {
        
    var navigationController : UINavigationController?
    var assemblyBuilder      : AssemblyBuilder?
    
    init(navigationController : UINavigationController?, assemblyBuilder : AssemblyBuilder?) {
        self.navigationController = navigationController
        self.assemblyBuilder      = assemblyBuilder
    }
    
    public func initialController () {
        guard let navigationController = navigationController else { return }
        guard let assemblyBuilder      = assemblyBuilder else { return }
        let mainVC = assemblyBuilder.createMainModule(router: self)
        navigationController.viewControllers = [mainVC]
    }
    
    
    public func detailController(daysInfo: [DayInfo]?, countryName : String) {
        guard let navigationController = navigationController else { return }
        guard let assemblyBuilder      = assemblyBuilder else { return }
        
        let detailVC = assemblyBuilder.createDetailModule(router: self,
                                                          daysInfo: daysInfo,
                                                          countryName: countryName)
        
        navigationController.pushViewController(detailVC, animated: true)
    }
}
