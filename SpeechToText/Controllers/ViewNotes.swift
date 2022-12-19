//
//  ViewNotes.swift
//  SpeechToText
//
//  Created by Микола on 19.04.2022.
//

import UIKit

class ViewNotes: UIViewController {

    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var textTitle: UITextField!
    @IBOutlet weak var textNote: UITextView!
    @IBOutlet weak var viewView: UIView!
    
    var EditNote:AllMyNotes?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewView.layer.cornerRadius = 5
        viewView.layer.borderWidth = 2
        viewView.layer.borderColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2).cgColor
        viewView.clipsToBounds = true
        if let note = EditNote{
            textTitle.text = note.title
            textNote.text = note.notes
        }

        // Do any additional setup after loading the view.
    }
    
   
   /* @IBAction func btnBackActive(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }*/
    
    
    
    @IBAction func btnSaveAction(_ sender: Any) {
        var newNote:AllMyNotes?
        if let note = EditNote {
            newNote = note
        }else{
            newNote = AllMyNotes(context: context)
            
        }
        newNote?.title = textTitle.text
        newNote?.notes = textNote.text
        newNote?.date_Save = NSDate() as Date
        do{
            ad.saveContext()
            textTitle.text = ""
            textNote.text = ""
        }catch{
            print("Cannot save")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
