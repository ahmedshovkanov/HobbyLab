import SwiftUI
import Charts

struct AnalyticsView: View {
    @EnvironmentObject var viewModel: HobbyViewModel
    @State private var selectedTimeRange: TimeRange = .week
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Time Range Selector
                    timeRangePicker
                    
                    // Overall Stats
                    overallStatsSection
                    
                    // Time Distribution by Hobby
                    timeDistributionSection
                    
                    // Activity Chart
                    activityChartSection
                    
                    // Hobby Breakdown
                    hobbyBreakdownSection
                }
                .padding()
            }
            .background(Color.hobbyLabSecondaryBackground)
            .navigationTitle("Analytics")
        }
    }
    
    private var timeRangePicker: some View {
        Picker("Time Range", selection: $selectedTimeRange) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(.segmented)
        .padding()
        .cardStyle()
    }
    
    private var overallStatsSection: some View {
        VStack(spacing: 12) {
            Text("Your Stats")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                MiniStatCard(
                    title: "Total Time",
                    value: formatTotalTime(getTotalTimeInRange()),
                    icon: "clock.fill",
                    color: .hobbyLabPrimary
                )
                
                MiniStatCard(
                    title: "Sessions",
                    value: "\(getSessionsInRange().count)",
                    icon: "calendar",
                    color: Color(hex: "#9C27B0")
                )
                
                MiniStatCard(
                    title: "Avg/Day",
                    value: formatTotalTime(getAverageTimePerDay()),
                    icon: "chart.line.uptrend.xyaxis",
                    color: Color(hex: "#4CAF50")
                )
                
                MiniStatCard(
                    title: "Completed",
                    value: "\(getCompletedTasksInRange())",
                    icon: "checkmark.circle.fill",
                    color: Color(hex: "#FF9800")
                )
            }
        }
    }
    
    private var timeDistributionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Time Distribution")
                .font(.headline)
            
            let distribution = getTimeDistribution()
            
            if distribution.isEmpty {
                EmptyStateView(
                    icon: "chart.pie.fill",
                    title: "No data yet",
                    message: "Start logging sessions to see your distribution"
                )
            } else {
                ForEach(distribution.sorted { $0.value > $1.value }, id: \.key) { hobby, time in
                    HobbyTimeBar(
                        hobbyName: hobby.name,
                        time: time,
                        totalTime: getTotalTimeInRange(),
                        color: Color(hex: hobby.color)
                    )
                }
            }
        }
        .padding()
        .cardStyle()
    }
    
    private var activityChartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily Activity")
                .font(.headline)
            
            let dailyData = getDailyActivityData()
            
            if dailyData.isEmpty {
                EmptyStateView(
                    icon: "chart.bar.fill",
                    title: "No activity",
                    message: "Log sessions to track your activity"
                )
            } else {
                Chart(dailyData) { item in
                    BarMark(
                        x: .value("Day", item.day),
                        y: .value("Hours", item.hours)
                    )
                    .foregroundStyle(Color.hobbyLabPrimary)
                    .cornerRadius(4)
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisValueLabel()
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
            }
        }
        .padding()
        .cardStyle()
    }
    
    private var hobbyBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hobby Breakdown")
                .font(.headline)
            
            ForEach(viewModel.hobbies) { hobby in
                HobbyAnalyticsCard(
                    hobby: hobby,
                    timeInRange: getTimeForHobby(hobby.id),
                    sessionsInRange: getSessionsForHobby(hobby.id)
                )
            }
        }
    }
    
    // MARK: - Data Functions
    
    private func getTotalTimeInRange() -> TimeInterval {
        getSessionsInRange().reduce(0) { $0 + $1.duration }
    }
    
    private func getSessionsInRange() -> [Session] {
        let calendar = Calendar.current
        let now = Date()
        
        let startDate: Date
        switch selectedTimeRange {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now)!
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now)!
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: now)!
        }
        
        var allSessions: [Session] = []
        for hobby in viewModel.hobbies {
            let sessions = viewModel.getAllSessions(for: hobby.id)
            allSessions.append(contentsOf: sessions.filter { $0.date >= startDate })
        }
        
        return allSessions
    }
    
    private func getAverageTimePerDay() -> TimeInterval {
        let days: Double
        switch selectedTimeRange {
        case .week: days = 7
        case .month: days = 30
        case .year: days = 365
        }
        
        return getTotalTimeInRange() / days
    }
    
    private func getCompletedTasksInRange() -> Int {
        let calendar = Calendar.current
        let now = Date()
        
        let startDate: Date
        switch selectedTimeRange {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now)!
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now)!
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: now)!
        }
        
        var count = 0
        for hobby in viewModel.hobbies {
            for project in hobby.projects {
                count += project.tasks.filter {
                    $0.isCompleted && ($0.completedDate ?? Date.distantPast) >= startDate
                }.count
            }
        }
        
        return count
    }
    
    private func getTimeDistribution() -> [Hobby: TimeInterval] {
        var distribution: [Hobby: TimeInterval] = [:]
        
        for hobby in viewModel.hobbies {
            let time = getTimeForHobby(hobby.id)
            if time > 0 {
                distribution[hobby] = time
            }
        }
        
        return distribution
    }
    
    private func getTimeForHobby(_ hobbyId: UUID) -> TimeInterval {
        let sessions = getSessionsInRange().filter { $0.hobbyId == hobbyId }
        return sessions.reduce(0) { $0 + $1.duration }
    }
    
    private func getSessionsForHobby(_ hobbyId: UUID) -> Int {
        getSessionsInRange().filter { $0.hobbyId == hobbyId }.count
    }
    
    private func getDailyActivityData() -> [DailyActivity] {
        let calendar = Calendar.current
        let days: Int
        
        switch selectedTimeRange {
        case .week: days = 7
        case .month: days = 30
        case .year: days = 12 // We'll show months for year view
        }
        
        var data: [DailyActivity] = []
        
        if selectedTimeRange == .year {
            // Show monthly data for year view
            for monthOffset in 0..<12 {
                let date = calendar.date(byAdding: .month, value: -11 + monthOffset, to: Date())!
                let monthStart = date.startOfMonth()
                let monthEnd = calendar.date(byAdding: .month, value: 1, to: monthStart)!
                
                let sessions = getSessionsInRange().filter {
                    $0.date >= monthStart && $0.date < monthEnd
                }
                
                let totalHours = sessions.reduce(0.0) { $0 + $1.duration } / 3600
                
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM"
                let monthName = formatter.string(from: date)
                
                data.append(DailyActivity(day: monthName, hours: totalHours))
            }
        } else {
            // Show daily data for week/month view
            for dayOffset in 0..<days {
                let date = calendar.date(byAdding: .day, value: -days + 1 + dayOffset, to: Date())!
                let dayStart = date.startOfDay()
                let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
                
                let sessions = getSessionsInRange().filter {
                    $0.date >= dayStart && $0.date < dayEnd
                }
                
                let totalHours = sessions.reduce(0.0) { $0 + $1.duration } / 3600
                
                let formatter = DateFormatter()
                formatter.dateFormat = selectedTimeRange == .week ? "EEE" : "d"
                let dayName = formatter.string(from: date)
                
                data.append(DailyActivity(day: dayName, hours: totalHours))
            }
        }
        
        return data
    }
    
    private func formatTotalTime(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h"
        } else {
            return "\(minutes)m"
        }
    }
}

// MARK: - Supporting Views and Models

struct DailyActivity: Identifiable {
    let id = UUID()
    let day: String
    let hours: Double
}

struct MiniStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.hobbyLabSecondaryText)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.hobbyLabCard)
        .cornerRadius(12)
    }
}

struct HobbyTimeBar: View {
    let hobbyName: String
    let time: TimeInterval
    let totalTime: TimeInterval
    let color: Color
    
    var percentage: Double {
        guard totalTime > 0 else { return 0 }
        return time / totalTime
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(hobbyName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(formatTime(time))
                    .font(.subheadline)
                    .foregroundColor(.hobbyLabSecondaryText)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(color.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * percentage, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
        .padding(.vertical, 4)
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

struct HobbyAnalyticsCard: View {
    let hobby: Hobby
    let timeInRange: TimeInterval
    let sessionsInRange: Int
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(hex: hobby.color).opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: hobby.icon)
                    .foregroundColor(Color(hex: hobby.color))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(hobby.name)
                    .font(.headline)
                
                HStack(spacing: 16) {
                    Label(formatTime(timeInRange), systemImage: "clock.fill")
                        .font(.caption)
                        .foregroundColor(.hobbyLabSecondaryText)
                    
                    Label("\(sessionsInRange) sessions", systemImage: "calendar")
                        .font(.caption)
                        .foregroundColor(.hobbyLabSecondaryText)
                }
            }
            
            Spacer()
        }
        .padding()
        .cardStyle()
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

#Preview {
    AnalyticsView()
        .environmentObject(HobbyViewModel())
}
