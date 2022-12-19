//
//  SelectLangViewController.swift
//  SpeechToText
//
//  Created by Микола on 27.05.2022.
//

import UIKit

class SelectLangViewController: UIViewController {
    
    var data:[String] = []

    @IBOutlet weak var tabelView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tabelView.dataSource = self
        tabelView.delegate = self
        

        // Do any additional setup after loading the view.
    }
    


}
extension SelectLangViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LangCell",for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /*UserDefaults.standard.setValue(data[indexPath.row], forKey: "LangSetting")
        if UserDefaults.standard.object(forKey: "LangSetting") != nil{
            
        }*/
        Settings.shared.currentSettings.LangSetting = data[indexPath.row]
        navigationController?.popViewController(animated: true)
        //print (data[indexPath.row])
    }
    
    
}
