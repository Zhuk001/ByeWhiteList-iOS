import Foundation

class ConfigManager: ObservableObject {
    static let shared = ConfigManager()
    
    @Published var isBlockedMode = false
    @Published var selectedServerId: String?
    
    private init() {}
    
    func loadServersFromURLs() async {
        print("Loading servers...")
        // Здесь будет загрузка серверов
    }
}