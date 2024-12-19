//
//  QuizzesModel.swift
//  Quiz
//
//  Created by Santiago Pavón Gómez on 18/10/24.
//

import Foundation

/// Errores producidos en el modelo de los Quizzes
enum QuizzesModelError: LocalizedError {
    case internalError(msg: String)
    case corruptedDataError
    case unknownError
    case malresp
    
    var errorDescription: String? {
        switch self {
        case .internalError(let msg):
            return "Error interno: \(msg)"
        case .corruptedDataError:
            return "Recibidos datos corruptos"
        case .unknownError:
            return "No chungo ha pasado"
        case .malresp:
            return "fallas respuesta"
        }
    }
}

@Observable class QuizzesModel {
    
    // Los datos
    private(set) var quizzes = [QuizItem]()

    func load() async throws {
        
        guard let jsonURL = Endpoints.random10() else {
            throw QuizzesModelError.internalError(msg: "URL inválida")
        }
        print("URL usada: \(jsonURL)")
        do {
            let (data, response) = try await URLSession.shared.data(from: jsonURL)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Código de respuesta: \(httpResponse.statusCode)")
            }
            print("Quizzes ==>", String(data: data, encoding: String.Encoding.utf8) ?? "JSON incorrecto")
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw QuizzesModelError.corruptedDataError
            }
            
            guard let quizzes = try? JSONDecoder().decode([QuizItem].self, from: data) else {
                throw QuizzesModelError.unknownError
            }
            self.quizzes = quizzes
            print("Quizzes cargados: \(quizzes)")
        } catch {
            print("Error al cargar quizzes: \(error.localizedDescription)")
            throw error
        }
    }
    
    
    func check(quizItem: QuizItem, answer: String) async throws -> Bool{
        guard let url = Endpoints.checkAnswer(quizItem: quizItem, answer: answer) else{
            throw QuizzesModelError.internalError(msg: "URL inválida")
        }
        print("URL usada: \(url)")
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Código de respuesta: \(httpResponse.statusCode)")
            }
            guard (response as? HTTPURLResponse)?.statusCode == 200 else{
                throw QuizzesModelError.corruptedDataError
            }
            
            guard let res = try? JSONDecoder().decode(CheckResponseItem.self, from: data) else{
                throw QuizzesModelError.unknownError
            }
            return res.result
        }catch {
            print("Error al cargar quizzes: \(error.localizedDescription)")
            throw error
        }
    }
    
    func toggleFavourite(quizItem: QuizItem) async throws {
        
        guard let url = Endpoints.toggleFav(quizItem: quizItem) else {
            throw QuizzesModelError.internalError(msg: "URL inválida")
        }
        print("URL usada: \(url)")
        do{
            var request = URLRequest(url: url)
            request.httpMethod = quizItem.favourite ?  "DELETE" : "PUT"
            
            let (data, response) = try await URLSession.shared.data(for: request) // Ojo con for y no from.
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Código de respuesta: \(httpResponse.statusCode)")
            }
            guard (response as? HTTPURLResponse)?.statusCode == 200 else{
                throw QuizzesModelError.corruptedDataError
            }
            print("Quizzes ==>", String(data: data, encoding: String.Encoding.utf8) ?? "JSON incorrecto")
        
            guard let res = try? JSONDecoder().decode(FavouriteStatusItem.self, from: data)  else {
                throw QuizzesModelError.unknownError
            }
            guard let index = quizzes.firstIndex(where:{q in
                q.id == quizItem.id
            })  else {
                throw QuizzesModelError.malresp
            }
            var updatedQuiz = quizzes[index]
            updatedQuiz.favourite = res.favourite

            quizzes[index] = updatedQuiz
        } catch {
            print("Error al cargar quizzes: \(error.localizedDescription)")
            throw error
        }
             
    }
    
    func getAnswer(quizItem: QuizItem) async throws -> String {
     guard let url = Endpoints.getAnswer(quizItem: quizItem) else{
     throw QuizzesModelError.internalError(msg: "URL inválida")
     }
    print("URL usada: \(url)")
        do{
            let (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse {
                print("Código de respuesta: \(httpResponse.statusCode)")
            }
            guard (response as? HTTPURLResponse)?.statusCode == 200 else{
                throw QuizzesModelError.corruptedDataError
            }
            print("Quizzes ==>", String(data: data, encoding: String.Encoding.utf8) ?? "JSON incorrecto")
            guard let res = try? JSONDecoder().decode(AnswerItem.self, from: data) else{
            throw QuizzesModelError.unknownError
            }
            return res.answer
        }catch {
            print("Error al cargar quizzes: \(error.localizedDescription)")
            throw error
        }
     }
     
     
     
     
     
     
     
     
    /* extension String: LocalizedError{
     public var errorDescription : String? {
     return self
     }*/
    
    
    
}
