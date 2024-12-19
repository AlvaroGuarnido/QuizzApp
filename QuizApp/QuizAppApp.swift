//
//  QuizAppApp.swift
//  QuizApp
//
//  Created by d058 DIT UPM on 29/11/24.
//

import SwiftUI

@main
struct QuizAppApp: App {
    @State var quizzesModel = QuizzesModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
