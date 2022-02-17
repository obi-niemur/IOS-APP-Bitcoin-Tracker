//
//  ViewController.swift
//  BitcoinTracker
//
//  Created by Niemur Obi on 5/5/21.
//

import UIKit

class ViewController: UIViewController {
    //Connect our view widget with our controller
    @IBOutlet weak var dollarAmount: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currecncyPicker: UIPickerView!
    
    
    var coinModel = CoinModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinModel.delegate = self
        currecncyPicker.dataSource = self
        currecncyPicker.delegate = self
    }
}


extension ViewController: CoinManagerDelagate {
    
    
    func didFailWithError(error: Error) {
        print(error)
    }
    func didUpdatePrice(price: String, currency: String) {
        DispatchQueue.main.async {
            self.dollarAmount.text = price
            self.currencyLabel.text = currency
            
        }
       
    }
    
}//coin manager delegate


//UIPicker view datasource and deligate
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    //number of columns in the picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //return how many values in the model array
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        
        return coinModel.currencyArray.count
        
        
        
    }
    //return the string events given the row number
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinModel.currencyArray[row]
    }
    
    //get coin price based upon currency selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinModel.currencyArray[row]
        coinModel.getCoinPrice(for: selectedCurrency)
    }
    
    
}


