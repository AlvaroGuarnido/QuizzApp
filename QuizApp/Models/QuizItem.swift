import Foundation

struct QuizItem: Identifiable, Codable {
    let id: Int
    let question: String
    let attachment: Attachment?
    var favourite: Bool
    let author: Author?
}

struct Attachment: Codable {
    let mime: String?
    let url: URL?
}

struct Author: Codable {
    let id: Int
    let isAdmin: Bool?
    let username: String?
    let accountTypeId: Int
    let profileId: Decimal?
    let profileName: String?
    let photo: Attachment?
}

