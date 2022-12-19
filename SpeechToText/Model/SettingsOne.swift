//
//  SettingsOne.swift
//  SpeechToText
//
//  Created by Микола on 27.05.2022.
//

import Foundation

enum KeysUserDefaults{
    static let settingsOne = "settingOne"
}

struct SettingsOne:Codable{
    var LangSetting:String
}


class Settings{
    static var shared = Settings()
    
    let defaultSettings = SettingsOne(LangSetting: "Ukrainian")
    var currentSettings:SettingsOne{
        get{
            if let data = UserDefaults.standard.object(forKey: KeysUserDefaults.settingsOne) as? Data{
                return try! PropertyListDecoder().decode(SettingsOne.self, from: data)
            }else{
                if let data = try? PropertyListEncoder().encode(defaultSettings){
                    UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.settingsOne)
                }
                return defaultSettings
            }
        }
        set{
            /* do{
                let data = try PropertyListEncoder().encode(newValue)
                
            }catch{
                print(error)
            }*/
            if let data = try? PropertyListEncoder().encode(newValue){
                UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.settingsOne)
            }
        }
    }
    func resetSettings(){
        currentSettings = defaultSettings
    }
}
