//
//  SettingsTwoController.swift
//  SpeechToText
//
//  Created by Микола on 28.05.2022.
//

import UIKit

class SettingsTwoController: UITableViewController {
    @IBOutlet weak var LangSettingLabel: UILabel!
    @IBOutlet weak var TimeSettingLabel: UILabel!
    @IBOutlet weak var ColorSettingLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    @IBAction func resetSetings(_ sender: Any) {
        SettingsTwoClass.shared.resetSettings()
        loadSetting()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSetting()
    }
    
    func loadSetting(){
        LangSettingLabel.text = "\(SettingsTwoClass.shared.currentSettings.LangSetting)"
        ColorSettingLabel.text = "\(SettingsTwoClass.shared.currentSettings.ColorSetting)"
        TimeSettingLabel.text = "\(SettingsTwoClass.shared.currentSettings.TimeSetting) sec"
    
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "selectLangVC":
            if let vc = segue.destination as? SelectLangTwoViewController{
                vc.data = ["Ukrainian","English"]
            }
        case "selectColorVC":
            if let vc1 = segue.destination as? SelectColorController{
            vc1.data1 = ["Blue","Orange"]
        }
        case "selectTimeVC":
            if let vc1 = segue.destination as? SelectTimeController{
                vc1.data = [5,10,15,20,25,30,35,40,45,50,55,60]
        }
        default:
            break
        }
    }
   

}
