//
//  MainModel.swift
//  COVID-19_MVP
//
//  Created by Дмитрий Марченков on 17.04.2020.
//  Copyright © 2020 Дмитрий Марченков. All rights reserved.
//

import Foundation

protocol MainModelProtocol : class {
    func getLastData (completion : @escaping (Result<[CountryInfo], Error>) -> Void)
}

final class MainModel : MainModelProtocol {
    
    init() {
        print("MainModel was init")
    }
    
    deinit {
        print("MainModel was deinit")
    }
    
    private let networkService = NetworkServices()
    private let persistanceService = PersistanceService()
    
    public func getLastData (completion : @escaping (Result<[CountryInfo], Error>) -> Void) {
        let lastUpdate = UserDefaults.standard.integer(forKey: UserDefaultsName.lastUpdate.rawValue)
        
        if lastUpdate == Date.currentDay() {
            persistanceService.fetchFromCoreData { result in
                var countryInfoArray = [CountryInfo]()
                for data in result {
                    countryInfoArray.append(data)
                }
                
                countryInfoArray.sort { $0.dayInfo!.allDaysInfo.last!.confirmed! > $1.dayInfo!.allDaysInfo.last!.confirmed! }
                print("Download current data")
                completion(.success(countryInfoArray))
            }
        } else {
            persistanceService.deleteAllData()
            networkService.getCurrentInfo() { [weak self] (result) in
                switch result {
                case .success(let data):
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : [[String : Any]] ] else { return }
                        var allCounries = [String]()
                        
                        for (key, _) in json {
                            allCounries.append(key)
                        }
                        
                        for country in allCounries {
                            let allDaysInCountry = json[country]
                            var allDaysArray = [DayInfo]()
                            
                            for dayInfo in allDaysInCountry! {
                                let day = try JSONSerialization.data(withJSONObject: dayInfo, options: [])
                                allDaysArray.append(try JSONDecoder().decode(DayInfo.self, from: day))
                            }
                            
                            print(country, allDaysArray)
                            self?.persistanceService.saveToCoreData(country: country, allDaysInfo: allDaysArray)
                            allDaysArray.removeAll()
                        }
                        
                    } catch {
                        print(error)
                    }
                    
                    self?.persistanceService.fetchFromCoreData { result in
                        var countryInfoArray = [CountryInfo]()
                        for data in result {
                            countryInfoArray.append(data)
                        }
                        
                        countryInfoArray.sort { $0.dayInfo!.allDaysInfo.last!.confirmed! > $1.dayInfo!.allDaysInfo.last!.confirmed! }
                        UserDefaults.standard.set(Date.currentDay(), forKey: UserDefaultsName.lastUpdate.rawValue)
                        print("Download new data")
                        completion(.success(countryInfoArray))
                    }
                    
                case .failure(let err):
                    completion(.failure(err))
                }
            }
        }
        
    }
    
}
