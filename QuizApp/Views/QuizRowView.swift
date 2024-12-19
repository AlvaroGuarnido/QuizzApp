import SwiftUI

struct QuizRowView: View {
    var quizItem: QuizItem
    var quizzesModel: QuizzesModel
    
    @State private var showUnansweredOnly: Bool = false  // Variable de estado para el Toggle

    var body: some View {
        HStack(alignment: .top) {
            attachment
            pregunta
            Spacer()
            
            VStack {
                nombre
                fotoautor
            }
            
            HStack {
                estrella
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(15)
        .shadow(color: .blue.opacity(0.5), radius: 10, x: 5, y: 5)
        .padding([.leading, .trailing])
    }
    
    private var pregunta: some View {
        Text(quizItem.question)
            .font(.body)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .lineLimit(3) // Mostrar máximo 3 líneas
            .truncationMode(.tail)
            .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1)
    }
    
    private var attachment: some View {
        let attachmentUrl = quizItem.attachment?.url
        return QuizAsyncImage(url: attachmentUrl)
            .frame(width: 60, height: 60)
            .scaledToFill()
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 2)
            )
            .padding(.trailing, 8)
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
    
    private var nombre: some View {
        Text(quizItem.author?.username ??
             quizItem.author?.profileName ?? "Anónimo")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.pink)
            .lineLimit(1)
            .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
    }
    
    private var fotoautor: some View {
        let authorFoto = quizItem.author?.photo?.url
        return QuizAsyncImage(url: authorFoto)
            .frame(width: 20, height: 20)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.yellow, lineWidth: 2))
            .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1)
    }
}
