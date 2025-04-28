//
//  UIMessageToCustomerViewController.swift
//  XPDriver
//
//  Created by Waseem  on 27/03/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit
import IQKeyboardManager

@objcMembers
class UIMessageToCustomerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageOperations {
    
    //MARK: - IBOutlet -
    
    @IBOutlet weak var textView: IQTextView!
    @IBOutlet weak var customTable: UITableView!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    
    //MARK: - Variables -
    
    var viewModel: MessageToCustomerViewModel = MessageToCustomerViewModel()
    var orderId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.orderId = orderId
        viewModel.getTimeSlotsForMessageApi()
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
        return viewModel.arrayOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UIMessageChoiceViewCell = tableView.cell(for: indexPath)
        let item = viewModel.arrayOptions[indexPath.row]
        cell.config(item: item, selected: viewModel.checkSelected(item: item))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !viewModel.arrayOptions[indexPath.row]["message_sent"].boolValue else { return }
        
        viewModel.selectedOptionId = viewModel.arrayOptions[indexPath.row]["id"].stringValue
        self.customTable.reloadData()
    }
    
    //MARK: - MessageOperations -
    
    func reloadData() {
        constraintTableViewHeight.constant = CGFloat(viewModel.arrayOptions.count * 50)
        self.view.layoutIfNeeded()
        self.customTable.reloadData()
    }
    
    func showLoading() {
        self.showHud()
    }
    
    func hideLoading() {
        self.hideHud()
    }
    
    func showErrorMessage(message: String) {
        self.showAlert(message: message)
    }
    
    //MARK: - IBAction -
    
    @IBAction func onClickClose() {
        self.dismiss(animated: true)
    }

    @IBAction func onClickSend() {
        guard !viewModel.selectedOptionId.isEmpty else {
            self.showAlert(message: "Please select a message")
            return
        }
        viewModel.sendMessageToCustomerApi { [weak self] in
            self?.dismiss(animated: true)
        }
    }

}
