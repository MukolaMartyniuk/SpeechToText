//
//  SelectLangTwoViewController.swift
//  SpeechToText
//
//  Created by Микола on 28.05.2022.
//

import UIKit

class SelectLangTwoViewController: UIViewController {
    
    var data:[String] = []


    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    

    
}
extension SelectLangTwoViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LangSell",for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /*UserDefaults.standard.setValue(data[indexPath.row], forKey: "LangSetting")
        if UserDefaults.standard.object(forKey: "LangSetting") != nil{
            
        }*/
        SettingsTwoClass.shared.currentSettings.LangSetting = data[indexPath.row]
        navigationController?.popViewController(animated: true)
        //print (data[indexPath.row])
    }
    
    
}
