//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Mustafa on 9/30/19.
//  Copyright © 2019 Mostafa. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController  , UIPickerViewDataSource , UIPickerViewDelegate{
  
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
   let currencySymbolArray =  ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var  currencySelected = ""
    var finalURL = ""
    
    //TODO: Declare instance variables here
    let bitcoinDataModel = BitcoinDataModel()
    
    
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    
    
    //TODO: Place your 2 UIPickerView dataSource methods here
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    //TODO: Place your 3 UIPickerView delegate methods here
  
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        currencySelected = currencySymbolArray[row]
        getBitcoinData(url: finalURL)
    }
    
    
    
    
    
    
    
       //MARK: - Networking
    // **************************************************************
    
        func getBitcoinData(url: String) {
    
            Alamofire.request(url, method: .get)
                .responseJSON { response in
                    if response.result.isSuccess {
    
                        print("Sucess! Got the Bitcoin data!")
                       let bitcoinJSON : JSON = JSON(response.result.value!)
                        //print(bitcoinJSON)
    
                     self.updateBitcoinData(json: bitcoinJSON)
    
                    } else {
                        print("Error: \(String(describing: response.result.error))")
                        self.bitcoinPriceLabel.text = "Connection Issues"
                    }
                }
    
        }
    
    
    
    
    
        //MARK: - JSON Parsing
        /***************************************************************/
    
        func updateBitcoinData(json : JSON) {
    
            if let bitcoinResult = json["ask"].double {

            bitcoinDataModel.price = bitcoinResult
            bitcoinPriceLabel.text = currencySelected + "\(bitcoinDataModel.price)"

            } else {
                bitcoinPriceLabel.text = "Price Unvailable "
            }
    
           
        }
    
    
    
    



}

