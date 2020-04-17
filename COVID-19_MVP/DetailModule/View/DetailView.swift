//
//  DetailView.swift
//  COVID-19_MVP
//
//  Created by Дмитрий Марченков on 17.04.2020.
//  Copyright © 2020 Дмитрий Марченков. All rights reserved.
//

import UIKit

final class DetailView {
    
    init() {
        print("DetailView was init")
    }
    
    deinit {
        print("DetailView was deint")
    }
    
    public let detailTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 120
        tableView.separatorColor = .gray
        tableView.backgroundColor = .backgroundColor
        tableView.register(DetailTableCell.self, forCellReuseIdentifier: "MyCell")
        //tableView.register(DetailChartCell.self, forCellReuseIdentifier: "DetailCell")
        return tableView
    }()

}
