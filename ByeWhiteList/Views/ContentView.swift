import SwiftUI

struct ContentView: View {
    @State private var isConnected = false
    @State private var status = "Готов"
    
    var body: some View {
ZStack {
    // WebGL фон
    NebulaWebView()
        .ignoresSafeArea()
    
    VStack(spacing: 20) {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("byeWhiteList")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 60)
                
                Text("Пока, Белый Список!")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                // Кнопка VPN
                Button(action: {
                    isConnected.toggle()
                    status = isConnected ? "Подключен" : "Отключен"
                }) {
                    ZStack {
                        Circle()
                            .fill(isConnected ? Color.green : Color.red)
                            .frame(width: 160, height: 160)
                            .shadow(radius: 10)
                        
                        Text(isConnected ? "VPN\nВкл" : "VPN\nВыкл")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                }
                
                Text(status)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(20)
                
                Spacer()
                
                // Режим блокировки
                Toggle(isOn: .constant(false)) {
                    HStack {
                        Image(systemName: "shield.fill")
                            .foregroundColor(.orange)
                        Text("Режим блокировки")
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 32)
                
                // Скорость
                HStack(spacing: 20) {
                    Label("0 KB/s", systemImage: "arrow.down")
                        .foregroundColor(.green)
                    Label("0 KB/s", systemImage: "arrow.up")
                        .foregroundColor(.red)
                }
                .font(.caption)
                .padding(.bottom, 8)
                
                // Нижняя панель
                HStack(spacing: 40) {
                    Button(action: {}) {
                        VStack {
                            Image(systemName: "list.bullet")
                                .font(.title2)
                            Text("Сервера")
                                .font(.caption2)
                        }
                        .foregroundColor(.white)
                    }
                    
                    Button(action: {}) {
                        VStack {
                            Image(systemName: "gearshape")
                                .font(.title2)
                            Text("Меню")
                                .font(.caption2)
                        }
                        .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    ContentView()
}