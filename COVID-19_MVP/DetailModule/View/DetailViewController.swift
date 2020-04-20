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
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setConstraints()
    }
    
    private func setupView () {
        title = presenter.countryName
        view.backgroundColor = .backgroundColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(showAlertSheet))
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
    
    @objc private func showAlertSheet () {
        let actionSheetController = UIAlertController(title: "Chart Setings", message: "Filter chart", preferredStyle: .actionSheet)
        
        let firstAction = UIAlertAction(title: "First dead", style: .default) { [weak self] action -> Void in
            self?.presenter.updateChart(edit: .firstDead)
        }
        
        let secondAction = UIAlertAction(title: "First recoverd", style: .default) { [weak self] action -> Void in
            self?.presenter.updateChart(edit: .firstRecovered)
        }
        
        let thirdAction = UIAlertAction(title: "First confirmed", style: .default) { [weak self] action -> Void in
            self?.presenter.updateChart(edit: .firstConfirmed)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(thirdAction)
        actionSheetController.addAction(cancelAction)
    
        present(actionSheetController, animated: true, completion: nil)
    }

}


extension DetailViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            guard let count = presenter.daysInfo?.count else { return 0 }
            return count - 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailChartCell
            cell.dataForChart = presenter.daysInfo
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! DetailTableCell
            guard let currentDayInfo = presenter.daysInfo?[indexPath.row] else {fatalError()}
            guard let previosDayInfo = presenter.daysInfo?[indexPath.row + 1] else {fatalError()}
            guard let thirdDayInfo   = presenter.daysInfo?[indexPath.row + 2] else {fatalError()}
            cell.dataForDisplay = (currentDayInfo, previosDayInfo, thirdDayInfo)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CGFloat(300.0)
        } else {
            return CGFloat(120.0)
        }
    }
    
}

extension DetailViewController : DetailViewProtocol {
    func showUpdateChart() {
        DispatchQueue.main.async {
            self.detailTableView.reloadData()
        }
    }
    
    
}
