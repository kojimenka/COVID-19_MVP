//
//  DetailTableCell.swift
//  COVID-19
//
//  Created by Дмитрий Марченков on 22.03.2020.
//  Copyright © 2020 Дмитрий Марченков. All rights reserved.
//

import UIKit

final class DetailTableCell: UITableViewCell {
    
    public let dateLabel : UILabel = {
        let mainLabel = UILabel()
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        return mainLabel
    }()
    
    public let confirmedLabel : UILabel = {
        let mainLabel = UILabel()
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        mainLabel.textColor = .gray
        return mainLabel
    }()
    
    public let deathLabel : UILabel = {
        let mainLabel = UILabel()
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        mainLabel.textColor = .darkRedColor
        return mainLabel
    }()
    
    public let recoveredLabel : UILabel = {
        let mainLabel = UILabel()
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        mainLabel.textColor = .darkGreenColor
        return mainLabel
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: .default, reuseIdentifier: "MyCell")
        setLocalConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLocalConstraints() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(confirmedLabel)
        contentView.addSubview(deathLabel)
        contentView.addSubview(recoveredLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: +15),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            confirmedLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            confirmedLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: +15)
        ])
        
        NSLayoutConstraint.activate([
            deathLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            deathLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            recoveredLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            recoveredLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
        ])
        
    }

}
