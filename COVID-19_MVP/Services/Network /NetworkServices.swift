//
//  InternetServices.swift
//  COVID-19_MVP
//
//  Created by Дмитрий Марченков on 17.04.2020.
//  Copyright © 2020 Дмитрий Марченков. All rights reserved.
//

import Foundation

protocol NetworkServicesProtocol {
    func getCurrentInfo (completionHandler : @escaping (Result<Data, Error>) -> Void)
}

final class NetworkServices : NetworkServicesProtocol {
    
    public func getCurrentInfo(completionHandler : @escaping (Result<Data, Error>) -> Void ) {
        let urlPath = "https://pomber.github.io/covid19/timeseries.json"
        let url = URL(string: urlPath)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, err) in
            if let error = err {
                completionHandler(.failure(error as NSError))
            } else if let unwrappedData = data {
                completionHandler(.success(unwrappedData))
            }
        }
        
        task.resume()
    }
    
}
