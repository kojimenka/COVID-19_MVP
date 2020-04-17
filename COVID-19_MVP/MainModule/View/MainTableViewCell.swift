//
//  MainTableViewCell.swift
//  COVID-19_MVP
//
//  Created by Дмитрий Марченков on 17.04.2020.
//  Copyright © 2020 Дмитрий Марченков. All rights reserved.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    
    public let countryLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica-Bold", size: 18)
        return label
    }()
    
    public let confirmedLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica-Bold", size: 18)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: .default, reuseIdentifier: "MyCell")
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints () {
        contentView.addSubview(countryLabel)
        contentView.addSubview(confirmedLabel)
        
        NSLayoutConstraint.activate([
            countryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: +15),
            countryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            confirmedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            confirmedLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
 
}
