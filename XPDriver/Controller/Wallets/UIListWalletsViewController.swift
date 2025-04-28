//
//  UIListWalletsViewController.swift
//  XPDriver
//
//  Created by Waseem  on 11/03/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit

@objcMembers
class UIListWalletsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WalletOperations {
    
    @IBOutlet weak var customTable: UITableView!
    
    var viewModel: WalletsViewModel = WalletsViewModel()
    var handler: (([String: Any])->())? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        self.navigationItem.title = "XP Wallet"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
            viewModel.getUserWallets()
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
        return viewModel.arrayWallet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UIWalletItemViewCell = tableView.cell(for: indexPath)
        let data = viewModel.arrayWallet[indexPath.row]
        cell.config(data: data) { isMenu in
            if isMenu {
                self.showAlert(message: "Do you want to make this wallet your default?", shouldTwo: true) {
                    self.viewModel.makeDefaultWalletApi(walletId: data["id"].intValue)
                }
            } else {
                self.handler?(data.dictionaryObject ?? [:])
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        handler?(arrayWallet[indexPath.row]["currency_code"].stringValue)
    }
    
    //MARK: - WalletOperations -
    
    func reloadData() {
        print("** wk reload data")
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
}
