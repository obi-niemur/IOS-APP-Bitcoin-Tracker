//
//  CoinModel.swift
//  BitcoinTracker
//
//  Created by Niemur Obi on 5/5/21.
//
//Contain model data for our app
import Foundation


//Our own protocol to manage our price information
protocol CoinManagerDelagate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
    
}


struct CoinModel {
    var delegate: CoinManagerDelagate?
    
    let baseUrl = "https://rest.coinapi.io/v1/exchangerate/BTC"
    
    let apiKey = "B6546F9D-DD38-4060-A0AD-2A9D555B46AA"
    
    let currencyArray = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "UBR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR"]
    
    
    func getCoinPrice(for currency: String) {
        
        //Create Url String
        let urlString = "\(baseUrl)/\(currency)?apiKey=\(apiKey)"
        print(urlString)
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) {
                (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }//end error
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData){
                    let priceString = String(format: "%.2f", bitcoinPrice)
                    
                    self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                        
                    }//end bitcoin price
                }//end safe data
            }//end Task
            
            
            task.resume()
            
            
        }//end url
    }//end get coin price
    
    
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try
                decoder.decode(CoinData.self, from: data)
            let lastPrice = decodeData.rate
            print("LastPrice: \(lastPrice)")
            return lastPrice
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }//end parseJSON
    
    
}//end coin model

