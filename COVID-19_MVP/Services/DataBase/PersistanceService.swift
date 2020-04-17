//
//  PersistanceService.swift
//  COVID-19
//
//  Created by Дмитрий Марченков on 22.03.2020.
//  Copyright © 2020 Дмитрий Марченков. All rights reserved.
//

import Foundation
import CoreData

final class PersistanceService {
    
    init() {
        print("PersistanceService was init")
    }
    
    deinit {
        print("PersistanceService was deinit")
    }
    
    private var context : NSManagedObjectContext { return persistentContainer.viewContext }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "COVID_19_MVP")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    public func saveToCoreData (country : String, allDaysInfo : [DayInfo] ) {
        let entity = NSEntityDescription.entity(forEntityName: "CountryInfo", in: context)!
        
        let manageObject = NSManagedObject(entity: entity, insertInto: context) as! CountryInfo
        let allDaysInfo  = AllDaysInfo(allDaysInfo: allDaysInfo)
        
        manageObject.setValue(allDaysInfo, forKeyPath: "dayInfo")
        manageObject.country = country
        
        do {
            try context.save()
            print(country, "save success")
        } catch {
            print(error)
        }
    }
    
    public func fetchFromCoreData (completion : ([CountryInfo]) -> Void ) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountryInfo")
        
        do {
            let result = try! context.fetch(fetchRequest)
            completion(result as! [CountryInfo])
        }
    }
    
    public func deleteAllData () {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountryInfo")
        
        if let result = try? context.fetch(fetchRequest) {
            for object in result {
                context.delete(object as? NSManagedObject ?? NSManagedObject())
            }
        }
        
        do {
            try context.save()
            print("delete successful")
        } catch {
            print(error)
        }
        
    }
    
}

public class AllDaysInfo : NSObject, NSCoding {
    public var allDaysInfo : [DayInfo] = []
    
    enum Keys : String {
        case allDaysInfo
    }
    
    init(allDaysInfo : [DayInfo]) {
        self.allDaysInfo = allDaysInfo
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(allDaysInfo, forKey: Keys.allDaysInfo.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let decodeAllDaysInfo = aDecoder.decodeObject(forKey: Keys.allDaysInfo.rawValue) as! [DayInfo]
        self.init(allDaysInfo : decodeAllDaysInfo)
    }
    
    
}


public class DayInfo : NSObject, NSCoding, Codable {
    
    public var date      : String = ""
    public var confirmed : Int?   = 0
    public var recovered : Int?   = 0
    public var deaths    : Int?   = 0
    
    enum Keys : String {
        case date
        case confirmed
        case recovered
        case deaths
    }
    
    init(date : String, confirmed : Int?, recovered : Int?, deaths : Int?) {
        self.date = date
        self.confirmed = confirmed ?? 0
        self.recovered = recovered ?? 0
        self.deaths = deaths ?? 0
    }
    
    public override init () {
        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(date,      forKey: Keys.date.rawValue)
        aCoder.encode(confirmed, forKey: Keys.confirmed.rawValue)
        aCoder.encode(recovered, forKey: Keys.recovered.rawValue)
        aCoder.encode(deaths,    forKey: Keys.deaths.rawValue)

    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let decodeDate      = aDecoder.decodeObject(forKey: Keys.date.rawValue) as! String
        let decodeConfirmed = aDecoder.decodeObject(forKey: Keys.confirmed.rawValue) as? Int ?? 0
        let decodeRecovered = aDecoder.decodeObject(forKey: Keys.recovered.rawValue) as? Int ?? 0
        let decodeDeaths    = aDecoder.decodeObject(forKey: Keys.deaths.rawValue) as? Int ?? 0
        
        self.init(date      : decodeDate,
                  confirmed : Int(decodeConfirmed),
                  recovered : Int(decodeRecovered),
                  deaths    : Int(decodeDeaths))
    }
    
    
}

