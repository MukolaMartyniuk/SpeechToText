//
//  ViewAudio.swift
//  SpeechToText
//
//  Created by Микола on 15.05.2022.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import CoreData

class ViewAudio: UIViewController, UIDocumentPickerDelegate, UINavigationControllerDelegate, UIDocumentMenuDelegate {

    @IBOutlet weak var tvResult: UITextView!
    @IBOutlet weak var labelURL: UILabel!
    
    var selectedNote: Note? = nil
    
    var API:String = ""
    
    static var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSetting()
    }
    
    func loadSetting(){
        if SettingsTwoClass.shared.currentSettings.ColorSetting == "Orange"{
            self.view.backgroundColor = UIColor.rgb(red: 192, green: 141, blue: 53)
        }else{
            self.view.backgroundColor = UIColor.rgb(red: 11, green: 18, blue: 40)
        }
        
    }
    
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        labelURL.text = "\(myURL)"
       
        guard let audioData = try? Data(contentsOf:myURL) else { return }
        let audioStr: String = audioData.base64EncodedString()
        
        guard let url = URL(string: "http://127.0.0.1:5000/post_json") else { return }
        //guard let url = URL(string: "https://speechtotextnotes.pythonanywhere.com/post_json") else { return }
        let parameters = ["audio": audioStr]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request){ (data, response, error) in
            if let response = response {
                print(response)
            }
            
            guard let data = data else {
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }

        }.resume()
        
        if Settings.shared.currentSettings.LangSetting == "Ukrainian"{
            //API = "https://speechtotextnotes.pythonanywhere.com/ua"
            API = "http://127.0.0.1:5000/ua"
       }else{
            //API = "https://speechtotextnotes.pythonanywhere.com/en"
            API = "http://127.0.0.1:5000/en"
        }
       
    
        guard let apiURL = URL(string: API) else {
        fatalError("some Error")
        }
    
        let session1 = URLSession(configuration: .default)
    
        let task = session1.dataTask(with: apiURL) { (data, response, error) in
            guard let data = data, error == nil else {return}
            DispatchQueue.main.async {
                let str = String(decoding: data, as: UTF8.self)
                self.tvResult.text = str
            
            }

        }
        task.resume()
    }
          

    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }


    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func selectAudio(_ sender: Any) {
        clickFunction()
        }
    func clickFunction(){

    let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypeAudio)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
   
    
    @IBAction func saveAction(_ sender: Any) {
        let alert = UIAlertController(title: "Save", message: "Save Notes", preferredStyle: .alert)
        let btnSave = UIAlertAction(title: "Save", style: .default) { (action) in
            let textFieldOne = alert.textFields?.first
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            if (self.selectedNote == nil){
                let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
                let newNote = Note(entity: entity!, insertInto: context)
                newNote.id = noteList.count as NSNumber
                newNote.title = textFieldOne?.text
                newNote.desc = self.tvResult.text
                do{
                    try context.save()
                    noteList.append(newNote)
                }catch{
                    print("context save error")
                }
            }
            else {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
                do {
                    let results:NSArray = try context.fetch(request) as NSArray
                    for result in results {
                        let note = result as! Note
                        if (note == self.selectedNote){
                            note.title = textFieldOne?.text
                            note.desc = self.tvResult.text
                            try context.save()
                        }
                    }
                }catch{
                    print("Fetch Failed")
                }
            }
        }
        let btnCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        alert.addAction(btnSave)
        alert.addAction(btnCancel)
        present(alert,animated: true, completion: nil)
        
    }
}




