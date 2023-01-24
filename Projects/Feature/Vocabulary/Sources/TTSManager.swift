//
//  TTSManager.swift
//  Vocabulary
//
//  Created by bongzniak on 2023/01/24.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import AVFoundation

protocol TTSManagerDelegate: AnyObject {
    func speechDidFinish()
}

class TTSManager: NSObject {
    
    static let shared = TTSManager()
    
    weak var delegate: TTSManagerDelegate?
    
    private let synthesizer = AVSpeechSynthesizer()
    
    override init() {
        super.init()
        
        synthesizer.delegate = self
    }
    
    internal func play(_ string: String) {
        let utterance = AVSpeechUtterance(string: string)
        // utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        synthesizer.stopSpeaking(at: .immediate)
        synthesizer.speak(utterance)
    }
    
    internal func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    internal func isPlaying() -> Bool {
        synthesizer.continueSpeaking()
    }
}

extension TTSManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didFinish utterance: AVSpeechUtterance
    ) {
        delegate?.speechDidFinish()
    }
}
