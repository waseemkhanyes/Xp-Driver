//
//  UIDriverAttachedLocationsPopupViewController.swift
//  XPDriver
//
//  Created by Waseem  on 08/11/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit

class UIDriverAttachedLocationsPopupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - IBOutlet -
    
    @IBOutlet weak var customTable: UITableView!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    
    //MARK: - Variables -
    
    var arrayLocations: [JSON] = []
    var selected: JSON = JSON([:])
    var orderId: String = ""
    var isFromMap: Bool = false
    var handler: ((JSON)->())? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        print("** wk arrayLocations: \(arrayLocations)")
        self.reloadData()
    }
    
    //MARK: - UITableView -
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        customTable.estimatedRowHeight = 54
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UIMessageChoiceViewCell = tableView.cell(for: indexPath)
        let item = arrayLocations[indexPath.row]
        cell.configForAttachedDriver(item: item, selected: checkSelected(item: item))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = arrayLocations[indexPath.row]
        self.customTable.reloadData()
    }
    
    func checkSelected(item: JSON) -> Bool {
        let key = isFromMap ? "id" : "locationId"
        print("** wk item: \(item[key].stringValue), selected: \(selected[key].stringValue), value: \(item[key].stringValue == selected[key].stringValue)")
        return item[key].stringValue == selected[key].stringValue
    }
    
    //MARK: - MessageOperations -
    
    func reloadData() {
        constraintTableViewHeight.constant = CGFloat(arrayLocations.count * 50)
        self.view.layoutIfNeeded()
        self.customTable.reloadData()
    }
    
    //MARK: - IBAction -
    
    @IBAction func onClickClose() {
        self.dismiss(animated: true)
    }

    @IBAction func onClickSelect() {
        guard !selected.isEmpty else {
            self.showAlert(message: "Please select location first")
            return
        }
        print("** wk selected: \(selected)")
        self.dismiss(animated: true)
        handler?(selected)
    }
}
