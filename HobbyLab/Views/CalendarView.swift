import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var viewModel: HobbyViewModel
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Month Selector
                    monthSelector
                    
                    // Calendar Grid
                    calendarGrid
                    
                    // Sessions for Selected Date
                    sessionsForDay
                }
                .padding()
            }
            .background(Color.hobbyLabSecondaryBackground)
            .navigationTitle("Calendar")
        }
    }
    
    private var monthSelector: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.hobbyLabPrimary)
                    .font(.title3)
            }
            
            Spacer()
            
            Text(monthYearString)
                .font(.headline)
            
            Spacer()
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.hobbyLabPrimary)
                    .font(.title3)
            }
        }
        .padding()
        .cardStyle()
    }
    
    private var calendarGrid: some View {
        VStack(spacing: 12) {
            // Weekday Headers
            HStack(spacing: 0) {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.hobbyLabSecondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Calendar Days
            let days = getDaysInMonth()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(days, id: \.self) { date in
                    if let date = date {
                        DayCell(
                            date: date,
                            isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                            isToday: Calendar.current.isDateInToday(date),
                            sessionCount: getSessionCount(for: date),
                            onTap: { selectedDate = date }
                        )
                    } else {
                        Color.clear
                            .frame(height: 44)
                    }
                }
            }
        }
        .padding()
        .cardStyle()
    }
    
    private var sessionsForDay: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(selectedDateString)
                .font(.headline)
            
            let sessions = getSessionsForDate(selectedDate)
            
            if sessions.isEmpty {
                EmptyStateView(
                    icon: "calendar.badge.clock",
                    title: "No sessions on this day",
                    message: "Select another date or log a new session"
                )
            } else {
                VStack(spacing: 12) {
                    ForEach(sessions) { session in
                        CalendarSessionRow(session: session, hobbyName: getHobbyName(for: session.hobbyId))
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private var selectedDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: selectedDate)
    }
    
    private func previousMonth() {
        if let newMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    private func nextMonth() {
        if let newMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    private func getDaysInMonth() -> [Date?] {
        let calendar = Calendar.current
        let interval = calendar.dateInterval(of: .month, for: currentMonth)!
        let firstWeekday = calendar.component(.weekday, from: interval.start)
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        
        var date = interval.start
        while date < interval.end {
            days.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        
        return days
    }
    
    private func getSessionCount(for date: Date) -> Int {
        let calendar = Calendar.current
        var count = 0
        
        for hobby in viewModel.hobbies {
            let sessions = viewModel.getAllSessions(for: hobby.id)
            count += sessions.filter { calendar.isDate($0.date, inSameDayAs: date) }.count
        }
        
        return count
    }
    
    private func getSessionsForDate(_ date: Date) -> [Session] {
        let calendar = Calendar.current
        var sessions: [Session] = []
        
        for hobby in viewModel.hobbies {
            let hobbySessions = viewModel.getAllSessions(for: hobby.id)
            let filtered = hobbySessions.filter { calendar.isDate($0.date, inSameDayAs: date) }
            sessions.append(contentsOf: filtered)
        }
        
        return sessions.sorted { $0.date > $1.date }
    }
    
    private func getHobbyName(for hobbyId: UUID) -> String {
        viewModel.hobbies.first { $0.id == hobbyId }?.name ?? "Unknown"
    }
}

// MARK: - Supporting Views

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let sessionCount: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.subheadline)
                    .fontWeight(isToday ? .bold : .regular)
                    .foregroundColor(isSelected ? .white : (isToday ? .hobbyLabPrimary : .hobbyLabText))
                
                if sessionCount > 0 {
                    Circle()
                        .fill(isSelected ? .white : .hobbyLabPrimary)
                        .frame(width: 4, height: 4)
                }
            }
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.hobbyLabPrimary : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isToday && !isSelected ? Color.hobbyLabPrimary : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CalendarSessionRow: View {
    let session: Session
    let hobbyName: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(hobbyName)
                    .font(.headline)
                
                Text(session.formattedDuration)
                    .font(.subheadline)
                    .foregroundColor(.hobbyLabSecondaryText)
                
                if !session.notes.isEmpty {
                    Text(session.notes)
                        .font(.caption)
                        .foregroundColor(.hobbyLabSecondaryText)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Text("+\(session.xpEarned) XP")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.hobbyLabPrimary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.hobbyLabPrimary.opacity(0.1))
                .cornerRadius(8)
        }
        .padding()
        .cardStyle()
    }
}

#Preview {
    CalendarView()
        .environmentObject(HobbyViewModel())
}
