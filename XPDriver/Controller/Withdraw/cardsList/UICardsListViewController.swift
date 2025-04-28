//
//  UICardsListViewController.swift
//  XPDriver
//
//  Created by Waseem  on 13/02/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit

class UICardsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - IBOutlet -
    
    @IBOutlet weak var customTable: UITableView!
    
    //MARK: - Varialbes -
    
    var arrayCards: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.configData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func configData() {
        //        print("** wk newData: \(CodManager.currentUser().stripeCards)")
        let data = JSON(CodManager.currentUser().stripeCards ?? "")
        arrayCards = data.arrayValue
        self.customTable?.reloadData()
    }
    //MARK: - UITableView -
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        customTable.estimatedRowHeight = 54
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            //            return 3
            return arrayCards.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let card = arrayCards[indexPath.row]
            let cell: UICardViewCell = tableView.cell(for: indexPath)
            cell.configData(card: card) { isActive in
                if isActive {
                    if !card["status"].boolValue {
                        self.cardActiveApi(cardId: card["id"].stringValue)
                    }
                } else {
                    self.cardDeleteApi(cardId: card["id"].stringValue)
                }
            }
            return cell
        } else {
            let cell: UIAddPaymentCardViewCell = tableView.cell(for: indexPath)
            cell.handler = {
                let vc = UIAddPaymentMethodViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard indexPath.section == 0 else { return }
        
        let card = arrayCards[indexPath.row]
        
        guard !card["status"].boolValue else { return }
        
        cardActiveApi(cardId: card["id"].stringValue)
        
    }
    
    //MARK: - IBAction -
    
    @IBAction func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Api Calls -
    
    func cardDeleteApi(cardId: String) {
        let params: [String: Any] = [
            "command"   :   "creditcard_delete",
            "user_id"   :   CodManager.currentUser().userId ?? "",
            "app_id"    :   "9",
            "card_id"   :   cardId
        ]
        self.showHud()
        print("** wk params: \(params)")
        AF.request("https://www.xpeats.com/api/index.php", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .validate(contentType: ["application/json", "text/json", "text/javascript", "text/html"])
            .responseJSON1 { response in
                self.hideHud()
                if let error = response.error {
                    print("** wk failure 1: \(error)")
                    self.showAlert(message: error.localizedDescription)
                } else if let json = response.value {
                    print("** wk json: \(json)")
                    if json["success"].boolValue {
                        CodManager.fetchProfileDetail {
                            self.configData()
                        }
                    } else {
                        self.showAlert(message: json["msg"].stringValue)
                    }
                }
            }
    }
    
    func cardActiveApi(cardId: String) {
        let params: [String: Any] = [
            "command"   :   "creditcard_active",
            "user_id"   :   CodManager.currentUser().userId ?? "",
            "app_id"    :   "9",
            "card_id"   :   cardId
        ]
        self.showHud()
        print("** wk params: \(params)")
        AF.request("https://www.xpeats.com/api/index.php", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .validate(contentType: ["application/json", "text/json", "text/javascript", "text/html"])
            .responseJSON1 { response in
                self.hideHud()
                if let error = response.error {
                    print("** wk failure 1: \(error)")
                    self.showAlert(message: error.localizedDescription)
                } else if let json = response.value {
                    print("** wk json: \(json)")
                    
                    if json["success"].boolValue {
                        CodManager.fetchProfileDetail {
                            self.configData()
                        }
                    } else {
                        self.showAlert(message: json["msg"].stringValue)
                    }
                }
            }
    }
    
}
