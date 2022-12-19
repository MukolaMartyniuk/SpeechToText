//
//  Note.swift
//  SpeechToText
//
//  Created by Микола on 15.05.2022.
//

import Foundation
import CoreData

@objc(Note)
class Note: NSManagedObject{
    @NSManaged var id: NSNumber!
    @NSManaged var title: String!
    @NSManaged var desc: String!
    @NSManaged var deletedDate: Date?
}
