//
//  DetailViewController.swift
//  COVID-19_MVP
//
//  Created by Дмитрий Марченков on 17.04.2020.
//  Copyright © 2020 Дмитрий Марченков. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    
    public var presenter   : DetailPresenterProtocol!
    private var detailView = DetailView()
    
    private var detailTableView = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textColor!]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setConstraints()
    }
    
    private func setupView () {
        title = presenter.countryName
    }
    
    private func setupTableView () {
        detailTableView = detailView.detailTableView
        detailTableView.dataSource = self
        detailTableView.delegate   = self
    }
    
    private func setConstraints () {
        view.addSubview(detailTableView)
        
        NSLayoutConstraint.activate([
            detailTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}


extension DetailViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.daysInfo?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! DetailTableCell
        let dayInfo = presenter.daysInfo?[indexPath.row]
        cell.confirmedLabel.text = "\(dayInfo?.confirmed ?? 0)"
        cell.dateLabel.text      = dayInfo?.date
        cell.deathLabel.text     = "\(dayInfo?.deaths ?? 0)"
        cell.recoveredLabel.text = "\(dayInfo?.recovered ?? 0)"
        return cell
    }
    
}

extension DetailViewController : DetailViewProtocol {
    
}
