import NetworkExtension
import os

class PacketTunnelProvider: NEPacketTunnelProvider {
    
    private let log = OSLog(subsystem: "vg.byewhitelist", category: "PacketTunnel")
    private var singboxTask: Task<Void, Never>?
    
    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        os_log("Starting tunnel", log: log, type: .info)
        
        // Получаем конфиг сервера из App Group
        let sharedDefaults = UserDefaults(suiteName: "group.vg.byewhitelist")
        guard let serverConfig = sharedDefaults?.string(forKey: "serverConfig"),
              let serverName = sharedDefaults?.string(forKey: "serverName") else {
            os_log("No server config found", log: self.log, type: .error)
            completionHandler(NSError(domain: "ByeWhiteList", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "No server configuration"
            ]))
            return
        }
        
        os_log("Starting with server: %{public}@", log: log, type: .info, serverName)
        
        // Настраиваем туннель
        let settings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "127.0.0.1")
        settings.mtu = 1500
        
        // IP настройки
        let ipv4Settings = NEIPv4Settings(addresses: ["192.168.1.1"], subnetMasks: ["255.255.255.0"])
        ipv4Settings.includedRoutes = [NEIPv4Route.default()]
        settings.ipv4Settings = ipv4Settings
        
        // DNS настройки
        let dnsSettings = NEDNSSettings(servers: ["8.8.8.8", "1.1.1.1"])
        dnsSettings.matchDomains = [""]
        settings.dnsSettings = dnsSettings
        
        // Применяем настройки
        setTunnelNetworkSettings(settings) { error in
            if let error = error {
                os_log("Failed to set network settings: %{public}@", log: self.log, type: .error, error.localizedDescription)
                completionHandler(error)
                return
            }
            
            // Запускаем Sing-box
            self.startSingbox(with: serverConfig)
            completionHandler(nil)
        }
    }
    
    private func startSingbox(with config: String) {
        os_log("Starting Sing-box with config", log: log, type: .info)
        
        // TODO: Здесь будет интеграция с Sing-box
        // Пока эмуляция работы
        singboxTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                // Имитация трафика
                self.packetFlow.readPackets { packets, protocols in
                    // Обработка пакетов (будет после интеграции Sing-box)
                }
            }
        }
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        os_log("Stopping tunnel: %{public}@", log: log, type: .info, String(describing: reason))
        
        singboxTask?.cancel()
        singboxTask = nil
        
        completionHandler()
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        os_log("App message received", log: log, type: .debug)
        completionHandler?(nil)
    }
}