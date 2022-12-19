//
//  ViewNotesCell.swift
//  SpeechToText
//
//  Created by Микола on 19.04.2022.
//

import UIKit

class ViewNotesCell: UITableViewCell {

    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelNotes: UITextView!
    @IBOutlet weak var labelTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func SetNotes(note:AllMyNotes){
        labelNotes.text = note.notes
        labelTitle.text = note.title
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yy h:mm a"
        let now = dateFormat.string(from: note.date_Save as! Date)
        labelDate.text = now
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
