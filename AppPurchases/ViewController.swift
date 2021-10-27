//
//  ViewController.swift
//  AppPurchases
//
//  Created by Adsum MAC 2 on 26/10/21.
//

import UIKit
import StoreKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,SKProductsRequestDelegate,SKPaymentTransactionObserver {
  
    
    private var models = [SKProduct]()
    private var tableView:UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.frame
        SKPaymentQueue.default().add(self)
        fetchProduct()
        tableView.reloadData()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellprodu = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(cellprodu.localizedTitle) : \(cellprodu.localizedDescription) - \(String(describing: cellprodu.priceLocale.currencySymbol ?? "$"))\((cellprodu.price))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let payment = SKPayment(product: models[indexPath.row])
        SKPaymentQueue.default().add(payment)
    }
    
    enum product: String, CaseIterable{
        case removeAd = "com.shubh.AppAd"
        case unlockingEveryThin = "com.shubh.AppUnlock"
        case getgames = "com.shubh.GetLike"
    }
    func fetchProduct(){
        let request = SKProductsRequest(productIdentifiers: Set(product.allCases.compactMap({ $0.rawValue})))
        request.delegate = self
        request.start()
        
    }
    
    //Product
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            print("Count : \(response.products)")
            self.models = response.products
            self.tableView.reloadData()
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach({
            switch $0.transactionState {
            case .purchasing:
                print("Purchasing")
                break
            case .purchased:
                print("purchesed")
                SKPaymentQueue.default().finishTransaction($0)
                break
            case .failed:
                
                SKPaymentQueue.default().finishTransaction($0)
                print("failed")
                break
            case .restored:
                print("restored")
                break
            case .deferred:
                print("deferred")
                break
            default:
                break
            
            }
        })
    }
    
    
    

}

