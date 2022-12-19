//
//  SettingsOneController.swift
//  SpeechToText
//
//  Created by Микола on 27.05.2022.
//

import UIKit

class SettingsOneController: UITableViewController {

    @IBOutlet weak var LangSettingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    
    @IBAction func resetSettings(_ sender: Any) {
        Settings.shared.resetSettings()
        loadSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSetting()
    }
    
    func loadSetting(){
        LangSettingLabel.text = "\(Settings.shared.currentSettings.LangSetting)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "selectLangVC":
            if let vc = segue.destination as? SelectLangViewController{
                vc.data = ["Ukrainian","English"]
            }
        default:
            break
        }
    }


  

}
