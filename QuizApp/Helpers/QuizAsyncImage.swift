//
//  QuizAsyncImage.swift
//  QuizApp
//
//  Created by d058 DIT UPM on 29/11/24.
//

import SwiftUI

struct QuizAsyncImage: View {
    
    var url:URL?
    var body: some View {
        AsyncImage(url: url) { phase in
            if url == nil {
                Color.white
            } else if let image = phase.image {
                image.resizable()
            } else if let error = phase.error {
                Color.red
            } else {
                ProgressView()
            }
        }
    }
}

#Preview {
    QuizAsyncImage()
}
