import SwiftUI

struct ContentView: View {
    @State private var statusText = "Тестовое приложение готово"
    @State private var clickCount = 0

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 60))
                .foregroundColor(.orange)

            Text("Smart Alarm: Тест CI")
                .font(.title)
                .bold()

            Text(statusText)
                .foregroundColor(.secondary)

            Button(action: {
                clickCount += 1
                statusText = "Кнопка нажата \(clickCount) раз"
            }) {
                Text("Проверить работу")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
        }
        .padding()
    }
}
