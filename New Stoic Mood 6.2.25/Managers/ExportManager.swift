import Foundation
import PDFKit
import SwiftUI

class ExportManager {
    static let shared = ExportManager()
    private init() {}
    
    // MARK: - PDF Export
    
    func exportToPDF(entries: [JournalEntry], completion: @escaping (Result<URL, Error>) -> Void) {
        let pdfMetaData = [
            kCGPDFContextCreator: "Stoic Mood",
            kCGPDFContextAuthor: "Stoic Mood App",
            kCGPDFContextTitle: "Journal Entries"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        do {
            let tempDir = FileManager.default.temporaryDirectory
            let fileName = "journal_entries_\(Date().timeIntervalSince1970).pdf"
            let fileURL = tempDir.appendingPathComponent(fileName)
            
            try renderer.writePDF(to: fileURL) { context in
                context.beginPage()
                
                let titleFont = UIFont.boldSystemFont(ofSize: 24.0)
                let titleAttributes: [NSAttributedString.Key: Any] = [
                    .font: titleFont,
                    .foregroundColor: UIColor.black
                ]
                
                let dateFont = UIFont.systemFont(ofSize: 12.0)
                let dateAttributes: [NSAttributedString.Key: Any] = [
                    .font: dateFont,
                    .foregroundColor: UIColor.darkGray
                ]
                
                let contentFont = UIFont.systemFont(ofSize: 14.0)
                let contentAttributes: [NSAttributedString.Key: Any] = [
                    .font: contentFont,
                    .foregroundColor: UIColor.black
                ]
                
                var yPosition: CGFloat = 50.0
                
                // Title
                let title = "Journal Entries"
                title.draw(at: CGPoint(x: 50, y: yPosition), withAttributes: titleAttributes)
                yPosition += 40
                
                // Entries
                for entry in entries {
                    // Date
                    let dateString = entry.date.formatted(date: .long, time: .shortened)
                    dateString.draw(at: CGPoint(x: 50, y: yPosition), withAttributes: dateAttributes)
                    yPosition += 20
                    
                    // Mood and Intensity
                    let moodString = "Mood: \(entry.mood.rawValue) (\(entry.mood.emoji)) - Intensity: \(Int(entry.intensity * 100))%"
                    moodString.draw(at: CGPoint(x: 50, y: yPosition), withAttributes: contentAttributes)
                    yPosition += 25
                    
                    // Content
                    let contentString = entry.content
                    let contentRect = CGRect(x: 50, y: yPosition, width: pageWidth - 100, height: pageHeight - yPosition - 50)
                    contentString.draw(in: contentRect, withAttributes: contentAttributes)
                    
                    // Check if we need a new page
                    if yPosition > pageHeight - 100 {
                        context.beginPage()
                        yPosition = 50
                    } else {
                        yPosition += 200 // Approximate space for content
                    }
                }
            }
            
            completion(.success(fileURL))
        } catch {
            completion(.failure(error))
        }
    }
    
    // MARK: - CSV Export
    
    func exportToCSV(entries: [JournalEntry], completion: @escaping (Result<URL, Error>) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        var csvString = "Date,Mood,Intensity,Content,Word Count\n"
        
        for entry in entries {
            let date = dateFormatter.string(from: entry.date)
            let mood = entry.mood.rawValue
            let intensity = String(format: "%.0f%%", entry.intensity * 100)
            let content = entry.content.replacingOccurrences(of: "\"", with: "\"\"")
            let wordCount = entry.wordCount
            
            let row = "\"\(date)\",\"\(mood)\",\"\(intensity)\",\"\(content)\",\"\(wordCount)\"\n"
            csvString.append(row)
        }
        
        do {
            let tempDir = FileManager.default.temporaryDirectory
            let fileName = "journal_entries_\(Date().timeIntervalSince1970).csv"
            let fileURL = tempDir.appendingPathComponent(fileName)
            
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            completion(.success(fileURL))
        } catch {
            completion(.failure(error))
        }
    }
}

