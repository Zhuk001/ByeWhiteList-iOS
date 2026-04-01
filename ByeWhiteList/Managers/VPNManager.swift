import Foundation
import NetworkExtension

class VPNManager: ObservableObject {
    static let shared = VPNManager()
    
    @Published var isConnected: Bool = false
    @Published var status: String = "Отключен"
    
    private var manager: NETunnelProviderManager?
    private let sharedDefaults = UserDefaults(suiteName: "group.vg.byewhitelist")
    
    private init() {
        loadProfile()
        monitorStatus()
    }
    
    func loadProfile() {
        NETunnelProviderManager.loadAllFromPreferences { [weak self] managers, error in
            if let managers = managers, let first = managers.first {
                self?.manager = first
            } else {
                self?.createProfile()
            }
        }
    }
    
    private func createProfile() {
        let manager = NETunnelProviderManager()
        manager.localizedDescription = "byeWhiteList"
        
        let proto = NETunnelProviderProtocol()
        proto.providerBundleIdentifier = "vg.byewhitelist.VPNExtension"
        proto.serverAddress = "byeWhiteList VPN"
        proto.disconnectOnSleep = false
        
        // Настройки для Sing-box
        var configData: [String: Any] = [:]
        configData["MTU"] = 1500
        configData["DNS"] = ["8.8.8.8", "1.1.1.1"]
        
        if let data = try? JSONSerialization.data(withJSONObject: configData) {
            proto.providerConfiguration = ["config": data]
        }
        
        manager.protocolConfiguration = proto
        manager.isEnabled = true
        
        manager.saveToPreferences { error in
            if error == nil {
                self.manager = manager
            }
        }
    }
    
    func startWithServer(_ server: ProxyEntity) {
        guard let manager = manager else { return }
        
        // Сохраняем конфиг сервера для VPN Extension
        sharedDefaults?.set(server.config, forKey: "serverConfig")
        sharedDefaults?.set(server.name, forKey: "serverName")
        sharedDefaults?.set(server.type, forKey: "serverType")
        sharedDefaults?.synchronize()
        
        manager.isEnabled = true
        
        manager.saveToPreferences { error in
            if error == nil {
                do {
                    try manager.connection.startVPNTunnel()
                    self.status = "Подключение..."
                } catch {
                    print("Failed to start VPN: \(error)")
                    self.status = "Ошибка: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func restartWithServer(_ server: ProxyEntity) {
        stop()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.startWithServer(server)
        }
    }
    
    func stop() {
        manager?.connection.stopVPNTunnel()
        status = "Отключен"
    }
    
    private func monitorStatus() {
        NotificationCenter.default.addObserver(
            forName: .NEVPNStatusDidChange,
            object: manager?.connection,
            queue: .main
        ) { [weak self] _ in
            self?.updateStatus()
        }
    }
    
    private func updateStatus() {
        guard let connection = manager?.connection else { return }
        
        switch connection.status {
        case .connected:
            isConnected = true
            status = "Подключен"
        case .connecting:
            isConnected = false
            status = "Подключение..."
        case .disconnected:
            isConnected = false
            status = "Отключен"
        case .disconnecting:
            isConnected = false
            status = "Отключение..."
        case .invalid:
            isConnected = false
            status = "Недействительно"
        case .reasserting:
            isConnected = false
            status = "Переподключение..."
        @unknown default:
            isConnected = false
            status = "Неизвестно"
        }
    }
}
