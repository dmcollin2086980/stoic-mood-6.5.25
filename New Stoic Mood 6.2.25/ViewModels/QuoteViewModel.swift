import Foundation
import SwiftUI

struct StoicQuote: Identifiable, Codable {
    var id: UUID
    let text: String
    let author: String
    
    init(id: UUID = UUID(), text: String, author: String) {
        self.id = id
        self.text = text
        self.author = author
    }
}

class QuoteViewModel: ObservableObject {
    @Published var quotes: [StoicQuote] = []
    @Published var dailyQuote: StoicQuote
    @Published var savedQuotes: [StoicQuote] = []
    @Published var isShareSheetPresented = false
    @Published var shareText: String = ""
    
    private let userDefaults = UserDefaults.standard
    private let dailyQuoteKey = "lastDailyQuoteDate"
    private let savedQuotesKey = "savedQuotes"
    
    init() {
        // Initialize with a default quote
        let defaultQuote = StoicQuote(text: "The happiness of your life depends upon the quality of your thoughts.", author: "Marcus Aurelius")
        self.dailyQuote = defaultQuote
        
        // Load saved quotes
        if let savedData = userDefaults.data(forKey: savedQuotesKey),
           let decodedQuotes = try? JSONDecoder().decode([StoicQuote].self, from: savedData) {
            self.savedQuotes = decodedQuotes
        }
        
        // Load quotes
        self.quotes = [
            StoicQuote(text: "The happiness of your life depends upon the quality of your thoughts.", author: "Marcus Aurelius"),
            StoicQuote(text: "Waste no more time arguing what a good man should be. Be one.", author: "Marcus Aurelius"),
            StoicQuote(text: "You have power over your mind - not outside events. Realize this, and you will find strength.", author: "Marcus Aurelius"),
            StoicQuote(text: "The best revenge is to be unlike him who performed the injury.", author: "Marcus Aurelius"),
            StoicQuote(text: "If it is not right, do not do it, if it is not true, do not say it.", author: "Marcus Aurelius"),
            StoicQuote(text: "He who fears death will never do anything worthy of a living man.", author: "Seneca"),
            StoicQuote(text: "We suffer more often in imagination than in reality.", author: "Seneca"),
            StoicQuote(text: "It is not that we have a short time to live, but that we waste a lot of it.", author: "Seneca"),
            StoicQuote(text: "Luck is what happens when preparation meets opportunity.", author: "Seneca"),
            StoicQuote(text: "The whole future lies in uncertainty: live immediately.", author: "Seneca")
        ]
        
        // Set up daily quote
        if let lastDate = userDefaults.string(forKey: dailyQuoteKey),
           let lastDateObj = ISO8601DateFormatter().date(from: lastDate),
           Calendar.current.isDateInToday(lastDateObj) {
            // Use existing daily quote
            self.dailyQuote = self.quotes[0] // Default to first quote if no daily quote set
        } else {
            // Set new daily quote
            self.dailyQuote = self.quotes.randomElement() ?? self.quotes[0]
            userDefaults.set(ISO8601DateFormatter().string(from: Date()), forKey: dailyQuoteKey)
        }
    }
    
    func refreshQuotes() {
        // In a real app, this would fetch new quotes from an API
        loadQuotes()
    }
    
    private func loadQuotes() {
        quotes = [
            StoicQuote(text: "The happiness of your life depends upon the quality of your thoughts.", author: "Marcus Aurelius"),
            StoicQuote(text: "Waste no more time arguing what a good man should be. Be one.", author: "Marcus Aurelius"),
            StoicQuote(text: "You have power over your mind - not outside events. Realize this, and you will find strength.", author: "Marcus Aurelius"),
            StoicQuote(text: "The best revenge is to be unlike him who performed the injury.", author: "Marcus Aurelius"),
            StoicQuote(text: "If it is not right, do not do it, if it is not true, do not say it.", author: "Marcus Aurelius"),
            StoicQuote(text: "He who fears death will never do anything worthy of a living man.", author: "Seneca"),
            StoicQuote(text: "We suffer more often in imagination than in reality.", author: "Seneca"),
            StoicQuote(text: "It is not that we have a short time to live, but that we waste a lot of it.", author: "Seneca"),
            StoicQuote(text: "Luck is what happens when preparation meets opportunity.", author: "Seneca"),
            StoicQuote(text: "The whole future lies in uncertainty: live immediately.", author: "Seneca")
        ]
    }
    
    func refreshDailyQuote() {
        dailyQuote = quotes.randomElement() ?? quotes[0]
        userDefaults.set(ISO8601DateFormatter().string(from: Date()), forKey: dailyQuoteKey)
    }
    
    func saveQuote(_ quote: StoicQuote) {
        if !savedQuotes.contains(where: { $0.id == quote.id }) {
            savedQuotes.append(quote)
            saveQuotes()
        }
    }
    
    func removeSavedQuote(_ quote: StoicQuote) {
        savedQuotes.removeAll { $0.id == quote.id }
        saveQuotes()
    }
    
    public func saveQuotes() {
        if let encoded = try? JSONEncoder().encode(savedQuotes) {
            userDefaults.set(encoded, forKey: savedQuotesKey)
        }
    }
    
    func shareQuote(_ quote: StoicQuote) {
        shareText = "\"\(quote.text)\""
        isShareSheetPresented = true
    }
    
    func copyQuote(_ quote: StoicQuote) {
        let text = "\"\(quote.text)\""
        #if os(iOS)
        UIPasteboard.general.string = text
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        #endif
    }
    
    public func clearAll() {
        savedQuotes.removeAll()
        saveQuotes()
    }
} 
