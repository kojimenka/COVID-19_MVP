//
//  ViewController.swift
//  COVID-19_MVP
//
//  Created by Дмитрий Марченков on 17.04.2020.
//  Copyright © 2020 Дмитрий Марченков. All rights reserved.
//

import UIKit

final class MainViewController : UIViewController {
    
    public var presenter : MainViewPresenterProtocol?
    private var mainView = MainView()
    
    private var tableView = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemPink]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setConstraints()
    }
    
    private func setupView () {
        title = "COVID-19"
        navigationController?.navigationBar.tintColor = .systemPink
    }
    
    private func setupTableView () {
        tableView = mainView.tableView
        tableView.delegate   = self
        tableView.dataSource = self
    }
    
    private func setConstraints () {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.allCountriesInfo?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MainTableViewCell
        let currentCoutry = presenter?.allCountriesInfo?[indexPath.row]
        cell.confirmedLabel.text = "\(currentCoutry?.dayInfo?.allDaysInfo.last?.confirmed ?? 0)"
        cell.countryLabel.text   = currentCoutry?.country
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let daysInfo    = presenter?.allCountriesInfo?[indexPath.row].dayInfo?.allDaysInfo
        let countryName = presenter?.allCountriesInfo?[indexPath.row].country ?? ""
        presenter?.presentDetailModule(daysInfo: daysInfo, countryName: countryName)
    }
}

extension MainViewController : MainViewProtocol {
    func successDownloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func failureDownloadData() {
    }
}

