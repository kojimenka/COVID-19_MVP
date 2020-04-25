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
    
    private let searchController  = UISearchController(searchResultsController: nil)
    private let activityIndicator = UIActivityIndicatorView() // Cool download indicator in view
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemPink]
        //navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSearchControl()
        setupTableView()
        setConstraints()
    }
    
    private func setupView () {
        title = "COVID-19"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                            target: self,
                                                            action: #selector(updateTrigger))
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.tintColor = .systemPink
            self.view.backgroundColor = .backgroundColor
        }
    }
    
    private func setupTableView () {
        tableView = mainView.tableView
        tableView.delegate   = self
        tableView.dataSource = self
    }
    
    private func setupSearchControl () {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Country"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func startIndicator () {
        tableView.alpha = 0.0
        activityIndicator.center = view.center
        activityIndicator.style = .medium
        activityIndicator.color = .systemPink
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    private func stopDownloadIndicator () {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            
            UIView.animate(withDuration: 0.5) {
                self.tableView.alpha = 1.0
            }
        }
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
    
    @objc private func updateTrigger () {
        presenter?.updateData()
    }
    
}

extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.isFiltering == true ? presenter?.changedCountriesInfoArray?.count ?? 0 : presenter?.allCountriesInfo?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MainTableViewCell
        
        let currentCounry = presenter?.isFiltering == true ? presenter?.changedCountriesInfoArray?[indexPath.row] : presenter?.allCountriesInfo?[indexPath.row]
        
        cell.confirmedLabel.text = "\(currentCounry?.dayInfo?.allDaysInfo.last?.confirmed ?? 0)"
        cell.countryLabel.text   = currentCounry?.country
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentCounry = presenter?.isFiltering == true ? presenter?.changedCountriesInfoArray?[indexPath.row] : presenter?.allCountriesInfo?[indexPath.row]
        
        let daysInfo    = currentCounry?.dayInfo?.allDaysInfo
        let countryName = currentCounry?.country ?? ""
        
        presenter?.presentDetailModule(daysInfo: daysInfo, countryName: countryName)
    }
}

extension MainViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        presenter?.filterArray(searchText: searchBar.text ?? "")
    }
}

extension MainViewController : MainViewProtocol {
    func showIndicator() {
        startIndicator()
    }
    
    func stopIndicator() {
        stopDownloadIndicator()
    }
    
    func showFilterData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func successDownloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func failureDownloadData() {
    }
}

