//
//  ScoresModel.swift
//  QuizApp
//
//  Created by d058 DIT UPM on 4/12/24.
//

import SwiftUI

@Observable class ScoresModel{
    
    var acertadas: Set<Int> = []
    var record: Set<Int> = []

      init(){
          let a = UserDefaults.standard.object(forKey: "record") as? [Int] ?? []  //sino devuelvo arrazy vacio
          record = Set(a)
      }

      func check(quizItem: QuizItem, answer: String){

  //        if answer =+-= quizItem.answer{
  //            acertadas.insert(quizItem.id)
  //        }
      }
    /*func aciertos() {
        acertadas.count
    }*/

      func add(quizItem: QuizItem) {
          acertadas.insert(quizItem.id)
          record.insert(quizItem.id)

          UserDefaults.standard.set(Array(record), forKey: "record")
          UserDefaults.standard.synchronize()
      }

      func noacertadas(_ quizItem: QuizItem) -> Bool{
          !acertadas.contains(quizItem.id)
      }

      func reset(){
          acertadas = []
      }
}
