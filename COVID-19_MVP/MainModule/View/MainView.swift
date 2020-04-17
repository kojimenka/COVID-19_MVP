//
//  MainView.swift
//  COVID-19_MVP
//
//  Created by Дмитрий Марченков on 17.04.2020.
//  Copyright © 2020 Дмитрий Марченков. All rights reserved.
//

import UIKit

final class MainView {
    
    public let tableView : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(MainTableViewCell.self, forCellReuseIdentifier: "MyCell")
        table.rowHeight = 60
        return table
    }()
    
}
