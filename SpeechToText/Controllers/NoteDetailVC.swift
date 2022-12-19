//
//  NoteDetailVC.swift
//  SpeechToText
//
//  Created by Микола on 15.05.2022.
//

import UIKit
import CoreData

class NoteDetailVC: UIViewController {

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descTV: UITextView!
    
    var selectedNote: Note? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (selectedNote != nil){
            titleTF.text = selectedNote?.title
            descTV.text = selectedNote?.desc
        }
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

    @IBAction func SaveAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if (selectedNote == nil){
            let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
            let newNote = Note(entity: entity!, insertInto: context)
            newNote.id = noteList.count as NSNumber
            newNote.title = titleTF.text
            newNote.desc = descTV.text
            do{
                try context.save()
                noteList.append(newNote)
                navigationController?.popViewController(animated: true)
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
                    if (note == selectedNote){
                        note.title = titleTF.text
                        note.desc = descTV.text
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            }catch{
                print("Fetch Failed")
            }
        }
        
    }
    
    @IBAction func DeleteNote(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results {
                let note = result as! Note
                if (note == selectedNote){
                    note.deletedDate = Date()
                    try context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
        }catch{
            print("Fetch Failed")
        }
    }
    
    
    @IBAction func SharedFile(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [descTV.text!], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
    }
}
