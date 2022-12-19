//
//  SelectTimeController.swift
//  SpeechToText
//
//  Created by Микола on 28.05.2022.
//

import UIKit

class SelectTimeController: UIViewController {
    var data:[Int] = [5,10,15,20,25,30,35,40,45,50,55,60]

    @IBOutlet weak var tabelView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tabelView.dataSource = self
        tabelView.delegate = self
    }
    

    

}
extension SelectTimeController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell",for: indexPath)
        cell.textLabel?.text = String(data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /*UserDefaults.standard.setValue(data[indexPath.row], forKey: "LangSetting")
        if UserDefaults.standard.object(forKey: "LangSetting") != nil{
            
        }*/
        SettingsTwoClass.shared.currentSettings.TimeSetting = data[indexPath.row]
        navigationController?.popViewController(animated: true)
        //print (data[indexPath.row])
    }
    
    
}
