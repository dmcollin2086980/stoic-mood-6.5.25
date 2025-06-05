import SwiftUI

/// A view that displays and manages journal entries.
/// This view provides functionality for viewing, filtering, and exporting journal entries.
struct JournalView: View {
    // MARK: - Properties
    
    /// The environment object that provides theme-related functionality
    @EnvironmentObject var themeManager: ThemeManager
    
    /// The state object that manages journal entries
    @StateObject private var journalManager = JournalManager.shared
    
    /// The search text used to filter journal entries
    @State private var searchText = ""
    
    /// The currently selected filter for journal entries
    @State private var selectedFilter: JournalFilter = .all
    
    /// A boolean indicating whether the journal flow sheet is presented
    @State private var showingJournalSheet = false
    
    /// The current step in the journal entry flow
    @State private var flowStep: JournalFlowStep = .moodSelection
    
    /// The selected mood and intensity for the new entry
    @State private var selectedMood: Mood?
    @State private var selectedIntensity: Double?
    
    /// A boolean indicating whether the export options view is presented
    @State private var showingExportOptions = false
    
    // MARK: - Computed Properties
    
    /// Returns the filtered journal entries based on search text and selected filter
    private var filteredEntries: [JournalEntry] {
        journalManager.entries.filter { entry in
            let matchesSearch = searchText.isEmpty || 
                entry.content.localizedCaseInsensitiveContains(searchText)
            
            let matchesFilter = matchesFilterCriteria(entry)
            
            return matchesSearch && matchesFilter
        }
    }
    
    private func matchesFilterCriteria(_ entry: JournalEntry) -> Bool {
        switch selectedFilter {
        case .all:
            return true
        case .thisWeek:
            return Calendar.current.isDate(entry.date, equalTo: Date(), toGranularity: .weekOfYear)
        case .thisMonth:
            return Calendar.current.isDate(entry.date, equalTo: Date(), toGranularity: .month)
        case .thisYear:
            return Calendar.current.isDate(entry.date, equalTo: Date(), toGranularity: .year)
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.backgroundColor.ignoresSafeArea()
                
                VStack(spacing: themeManager.spacing) {
                    // Search bar
                    SearchBar(text: $searchText)
                        .padding(.horizontal)
                    
                    // Filter buttons
                    HStack(spacing: themeManager.spacing) {
                        ForEach(JournalFilter.allCases, id: \.self) { filter in
                            FilterButton(
                                title: filter.title,
                                isSelected: selectedFilter == filter,
                                action: { selectedFilter = filter }
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Journal entries list
                    ScrollView {
                        LazyVStack(spacing: themeManager.spacing) {
                            ForEach(filteredEntries) { entry in
                                JournalEntryCard(entry: entry)
                            }
                        }
                        .padding()
                    }
                }
                
                // Floating Action Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { 
                            flowStep = .moodSelection
                            showingJournalSheet = true 
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(themeManager.accentColor)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                        .padding()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingExportOptions = true }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            .sheet(isPresented: $showingJournalSheet) {
                Group {
                    switch flowStep {
                    case .moodSelection:
                        MoodSelectionView { mood, intensity in
                            selectedMood = mood.toMood
                            selectedIntensity = Double(intensity) / 10.0
                            flowStep = .journalEntry
                        }
                    case .journalEntry:
                        if let mood = selectedMood, let intensity = selectedIntensity {
                            JournalEntryView(mood: mood, intensity: intensity) { content in
                                journalManager.addEntry(mood: mood, intensity: intensity, content: content)
                                selectedMood = nil
                                selectedIntensity = nil
                                showingJournalSheet = false
                            }
                        }
                    }
                }
                .presentationDetents([.large])
            }
            .sheet(isPresented: $showingExportOptions) {
                ExportOptionsView()
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
    }
}

/// The steps in the journal entry flow
enum JournalFlowStep {
    case moodSelection
    case journalEntry
}

/// A button used for filtering journal entries
struct FilterButton: View {
    /// The title text displayed on the button
    let title: String
    
    /// A boolean indicating whether the button is selected
    let isSelected: Bool
    
    /// The action to perform when the button is tapped
    let action: () -> Void
    
    /// The environment object that provides theme-related functionality
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, themeManager.padding)
                .padding(.vertical, themeManager.spacing)
                .background(isSelected ? themeManager.accentColor : themeManager.cardBackgroundColor)
                .foregroundColor(isSelected ? .white : themeManager.textColor)
                .cornerRadius(ThemeManager.cornerRadius)
        }
    }
}

/// A card view that displays a single journal entry
struct JournalEntryCard: View {
    /// The journal entry to display
    let entry: JournalEntry
    
    /// The environment object that provides theme-related functionality
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: themeManager.spacing) {
            HStack {
                Text(entry.mood.emoji)
                    .font(.title)
                Text(entry.mood.rawValue)
                    .font(.headline)
                Spacer()
                Text(entry.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            
            Text(entry.content)
                .font(.body)
                .foregroundColor(themeManager.textColor)
            
            HStack {
                Text("Intensity: \(Int(entry.intensity * 100))%")
                    .font(.caption)
                    .foregroundColor(themeManager.secondaryTextColor)
                Spacer()
                Text("\(entry.wordCount) words")
                    .font(.caption)
                    .foregroundColor(themeManager.secondaryTextColor)
            }
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(ThemeManager.cornerRadius)
    }
}

/// A view that provides options for exporting journal entries
struct ExportOptionsView: View {
    /// The environment object that provides theme-related functionality
    @EnvironmentObject var themeManager: ThemeManager
    
    /// The state object that manages journal entries
    @StateObject private var journalManager = JournalManager.shared
    
    /// A boolean indicating whether the view is presented
    @Environment(\.dismiss) private var dismiss
    
    /// State variables for export process
    @State private var isExporting = false
    @State private var showingShareSheet = false
    @State private var exportURL: URL?
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button(action: exportPDF) {
                        HStack {
                            Image(systemName: "doc.fill")
                            Text("Export as PDF")
                        }
                    }
                    .disabled(isExporting)
                    
                    Button(action: exportCSV) {
                        HStack {
                            Image(systemName: "tablecells")
                            Text("Export as CSV")
                        }
                    }
                    .disabled(isExporting)
                }
            }
            .navigationTitle("Export Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .overlay {
                if isExporting {
                    ProgressView("Exporting...")
                        .padding()
                        .background(themeManager.cardBackgroundColor)
                        .cornerRadius(ThemeManager.cornerRadius)
                }
            }
            .alert("Export Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .sheet(isPresented: $showingShareSheet) {
                if let url = exportURL {
                    ShareSheet(activityItems: [url])
                }
            }
        }
    }
    
    private func exportPDF() {
        guard !journalManager.entries.isEmpty else {
            errorMessage = "No entries to export"
            showingError = true
            return
        }
        
        isExporting = true
        
        ExportManager.shared.exportToPDF(entries: journalManager.entries) { result in
            isExporting = false
            
            switch result {
            case .success(let url):
                exportURL = url
                showingShareSheet = true
            case .failure(let error):
                errorMessage = error.localizedDescription
                showingError = true
            }
        }
    }
    
    private func exportCSV() {
        guard !journalManager.entries.isEmpty else {
            errorMessage = "No entries to export"
            showingError = true
            return
        }
        
        isExporting = true
        
        ExportManager.shared.exportToCSV(entries: journalManager.entries) { result in
            isExporting = false
            
            switch result {
            case .success(let url):
                exportURL = url
                showingShareSheet = true
            case .failure(let error):
                errorMessage = error.localizedDescription
                showingError = true
            }
        }
    }
}

#Preview {
    JournalView()
        .environmentObject(ThemeManager())
} 
