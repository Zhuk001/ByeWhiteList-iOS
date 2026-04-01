import Foundation

class AutoModeManager: ObservableObject {
    static let shared = AutoModeManager()
    
    @Published var status = "Готов"
    @Published var isSearching = false
    
    private init() {}
    
    func start() {
        status = "Поиск сервера..."
        isSearching = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.status = "Сервер найден"
            self.isSearching = false
        }
    }
    
    func stop() {
        status = "Остановлен"
        isSearching = false
    }
    
    func resetCache() {
        status = "Кэш очищен"
    }
}