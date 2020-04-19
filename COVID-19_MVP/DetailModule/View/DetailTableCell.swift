//
//  DetailTableCell.swift
//  COVID-19
//
//  Created by Дмитрий Марченков on 22.03.2020.
//  Copyright © 2020 Дмитрий Марченков. All rights reserved.
//

import UIKit

final class DetailTableCell: UITableViewCell {
    
    public var dataForDisplay : (currentDay : DayInfo, previousDay : DayInfo, thirdDay : DayInfo)? {
        didSet {
            guard let unwrappedData = dataForDisplay else { return }
            
            let currentDayConfirmed = unwrappedData.currentDay.confirmed! - unwrappedData.previousDay.confirmed!
            let currentDayDeaths    = unwrappedData.currentDay.deaths!    - unwrappedData.previousDay.deaths!
            let currendDayRecovered = unwrappedData.currentDay.recovered! - unwrappedData.previousDay.recovered!
            
            let secondDayConfirmed = unwrappedData.previousDay.confirmed! - unwrappedData.thirdDay.confirmed!
            let secondDayDeaths    = unwrappedData.previousDay.deaths!    - unwrappedData.thirdDay.deaths!
            let secondDayRecovered = unwrappedData.previousDay.recovered! - unwrappedData.thirdDay.recovered!
            
            confirmedLabel.text = "\(currentDayConfirmed)"
            deathLabel.text     = "\(currentDayDeaths)"
            recoveredLabel.text = "\(currendDayRecovered)"
            
            setDate(date: unwrappedData.currentDay.date)
            
            if currentDayConfirmed > secondDayConfirmed {
                confirmedArrowImageView.image = UIImage(named: ImageNames.growUp.rawValue)?.withRenderingMode(.alwaysTemplate)
                confirmedArrowImageView.tintColor = .systemGreen
            } else {
                confirmedArrowImageView.image = UIImage(named: ImageNames.growDown.rawValue)?.withRenderingMode(.alwaysTemplate)
                confirmedArrowImageView.tintColor = .systemRed
            }
            
            if currentDayDeaths > secondDayDeaths {
                deathArrowImageView.image = UIImage(named: ImageNames.growUp.rawValue)?.withRenderingMode(.alwaysTemplate)
                deathArrowImageView.tintColor = .systemGreen
            } else {
                deathArrowImageView.image = UIImage(named: ImageNames.growDown.rawValue)?.withRenderingMode(.alwaysTemplate)
                deathArrowImageView.tintColor = .systemRed
            }
            
            if currendDayRecovered > secondDayRecovered {
                recoveredArrowImageView.image = UIImage(named: ImageNames.growUp.rawValue)?.withRenderingMode(.alwaysTemplate)
                recoveredArrowImageView.tintColor = .systemGreen
            } else {
                recoveredArrowImageView.image = UIImage(named: ImageNames.growDown.rawValue)?.withRenderingMode(.alwaysTemplate)
                recoveredArrowImageView.tintColor = .systemRed
            }
        }
    }

    private let confirmedContainer = UIView.createContainerView()
    private let deathContainer     = UIView.createContainerView()
    private let recoveredContainer = UIView.createContainerView()
    
    private let dateLabel      = UILabel.createDetailLabel(textColor: UIColor(named: ColorsNames.textColor.rawValue)!)
    private let confirmedLabel = UILabel.createDetailLabel(textColor: .gray)
    private let deathLabel     = UILabel.createDetailLabel(textColor: UIColor(named: ColorsNames.darkRedColor.rawValue)!)
    private let recoveredLabel = UILabel.createDetailLabel(textColor: UIColor(named: ColorsNames.darkGreenColor.rawValue)!)
    
    private let confirmedArrowImageView = UIImageView.createDetailImageView(imageName: ImageNames.growDown.rawValue,
                                                                           color: .red)
    private let deathArrowImageView     = UIImageView.createDetailImageView(imageName: ImageNames.growDown.rawValue,
                                                                           color: .red)
    private let recoveredArrowImageView = UIImageView.createDetailImageView(imageName: ImageNames.growDown.rawValue,
                                                                           color: .red)
    
    private let confirmedIconImageView = UIImageView.createDetailImageView(imageName: ImageNames.confirmed.rawValue,
                                                                           color: UIColor(named: ColorsNames.textColor.rawValue)!)
    private let deathIconImageView     = UIImageView.createDetailImageView(imageName: ImageNames.death.rawValue,
                                                                           color: UIColor(named: ColorsNames.textColor.rawValue)!)
    private let recoveredIconImageView = UIImageView.createDetailImageView(imageName: ImageNames.recovered.rawValue,
                                                                           color: UIColor(named: ColorsNames.textColor.rawValue)!)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: .default, reuseIdentifier: "MyCell")
        setLocalConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLocalConstraints() {
        contentView.addSubview(confirmedContainer)
        contentView.addSubview(deathContainer)
        contentView.addSubview(recoveredContainer)
        
        confirmedContainer.addSubview(confirmedLabel)
        confirmedContainer.addSubview(confirmedArrowImageView)
        
        deathContainer.addSubview(deathLabel)
        deathContainer.addSubview(deathArrowImageView)
        
        recoveredContainer.addSubview(recoveredLabel)
        recoveredContainer.addSubview(recoveredArrowImageView)
        
        contentView.addSubview(confirmedIconImageView)
        contentView.addSubview(deathIconImageView)
        contentView.addSubview(recoveredIconImageView)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: +15)
        ])
        
        NSLayoutConstraint.activate([
            confirmedContainer.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: +5),
            confirmedContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.33),
            confirmedContainer.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        setContainerConstraints(previousConteiner: confirmedContainer, currentContainer: deathContainer)
        setContainerConstraints(previousConteiner: deathContainer, currentContainer: recoveredContainer)
        
        setConstraintsInContainer(label: confirmedLabel, imageView: confirmedArrowImageView, container: confirmedContainer)
        setConstraintsInContainer(label: deathLabel,     imageView: deathArrowImageView,     container: deathContainer)
        setConstraintsInContainer(label: recoveredLabel, imageView: recoveredArrowImageView, container: recoveredContainer)
        
        setIconConstraints(imageView: confirmedIconImageView, container: confirmedContainer)
        setIconConstraints(imageView: deathIconImageView,     container: deathContainer)
        setIconConstraints(imageView: recoveredIconImageView, container: recoveredContainer)
    }
    
    private func setContainerConstraints (previousConteiner : UIView, currentContainer : UIView) {
        NSLayoutConstraint.activate([
            currentContainer.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: +5),
            currentContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.33),
            currentContainer.heightAnchor.constraint(equalToConstant: 40),
            currentContainer.leadingAnchor.constraint(equalTo: previousConteiner.trailingAnchor)
        ])
    }
    
    private func setConstraintsInContainer (label : UILabel, imageView : UIImageView, container : UIView) {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: +5),
            imageView.widthAnchor.constraint(equalToConstant: 15),
            imageView.heightAnchor.constraint(equalToConstant: 15),
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
    
    private func setIconConstraints (imageView : UIImageView, container : UIView) {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func setDate (date : String?) {
        guard let unwrappedDate = date else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: unwrappedDate)
        
        let newDate = DateFormatter()
        newDate.locale = Locale(identifier: "en_US")
        newDate.dateStyle = .long
        
        let newStringDate = newDate.string(from: date!)
        dateLabel.text = newStringDate
    }
    
}


extension UILabel {
    static func createDetailLabel (textColor : UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica-Bold", size: 18)
        label.textColor = textColor
        label.textAlignment = .center
        return label
    }
}

extension UIImageView {
    static func createDetailImageView (imageName : String, color : UIColor) -> UIImageView {
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = color
        return imageView
    }
}

extension UIView {
    static func createContainerView () -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

