//
//  CheckResponseItem.swift
//  QuizApp
//
//  Created by d058 DIT UPM on 16/12/24.
//

import Foundation
struct CheckResponseItem: Codable{
    
    let quizId: Int
    let answer: String
    let result: Bool
    
}
