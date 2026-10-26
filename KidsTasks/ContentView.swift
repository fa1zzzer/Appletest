import SwiftUI

struct TaskItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var icon: String
    var isDone: Bool = false
    var stars: Int = 1
}

class KidsTasksViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = [
        TaskItem(title: "Проснуться вовремя", icon: "sun.max.fill"),
        TaskItem(title: "Почистить зубы", icon: "mouth.fill"),
        TaskItem(title: "Заправить кровать", icon: "bed.double.fill"),
        TaskItem(title: "Одеться в школу", icon: "tshirt.fill"),
        TaskItem(title: "Собрать рюкзак", icon: "bag.fill"),
        TaskItem(title: "Сделать уроки", icon: "book.fill", stars: 2),
        TaskItem(title: "Убрать игрушки", icon: "cube.box.fill"),
        TaskItem(title: "Почитать 15 минут", icon: "text.book.closed.fill", stars: 2)
    ]
    
    @Published var totalStars: Int = 0
    
    func toggleTask(_ task: TaskItem) {
        if let idx = tasks.firstIndex(where: { /usr/bin/bash.id == task.id }) {
            tasks[idx].isDone.toggle()
            if tasks[idx].isDone {
                totalStars += tasks[idx].stars
            } else {
                totalStars = max(0, totalStars - tasks[idx].stars)
            }
        }
    }
    
    func resetDay() {
        for i in 0..<tasks.count {
            tasks[i].isDone = false
        }
    }
}

struct ContentView: View {
    @StateObject private var vm = KidsTasksViewModel()
    
    var completedCount: Int {
        vm.tasks.filter { /usr/bin/bash.isDone }.count
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Детские дела")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                    Text("Выполнено: \(completedCount) из \(vm.tasks.count)")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }
                Spacer()
                // Star Counter
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 24))
                    Text("\(vm.totalStars)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            // Progress Bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 10)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.green)
                        .frame(width: max(0, geo.size.width * CGFloat(completedCount) / CGFloat(max(1, vm.tasks.count))), height: 10)
                        .animation(.spring(), value: completedCount)
                }
            }
            .frame(height: 10)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            
            // Task List
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(vm.tasks) { task in
                        Button(action: {
                            vm.toggleTask(task)
                        }) {
                            HStack(spacing: 16) {
                                Image(systemName: task.icon)
                                    .font(.system(size: 24))
                                    .foregroundColor(task.isDone ? .gray : .blue)
                                    .frame(width: 36)
                                
                                Text(task.title)
                                    .font(.system(size: 18, weight: .medium))
                                    .strikethrough(task.isDone, color: .gray)
                                    .foregroundColor(task.isDone ? .gray : .primary)
                                
                                Spacer()
                                
                                if task.isDone {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.system(size: 26))
                                } else {
                                    HStack(spacing: 2) {
                                        Text("+\(task.stars)")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.orange)
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                            .font(.system(size: 14))
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.orange.opacity(0.15))
                                    .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(task.isDone ? Color.gray.opacity(0.1) : Color.white)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(task.isDone ? 0 : 0.05), radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            
            // Footer
            if completedCount == vm.tasks.count && !vm.tasks.isEmpty {
                VStack(spacing: 8) {
                    Text("🎉 Все дела сделаны! Молодец!")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.green)
                    Button(action: {
                        vm.resetDay()
                    }) {
                        Text("Начать новый день")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.blue)
                    }
                }
                .padding(.vertical, 12)
            }
        }
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}
