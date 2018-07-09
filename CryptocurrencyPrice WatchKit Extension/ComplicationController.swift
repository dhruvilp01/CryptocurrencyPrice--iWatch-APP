//
//  ComplicationController.swift
//  CryptocurrencyPrice WatchKit Extension
//
//  Created by Dhruvil Patel on 7/7/18.
//  Copyright © 2018 Dhruvil. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) { handler([])
        
    }

    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
            
            let url = URL(string: "https://api.coinmarketcap.com/v2/ticker/")!
            
            URLSession.shared.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
                if error == nil {
                    print("It worked")
                    
                    if data != nil {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                            
                            guard let data = json["data"] as? [String: Any], let one = data["1"] as? [String: Any], let quote = one["quotes"] as? [String: Any], let usd = quote["USD"] as? [String: Any], let price = usd["price"] as? NSNumber                     else {
                                return
                            }
                            
                            let intPrice = Int(truncating: price)
                            
                            
                            if complication.family == .modularSmall {
                            let template = CLKComplicationTemplateModularSmallStackText()
                            template.line1TextProvider = CLKSimpleTextProvider(text: "BIT")
                            template.line2TextProvider = CLKSimpleTextProvider(text: "\(intPrice)")
                            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                            
                            handler(entry)
                            }
                            
                            if complication.family == .modularLarge {
                                let template = CLKComplicationTemplateModularLargeStandardBody()
                                template.headerTextProvider = CLKSimpleTextProvider(text: "BitPrice")
                                let formatter = NumberFormatter()
                                formatter.numberStyle = .currency
                                formatter.locale = Locale(identifier: "en_US")

                                template.body1TextProvider = CLKSimpleTextProvider(text: formatter.string(from: price)!)
                                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                                handler(entry)
                            }
                            
                        } catch {}
                    }
                } else {
                    
                }
                }.resume()
        
        
        
    }

    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
       
        
        if complication.family == .modularSmall {
        let template = CLKComplicationTemplateModularSmallStackText()
        template.line1TextProvider = CLKSimpleTextProvider(text: "1")
        template.line2TextProvider = CLKSimpleTextProvider(text: "2")
        handler(template)
        }
        
        if complication.family == .modularLarge {
            let template = CLKComplicationTemplateModularLargeStandardBody()
            template.headerTextProvider = CLKSimpleTextProvider(text: "BitPrice")
            template.body1TextProvider = CLKSimpleTextProvider(text: "$9999.99")
            handler(template)
        }
            
    }
    
}
