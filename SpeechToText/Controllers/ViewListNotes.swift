//
//  ViewListNotes.swift
//  SpeechToText
//
//  Created by Микола on 19.04.2022.
//

import UIKit
import CoreData

class ViewListNotes: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var listNotes = [AllMyNotes]()
    
    @IBOutlet weak var tabelViewNotesList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotes()
        tabelViewNotesList.delegate = self
        tabelViewNotesList.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNotes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:ViewNotesCell = tableView.dequeueReusableCell(withIdentifier: "CellNote", for:indexPath) as! ViewNotesCell
        cell.SetNotes(note: listNotes[indexPath.row])
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(btnDeleteAction(_:)), for: .touchDragEnter)
        cell.btnEdit.addTarget(self, action: #selector(btnEditAction(_:)), for: .touchDragEnter)
        return cell
    }
    
    @objc func btnDeleteAction(_ sender:UIButton){
        context.delete(listNotes[sender.tag])
        loadNotes()
    }
    
    @objc func btnEditAction(_ sender:UIButton){
        performSegue(withIdentifier: "EditOrAddSegway", sender: listNotes[sender.tag])
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditOrAddSegway"{
            if let AddOrEdit = segue.destination as? ViewNotes {
                if let mynote = sender as? AllMyNotes{
                    AddOrEdit.EditNote = mynote
                    
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;//Choose your custom row height
    }*/
    
    func loadNotes(){
        let fetchRequest:NSFetchRequest<AllMyNotes> = AllMyNotes.fetchRequest()
        do{
            listNotes = try context.fetch(fetchRequest)
            tabelViewNotesList.reloadData()
        }catch{
            print("cannot read from database")
        }
    }
    

    
    @IBAction func btnAddAction(_ sender: Any) {
        performSegue(withIdentifier: "EditOrAddSegway", sender: nil)
    }
    
}
