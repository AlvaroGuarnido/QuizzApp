//
//  Endpoints.swift
//  QuizApp
//
//  Created by d058 DIT UPM on 12/12/24.
//

import SwiftUI

let urlBase = "https://quiz.dit.upm.es"

let token = "335dc132b8f5e4278f83"

struct Endpoints {
    
    static func random10() -> URL? {                    //funcion que pide 10 quizzes random
        let path = "/api/quizzes/random10"
        let str = "\(urlBase)\(path)?token=\(token)"
        return URL(string: str)
    }
    
    static func checkAnswer(quizItem: QuizItem, answer: String) -> URL? {                    //funcion que comprueba las respuestas
        let path = "/api/quizzes/\(quizItem.id)/check"
        guard let answer_corregida = answer.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)           //corrijo la respuesta para no meter caracteres raros en la url
        else {return nil}
        let str = "\(urlBase)\(path)?answer=\(answer_corregida)&token=\(token)"
        return URL(string: str)
    }
    static func toggleFav(quizItem: QuizItem) -> URL? {
            let path = "/api/users/tokenOwner/favourites/\(quizItem.id)"
            let str = "\(urlBase)\(path)?token=\(token)"
            return URL(string: str)
        }

        
    static func getAnswer(quizItem: QuizItem) -> URL? {
                let path = "/api/quizzes/\(quizItem.id)/answer"
                let str = "\(urlBase)\(path)?token=\(token)"
                return URL(string: str)
        }
}

/*#Preview {
    Endpoints()
}*/
