//
//  Card.swift
//  CielFlashCard
//
//  Created by Raphael on 25/10/24.
//

import Foundation
import SwiftData
import SwiftUI
import AVKit
@Model
class Card: Identifiable {
    var question: String
    var piyin : String
    var answer: String
    var point : Int = 0
    init(_ question: String, _ answer: String) {
        self.question = question
        self.answer = answer
        self.point = 0
        self.piyin = ""
        self.piyin = chineseToPinyinWithTones(question) ?? ""
    }
    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
        self.point = 0
        self.piyin = ""
        self.piyin = chineseToPinyinWithTones(question) ?? ""
    }
    init(question : String,answer:String,piyin:String){
        self.question = question
        self.answer = answer
        self.piyin = piyin
        self.point = 0
    }
    func minusPoint(int x : Int){
        point -= x
        if(point < 0){
            point = 0
        }
    }
    func addPoint(int x : Int){
        point += x
    }
    func resetScore(){
        point = 0
    }
    func getColor() -> Color {
        switch self.point {
        case 91...:
            return Color.greenCard        // >90 Green
        case 71...90:
            return Color.greenYellowCard // >70 Green-Yellow
        case 51...70:
            return Color.yellowCard          // >50 Yellow
        case 31...50:
            return Color.orangeCard         // >30 Orange
        case 1...30:
            return Color.redCard           // >0 Red
        default:
            return Color.grayCard        // Handle edge case of negative points or zero
        }
    }
    func getGrade() -> String {
        switch self.point {
        case 91...:
            return "A"                     // >90
        case 71...90:
            return "B"                     // >70
        case 51...70:
            return "C"                     // >50
        case 31...50:
            return "D"                     // >30
        case 1...30:
            return "E"                     // >0
        default:
            return "F"                     // Edge case: zero or negative points
        }
    }
    func chineseToPinyinWithTones(_ chinese: String) -> String? {
        let mutableString = NSMutableString(string: chinese)
        if CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false) {
            return mutableString as String
        }
        return nil
    }
    func SpeakQuestion() {
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance = AVSpeechUtterance(string: question)
        speechUtterance.rate = 0.45
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")//chinese Code Language
        speechSynthesizer.speak(speechUtterance)
    }
}
