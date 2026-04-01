import Foundation

struct ProxyEntity: Identifiable, Codable {
    var id = UUID().uuidString
    let name: String
    let type: String
    let config: String
}
