//
//  GoogleSheetService.swift
//  FXLotSize
//
//  Created by primagest on 2024/10/06.
//

import Foundation

class GoogleSheetService {
    /// private constructor
    private init() {}
    
    /// the one and only instance of this singleton
    static let instance = GoogleSheetService()
    
    var list: [CurrencyPairModel] = []
    
    func callGoogleSheetAPI() async -> Bool {
        print("callGoogleSheetAPI")
        
//        let outputFormat = DateFormatter()
//        outputFormat.dateFormat = "yyyy/MM/dd H:m"
//        date = outputFormat.string(from: now!)
        
        let apiKey = "AIzaSyA0w_ZecwgQJ9XHcrfsxLpW92i_FacfzRU"
        let spreadsheetId = "1URRKa2jW3WMx34GgtDUU21kCYMKvdlG5fKmWwPUSnTE"
        let range = "finance"
        let url = "https://sheets.googleapis.com/v4/spreadsheets/\(spreadsheetId)/values/\(range)?key=\(apiKey)"
        
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
            let decodedData = try JSONSerialization.jsonObject(with: data) as! [String: Any]
            let values = decodedData["values"] as! [[String]]
            
            list.removeAll()
            
            for value in values {
                let name = value[0]
                let priceStr = value[1]
                let fullName = value[3]
                
                let formattedPrice: Double
                if let price = Double(priceStr) {
                    if name == "XAU/USD" {
                        // 金価格用に小数点以下2桁に丸める
                        formattedPrice = round(price * 100) / 100
                    } else {
                        // 通貨ペアの最後の3文字に応じてフォーマットを分岐
                        switch name.suffix(3) {
                        case "JPY":
                            // JPYの場合は小数点以下3桁に丸める
                            formattedPrice = round(price * 1000) / 1000
                        default:
                            // それ以外の場合は小数点以下5桁に丸める
                            formattedPrice = round(price * 100000) / 100000
                        }
                    }
                } else {
                    // 変換失敗時の処理として、例えば0.0を設定
                    formattedPrice = 0.0
                }
                
                list.append(CurrencyPairModel(pairName: name, pairRate: formattedPrice, pairFullName: fullName))
            }
            return true
        } catch {
            print("Error: \(error)")
            return false
        }
    }
}
