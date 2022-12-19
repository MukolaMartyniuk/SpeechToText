//
//  ViewController.swift
//  SpeechToText
//
//  Created by Микола on 01.04.2022.
//

import UIKit
import AVFoundation
import CoreData

extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let s = self as NSString
        return s.appendingPathComponent(path)
    }
}

class ViewController: UIViewController, AVAudioRecorderDelegate  {
    
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var tvResult: UITextView!
    @IBOutlet weak var viewView: UIView!
    @IBOutlet weak var labelBtn: UILabel!
    
    private var audioRecorder: AVAudioRecorder! // Обєкт аудіозапису
    private var _recorderFilePath: String! // Шлях запису
    
    private var AUDIO_LEN_IN_SECOND = 10 // Час запису
    private let SAMPLE_RATE = 16000 // Частота вибору
    
    var API:String = ""
    
    var selectedNote: Note? = nil

   /* private lazy var module: InferenceModule = { // Доступ до моделі
        if let filePath = Bundle.main.path(forResource:
            "en_v3_jit", ofType: "pt"),
            let module = InferenceModule(fileAtPath: filePath) {
            return module
        } else {
            fatalError("Can't find the model file!")
        }
    }()*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
    
    
    @IBAction func startTapped(_ sender: Any) {
        AUDIO_LEN_IN_SECOND = SettingsTwoClass.shared.currentSettings.TimeSetting
        AVAudioSession.sharedInstance().requestRecordPermission ({(granted: Bool)-> Void in // Запит на дозвіл запису
            if granted {
                self.labelBtn.text = "Listening..."
                self.btnStart.setImage(UIImage(named: "stopIcon.png"), for: .normal)
            } else{
                self.tvResult.text = "Record premission needs to be granted"
            }
         })
        
        let audioSession = AVAudioSession.sharedInstance() // Повертає екземпляр спільного аудіосеансу
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.record) //Встановлюєм категорію аудіозапису
            try audioSession.setActive(true) // Активує сеанс
        } catch {
            tvResult.text = "recording exception"
            return
        }

        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: SAMPLE_RATE,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ] as [String : Any] // масив характеристик аудіозапису
        
        do {
            _recorderFilePath = NSHomeDirectory().stringByAppendingPathComponent(path: "tmp").stringByAppendingPathComponent(path: "recorded_file.wav")
            print(_recorderFilePath!)
            audioRecorder = try AVAudioRecorder(url: NSURL.fileURL(withPath: _recorderFilePath), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record(forDuration: TimeInterval(AUDIO_LEN_IN_SECOND))
        } catch let error {
            tvResult.text = "error:" + error.localizedDescription
        }
        
       
           
    }
   
    
    @IBAction func SaveAction(_ sender: Any) {
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
                    //navigationController?.popViewController(animated: true)
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
                            //navigationController?.popViewController(animated: true)
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
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) { // Диктофон завершив запис
        labelBtn.text = "Recognizing..."
        if flag {
            let url = NSURL.fileURL(withPath: _recorderFilePath)
            
           
            guard let audioData = try? Data(contentsOf:url) else { return }
      
            let audioStr: String = audioData.base64EncodedString()
            
            //guard let url = URL(string: "https://speechtotextnotes.pythonanywhere.com/post_json") else { return }
            guard let url = URL(string: "http://127.0.0.1:5000/post_json") else { return }
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
            
            if SettingsTwoClass.shared.currentSettings.LangSetting == "Ukrainian"{
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
                    if str == "" {
                        self.tvResult.text = "You didn't say anything"
                        self.btnStart.setImage(UIImage(named: "playIcon.png"), for: .normal)
                        self.labelBtn.text = " "
                    }else{
                    self.tvResult.text = str
                    self.btnStart.setImage(UIImage(named: "playIcon.png"), for: .normal)
                    self.labelBtn.text = " "
                    }
                }

            }
            task.resume()
        }
        else {
            tvResult.text = "Recording error"
        }
        
        
    }


}
extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
      }
}

