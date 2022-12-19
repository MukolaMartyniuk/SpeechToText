//
//  SelectColorController.swift
//  SpeechToText
//
//  Created by Микола on 28.05.2022.
//

import UIKit

class SelectColorController: UIViewController {
    var data1:[String] = ["Blue","Orange"]
    

    @IBOutlet weak var tabelView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tabelView.dataSource = self
        tabelView.delegate = self

    }
    

  

}
extension SelectColorController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell",for: indexPath)
        cell.textLabel?.text = data1[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /*UserDefaults.standard.setValue(data[indexPath.row], forKey: "LangSetting")
        if UserDefaults.standard.object(forKey: "LangSetting") != nil{
            
        }*/
        SettingsTwoClass.shared.currentSettings.ColorSetting = data1[indexPath.row]
        navigationController?.popViewController(animated: true)
        //print (data[indexPath.row])
    }
    
    
}
