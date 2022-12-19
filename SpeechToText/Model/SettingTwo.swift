//
//  SettingTwo.swift
//  SpeechToText
//
//  Created by Микола on 28.05.2022.
//

import Foundation

enum KeysUserDefaultsTwo{
    static let settingsTwo = "settingTwo"
    static let settingThree = "settingThree"
    static let settingFour = "settingFour"
}

struct SettingsTwo:Codable{
    var LangSetting:String
    var ColorSetting:String
    var TimeSetting:Int
}


class SettingsTwoClass{
    static var shared = SettingsTwoClass()
    
    let defaultSettings = SettingsTwo(LangSetting: "Ukrainian", ColorSetting: "Blue", TimeSetting: 10)
    var currentSettings:SettingsTwo{
        get{
            if let data = UserDefaults.standard.object(forKey: KeysUserDefaultsTwo.settingsTwo) as? Data{
                return try! PropertyListDecoder().decode(SettingsTwo.self, from: data)
                //return SettingsTwo.init(LangSetting: "English", ColorSetting: "Orange", TimeSetting: 10)
            }else{
                if let data = try? PropertyListEncoder().encode(defaultSettings){
                    UserDefaults.standard.setValue(data, forKey: KeysUserDefaultsTwo.settingsTwo)
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
                UserDefaults.standard.setValue(data, forKey: KeysUserDefaultsTwo.settingsTwo)
                UserDefaults.standard.setValue(data, forKey: KeysUserDefaultsTwo.settingThree)
                UserDefaults.standard.setValue(data, forKey: KeysUserDefaultsTwo.settingFour)
            }
        }
    }
    func resetSettings(){
        currentSettings = defaultSettings
    }
}
