//
//  AddEventCellView.swift
//  Five
//
//  Created by Zach Govani on 11/3/18.
//  Copyright © 2018 Mobile Developers of Berkeley. All rights reserved.
//

import UIKit
import GradientView
import UIColor_Hex_Swift
import SkyFloatingLabelTextField
import DatePicker
import Speech

class AddSpeechEventCellView: SpringView, SFSpeechRecognizerDelegate {
    
    var titleLabel: UILabel!
    var nameField: SkyFloatingLabelTextField!
    var doneButton: UIButton!
    var calendarIcon: UIButton!
    var dateLabel: UILabel!
    var textView: SkyFloatingLabelTextField!
    var microphoneButton: UIButton!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var viewController: UIViewController!
    
    init(frame: CGRect, controller: UIViewController) {
        super.init(frame: frame)
        viewController = controller
        animation = "slideLeft"
        initLayer()
        initUIElements()
        initMic()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initMic() {
        microphoneButton.isEnabled = false
        
        speechRecognizer.delegate = self as? SFSpeechRecognizerDelegate
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
    }
    
    private func initLayer() {
        backgroundColor = UIColor("#392C79")
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 6)
        self.layer.shadowOpacity = 0.5
    }
    
    private func initUIElements() {
        titleLabel = UILabel(frame: CGRect(x: 20, y: 10, width: frame.width - 40, height: 40))
        titleLabel.font = UIFont(name: "Quicksand-Bold", size: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.text = "New Task"
        addSubview(titleLabel)
        
        doneButton = UIButton(frame: CGRect(x: frame.width - 20 - 35, y: 20, width: 35, height: 35))
        doneButton.setImage(UIImage(named: "checkIcon"), for: .normal)
//        addSubview(doneButton)

        microphoneButton = UIButton(frame: CGRect(x:20, y: titleLabel.frame.minY + 40, width: 35, height:35))
        microphoneButton.setImage(UIImage(named: "microphone"), for: .normal)
        microphoneButton.addTarget(self, action: #selector(microphoneTapped), for: .touchUpInside)
        addSubview(microphoneButton)

        textView = SkyFloatingLabelTextField(frame: CGRect(x:20, y: microphoneButton.frame.minY + 40, width: self.frame.width - 40, height:35))
        textView.adjustsFontForContentSizeCategory = true
        
        textView.placeholder = "Press the microphone to add a task"
        textView.selectedLineColor = .white
        textView.selectedTitleColor = .white
        textView.placeholderColor = .white
        textView.textColor = .white
        textView.tintColor = .white
        textView.font = UIFont(name: "Quicksand-Medium", size: 16)
        textView.titleFont = UIFont(name: "Quicksand-Medium", size: 14)!
        addSubview(textView)
    }
    
    @objc func microphoneTapped() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
            microphoneButton.setTitle("Start Recording", for: .normal)
            print(textView.text)
            doneButton.sendActions(for: .touchUpInside)
        } else {
            startRecording()
        }
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    func startRecording() {
        
        if recognitionTask != nil {  //1
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()  //2
        do {
            try AVAudioSession.sharedInstance().setCategory(.record, mode: .default, options: [])
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()  //3
        
        guard let inputNode = Optional(audioEngine.inputNode) else {
            fatalError("Audio engine has no input node")
        }  //4
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        } //5
        
        recognitionRequest.shouldReportPartialResults = true  //6
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in  //7
            
            var isFinal = false  //8
            
            if result != nil {
                self.textView.text = result?.bestTranscription.formattedString  //9
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {  //10
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)  //11
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()  //12
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        textView.text = "Say something, I'm listening!"
        
    }
    
}
