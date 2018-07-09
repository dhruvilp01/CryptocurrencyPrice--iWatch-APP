//
//  InterfaceController.swift
//  CryptocurrencyPrice WatchKit Extension
//
//  Created by Dhruvil Patel on 7/7/18.
//  Copyright © 2018 Dhruvil. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var priceLbl: WKInterfaceLabel!
    @IBOutlet weak var updatingLbl: WKInterfaceLabel!
    
    override func willActivate() {

        super.willActivate()
        
        if let price = UserDefaults.standard.value(forKey: "price") as? NSNumber {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "en_US")
            
            self.priceLbl.setText(formatter.string(from: price))
            updatingLbl.setText("Updating...")
        } else {
            updatingLbl.setText("Getting Price")
        }
         getPrice()
        
    }

    func getPrice() {

        let url = URL(string: "https://api.coinmarketcap.com/v2/ticker/")!
        
        URLSession.shared.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
            if error == nil {
                print("It worked")
                
                if data != nil {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                        
                        guard let data = json["data"] as? [String: Any], let one = data["1"] as? [String: Any], let quote = one["quotes"] as? [String: Any], let usd = quote["USD"] as? [String: Any], let price = usd["price"] as? NSNumber
                            else {
                            return
                        }
                        
                        let formatter = NumberFormatter()
                        formatter.numberStyle = .currency
                        formatter.locale = Locale(identifier: "en_US")
                        
                        self.priceLbl.setText(formatter.string(from: price))
                        self.updatingLbl.setText("Updated")
                        
                        UserDefaults.standard.set(price, forKey: "price")
                        UserDefaults.standard.synchronize()
                        
                        if CLKComplicationServer.sharedInstance().activeComplications != nil {
                            for comp in CLKComplicationServer.sharedInstance().activeComplications! {
                                CLKComplicationServer.sharedInstance().reloadTimeline(for: comp)
                            }
                        }
                        
                    } catch {}
                }
            } else {
                
            }
        }.resume()
    }
    
}
//guard let data = json["data"] as? [String: Any], let one = data["1"] as? [String: Any], let quote = one["quotes"] as? [String: Any], let usd = quote["USD"] as? [String: Any], let price = usd["price"] as? NSNumber
