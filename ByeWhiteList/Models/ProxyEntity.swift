import Foundation

struct ProxyEntity: Identifiable, Codable {
    let id = UUID().uuidString
    let name: String
    let type: String
    let config: String
}