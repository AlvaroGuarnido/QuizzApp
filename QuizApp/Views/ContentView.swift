//
//  ContentView.swift
//  QuizApp
//
//  Created by d058 DIT UPM on 29/11/24.
//

import SwiftUI

struct ContentView: View{
    
    @State var quizzesModel = QuizzesModel()
    @State var scoresModel = ScoresModel()
    @State private var botonini = true
    @State private var showAll = true // Estado mostrar todos
    
    var body: some View{
        NavigationStack {
            if botonini {
                                Button(action: {
                                    Task {
                                        do {
                                            try await quizzesModel.load()
                                            botonini = false // Oculta el botón después de pulsarlo
                                        } catch {
                                            print("Error al cargar quizzes: \(error.localizedDescription)")
                                        }
                                    }
                                }) {
                                    Text("Pincha para cargar Quizzes")
                                        .font(.headline)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .padding()
                            }
            List {
                Toggle("Todos los Quizzes", isOn: $showAll)   //switch para cambiar todos
                ForEach(quizzesModel.quizzes) { quizItem in
                    if showAll || scoresModel.noacertadas(quizItem){
                        NavigationLink(destination: QuizPlayView(quizItem: quizItem, scoresModel: scoresModel, quizzesModel: quizzesModel) ){
                            QuizRowView (quizItem: quizItem, quizzesModel: quizzesModel)
                        }
                    }
                }
            }
            .listStyle(.grouped)
            .navigationTitle("All Quizzes")
            .toolbar {
                // ToolbarItem(placement: .topBarLeading){
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button {
                        Task {
                            do {
                                try await quizzesModel.load()
                                scoresModel.reset()                                } catch {
                                    print("Error al cargar quizzes: \(error.localizedDescription)")
                                }
                        }
                    } label: {
                        Label("Cargar nuevos Quizzes", systemImage: "arrow.counterclockwise")
                    }
                }
                
                
                
                ToolbarItem(placement: .automatic){
                    Text("RECORD = \(scoresModel.record.count)")
                    Image("List") // Imagen a la derecha
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.yellow)
                }
                ToolbarItem(placement: .navigationBarLeading){
                    
                    Text("Acertados: \(scoresModel.acertadas.count)")
                    
                    
                    //.font(.title)
                }
            }
            .padding()
            }
        }
       
    }


/*#Preview{
 
 ContentView()
 }
 */

