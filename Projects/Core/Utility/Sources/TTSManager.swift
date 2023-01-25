//
//  TTSManager.swift
//  Vocabulary
//
//  Created by bongzniak on 2023/01/24.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import AVFoundation
import NaturalLanguage

public protocol TTSManagerDelegate: AnyObject {
    func speechDidFinish()
}

public class TTSManager: NSObject {
    
    public static let shared = TTSManager()
    
    public weak var delegate: TTSManagerDelegate?
    
    private let synthesizer = AVSpeechSynthesizer()
    
    override init() {
        super.init()
        
        synthesizer.delegate = self
    }
    
    public func play(_ string: String) {
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5

        synthesizer.stopSpeaking(at: .immediate)
        synthesizer.speak(utterance)
    }
    
    public func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    public func isPlaying() -> Bool {
        synthesizer.continueSpeaking()
    }
}

extension TTSManager: AVSpeechSynthesizerDelegate {
    public func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didFinish utterance: AVSpeechUtterance
    ) {
        delegate?.speechDidFinish()
    }
}
