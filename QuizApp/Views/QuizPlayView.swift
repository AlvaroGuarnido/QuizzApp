import SwiftUI

struct QuizPlayView: View {
    @Environment(\.presentationMode) var presentationMode // Manejar el botón de retroceso
    @Environment(\.verticalSizeClass) var verticalSizeClass // Detectar la orientación
    
    var quizItem: QuizItem
    var scoresModel: ScoresModel
    var quizzesModel: QuizzesModel
    
    @State private var rotation: Double = 0.0  // Para la rotación del campo de texto
    @State private var scale: CGFloat = 1.0
    @State private var answer: String = "" // Respuesta del usuario
    @State private var showAlert = false // Estado de la alerta
    @State private var isCorrect = false // Resultado de la respuesta
    @State var checkResponse = false
    @State var show_puntos: Bool = false
    @State var errorMsg = "" {
        didSet{                                //cada vez que se cambie errorMsg ponemos a true el showErrorMsgAlert
            showAlert = true
        }}

    
    var body: some View {
        Group {
            if verticalSizeClass == .regular {
                verticalLayout
            } else {
                horizontalLayout
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(isCorrect ? "¡Correcto!" : "Incorrecto"),
                message: Text(isCorrect ? "¡Bien hecho! Has acertado." : "La respuesta es incorrecta, inténtalo de nuevo."),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationTitle("Jugar: \(quizItem.id)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.blue)
                }
            }
        }
    }
    
    private var verticalLayout: some View {
        VStack {
            pregunta
            attachment
            field
            comprobar
            HStack{
                fotoautor
                estrella
            }
            
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.orange.opacity(0.2), .pink.opacity(0.2)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(15)
        .shadow(color: .pink.opacity(0.5), radius: 10, x: 0, y: 5)
        .padding()
    }
    
    private var horizontalLayout: some View {
        HStack {
            VStack {
                pregunta
                field
                comprobar
                estrella
            }
            fotoautor
            attachment
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.2), .purple.opacity(0.2)]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(15)
        .shadow(color: .purple.opacity(0.5), radius: 10, x: 0, y: 5)
        .padding()
    }
    
    private var field: some View {
        TextField("Introduce tu respuesta aquí", text: $answer)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
            .shadow(color: .gray.opacity(0.4), radius: 3, x: 1, y: 1)
            .onSubmit {
                Task {
                    try await checkingResponse()
                }
            }
        
    }
    
    
    private var comprobar: some View {
        Button(action:{Task {
            try await checkingResponse()
            }
        }) {
            Text("Comprobar respuesta")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(LinearGradient(
                    gradient: Gradient(colors: [.green, .blue]),
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .cornerRadius(10)
                .shadow(color: .green.opacity(0.4), radius: 5, x: 2, y: 2)
        }
        .padding(.horizontal)
    }
    
    private var fotoautor: some View {
        VStack{
            // Menu contextual sobre la foto
            Menu {
                Button("Limpiar respuesta") {
                    answer = ""
                }
                Button("Rellenar con respuesta correcta") {
                    Task {
                        try await fetchCorrectAnswer()
                    }
                }
            } label: {
                QuizAsyncImage(url: quizItem.author?.photo?.url)
                    .frame(width: 20, height: 20)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.yellow, lineWidth: 2))
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1)
            }
        }
    }
    
    private var pregunta: some View {
        Text(quizItem.question)
            .lineLimit(10)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.purple)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .shadow(color: .purple.opacity(0.4), radius: 3, x: 1, y: 1)
    }
    private var estrella: some View {
        Button(action: {
            Task {
                do {
                    try await quizzesModel.toggleFavourite(quizItem: quizItem)
                } catch {
                    print("Error al alternar favorito: \(error.localizedDescription)")
                }
            }
        }) {
            Image(systemName: quizItem.favourite ? "star.fill" : "star")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(quizItem.favourite ? .yellow : .gray)
                .shadow(color: quizItem.favourite ? .yellow.opacity(0.7) : .clear, radius: 5)
        }
    }
    private var attachment: some View {
        GeometryReader { geom in
            
            QuizAsyncImage(url: quizItem.attachment?.url)
                .scaledToFit()
                .frame(width: geom.size.width, height: geom.size.width)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .shadow(color: .black, radius: 10)
                .scaleEffect(scale)
                .rotationEffect(Angle(degrees: rotation))
                .onTapGesture(count: 2) {
                    Task {
                        withAnimation {
                            scale = 0.2  // Aumentamos la escala del TextField
                            rotation = 360  // Rotamos 360 grados
                        }
                         try await Task.sleep(nanoseconds: 400_000_000)
                        try await fetchCorrectAnswer()
                        // Animar el campo de respuesta
                       
                            withAnimation {
                                scale = 1.0  // Volvemos a la escala original
                                rotation = 0  // Volvemos a la rotación original
                            }
                        
                    }
                    
                }
        }
        
        /*
         .shadow(color: .green.opacity(0.5), radius: 10, x: 0, y: 5)*/
        .padding(.horizontal) // Ajusta el espacio horizontal alrededor de la imagen
        
        .aspectRatio(1, contentMode: .fit) // Mantiene una relación de aspecto cuadrada
        .padding()
    }

    
    private func fetchCorrectAnswer() async throws {
            do {
                let resp = try await quizzesModel.getAnswer(quizItem: quizItem)
                answer = resp // Rellenamos el TextField con la respuesta correcta
            } catch {
                print("Error al obtener la respuesta correcta: \(error.localizedDescription)")
            }
        }
    
    func checkingResponse() async throws {
        
        do{
            checkResponse = true
            
            isCorrect = try await quizzesModel.check(quizItem: quizItem, answer: answer)
        
            showAlert = true
            
        if isCorrect{
            scoresModel.add(quizItem: quizItem)
        }
            
            checkResponse = false
            
        } catch {
            errorMsg = error.localizedDescription
        }
        
    }}



    
    // Imagen en la barra inferior
    /*ToolbarItem(placement: .bottomBar) {
     HStack {
     Spacer()
     Image("sunrise") // Imagen a la derecha en la barra inferior
     .resizable()
     .scaledToFit()
     .frame(width: 40, height: 40) // Ajusta el tamaño
     .foregroundColor(.yellow)
     Spacer()*/
    
    
    
    
    
    
/*
 #Preview {
 @Previewable @State var quizzesModel = QuizzesModel(
 
 let _ = quizzesModel.load()
 
 QuizPlayView(quizItem: quizzesModel.quizzes[4])
 )
 }
 */
