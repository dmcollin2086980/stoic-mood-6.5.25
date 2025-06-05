#if DEBUG
import Foundation
import SwiftUI

class ExampleDataManager: ObservableObject {
    static let shared = ExampleDataManager()
    @Published var progress: Double = 0.0
    @Published var isPopulating: Bool = false
    @Published var lastError: String?
    
    private let exampleDataFlag = "ExampleDataPopulated"
    private let moods = ["😊","😔","😤","🥰","😰","😌","🤔","😴","🥳","😑","😍","😢","🙄","😎","🤗","😭"]
    private let moodDescriptions = [
        "Grateful for the small things today.",
        "Faced a challenge but tried to remain calm.",
        "Practiced acceptance of what I cannot control.",
        "Focused on the present moment.",
        "Reminded myself to let go of anger.",
        "Took time for self-reflection.",
        "Applied the dichotomy of control.",
        "Felt joy in simple routines.",
        "Struggled with patience but improved.",
        "Found peace in nature.",
        "Practiced memento mori meditation.",
        "Wrote about gratitude and virtue.",
        "Learned from a setback.",
        "Helped someone in need.",
        "Focused on discipline of desire."
    ]
    private let reflectionPrompts = [
        "What am I grateful for today?",
        "How did I practice virtue?",
        "What would Marcus Aurelius do?",
        "How can I be more present?",
        "What challenge did I face and how did I respond?",
        "How did I apply Stoic principles today?",
        "What can I let go of?",
        "How did I show resilience?",
        "What lesson did I learn from adversity?",
        "How did I practice acceptance?",
        "What did I do for others today?",
        "How did I manage my emotions?",
        "What would I do differently tomorrow?",
        "How did I cultivate gratitude?",
        "How did I respond to stress?"
    ]
    private let exercisePrompts = [
        "Morning reflection: Set your intention for the day.",
        "Evening review: What did you do well?",
        "Memento mori meditation: Reflect on impermanence.",
        "Practice the discipline of desire.",
        "Virtue practice: Focus on courage.",
        "Perception exercise: Reframe a negative event.",
        "Journaling: Write about a challenge.",
        "Gratitude list: Name three things.",
        "Discipline of action: Take a small risk.",
        "Practice acceptance: Let go of what you can't control."
    ]
    private let stoicQuotes: [(String, String)] = [
        ("You have power over your mind - not outside events. Realize this, and you will find strength.", "Marcus Aurelius"),
        ("We suffer more often in imagination than in reality.", "Seneca"),
        ("It's not what happens to you, but how you react to it that matters.", "Epictetus"),
        ("He who angers you conquers you.", "Elizabeth Kenny"),
        ("The best revenge is to be unlike him who performed the injury.", "Marcus Aurelius"),
        ("If it is not right, do not do it; if it is not true, do not say it.", "Marcus Aurelius"),
        ("Difficulties strengthen the mind, as labor does the body.", "Seneca"),
        ("No man is free who is not master of himself.", "Epictetus"),
        ("How long are you going to wait before you demand the best for yourself?", "Epictetus"),
        ("He suffers more than necessary, who suffers before it is necessary.", "Seneca"),
        ("The happiness of your life depends upon the quality of your thoughts.", "Marcus Aurelius"),
        ("Wealth consists not in having great possessions, but in having few wants.", "Epictetus"),
        ("To enjoy the things we ought and to hate the things we ought has the greatest bearing on excellence of character.", "Aristotle"),
        ("First say to yourself what you would be; and then do what you have to do.", "Epictetus"),
        ("Don't explain your philosophy. Embody it.", "Epictetus"),
        ("Luck is what happens when preparation meets opportunity.", "Seneca"),
        ("He who fears death will never do anything worth of a man who is alive.", "Seneca"),
        ("The soul becomes dyed with the color of its thoughts.", "Marcus Aurelius"),
        ("If you want to improve, be content to be thought foolish and stupid.", "Epictetus"),
        ("Sometimes even to live is an act of courage.", "Seneca"),
        ("Waste no more time arguing what a good man should be. Be one.", "Marcus Aurelius"),
        ("Man conquers the world by conquering himself.", "Zeno of Citium"),
        ("No great thing is created suddenly.", "Epictetus"),
        ("Begin at once to live, and count each separate day as a separate life.", "Seneca"),
        ("The greater the difficulty, the more glory in surmounting it.", "Epicurus"),
        ("Be tolerant with others and strict with yourself.", "Marcus Aurelius"),
        ("Attach yourself to what is spiritually superior.", "Epictetus"),
        ("The only thing in our power is our own thoughts.", "Epictetus")
    ]

    // MARK: - Public API

    func populateAllExampleData(
        moodVM: MoodViewModel,
        reflectionVM: ReflectionViewModel,
        exerciseVM: ExerciseViewModel,
        quoteVM: QuoteViewModel,
        completion: @escaping () -> Void
    ) {
        guard !isExampleDataPresent() else {
            print("Example data already populated")
            completion()
            return
        }
        
        print("Starting data population...")
        isPopulating = true
        progress = 0.0
        lastError = nil
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            // Clear existing data first
            DispatchQueue.main.async {
                moodVM.clearAll()
                reflectionVM.clearAll()
                exerciseVM.clearAll()
                quoteVM.clearAll()
            }
            
            // Generate data
            self.generateMoodEntries(moodVM: moodVM)
            self.generateReflections(reflectionVM: reflectionVM)
            self.generateExercises(exerciseVM: exerciseVM)
            self.generateSavedQuotes(quoteVM: quoteVM)
            
            // Save completion state
            UserDefaults.standard.set(true, forKey: self.exampleDataFlag)
            
            // Verify data population
            DispatchQueue.main.async {
                print("Data population completed")
                print("Mood entries: \(moodVM.entries.count)")
                print("Reflections: \(reflectionVM.reflections.count)")
                print("Exercises: \(exerciseVM.exercises.count)")
                print("Saved quotes: \(quoteVM.savedQuotes.count)")
                
                self.isPopulating = false
                self.progress = 1.0
                completion()
            }
        }
    }

    func clearAllExampleData(
        moodVM: MoodViewModel,
        reflectionVM: ReflectionViewModel,
        exerciseVM: ExerciseViewModel,
        quoteVM: QuoteViewModel
    ) {
        moodVM.clearAll()
        reflectionVM.clearAll()
        exerciseVM.clearAll()
        quoteVM.clearAll()
        UserDefaults.standard.set(false, forKey: exampleDataFlag)
    }

    // MARK: - Example Data Generation

    private func generateMoodEntries(moodVM: MoodViewModel) {
        print("Generating mood entries...")
        let totalDays = 493
        let startDate = Calendar.current.date(byAdding: .day, value: -totalDays, to: Date())!
        
        for i in 0..<totalDays {
            let date = Calendar.current.date(byAdding: .day, value: i, to: startDate)!
            let season = Calendar.current.component(.month, from: date)
            let baseMood = (season >= 3 && season <= 8) ? 7 : 5
            let intensity = weightedRandomIntensity(base: baseMood)
            let mood = moods.randomElement()!
            let journal = generateJournalEntry(for: date, mood: mood, intensity: intensity)
            
            DispatchQueue.main.async {
                moodVM.addEntry(date: date, mood: mood, intensity: intensity, journal: journal)
                self.progress = Double(i) / Double(totalDays) * 0.25
            }
        }
        print("Generated \(totalDays) mood entries")
    }

    private func generateReflections(reflectionVM: ReflectionViewModel) {
        print("Generating reflections...")
        let total = 150
        let startDate = Calendar.current.date(byAdding: .day, value: -493, to: Date())!
        
        for i in 0..<total {
            let daysOffset = Int.random(in: 0..<493)
            let date = Calendar.current.date(byAdding: .day, value: daysOffset, to: startDate)!
            let prompt = reflectionPrompts.randomElement()!
            let response = generateReflectionResponse(for: prompt)
            
            DispatchQueue.main.async {
                reflectionVM.addReflection(date: date, prompt: prompt, response: response)
                self.progress = 0.25 + Double(i) / Double(total) * 0.25
            }
        }
        print("Generated \(total) reflections")
    }

    private func generateExercises(exerciseVM: ExerciseViewModel) {
        print("Generating exercises...")
        let total = 120
        let startDate = Calendar.current.date(byAdding: .day, value: -493, to: Date())!
        
        for i in 0..<total {
            let daysOffset = Int.random(in: 0..<493)
            let date = Calendar.current.date(byAdding: .day, value: daysOffset, to: startDate)!
            let prompt = exercisePrompts.randomElement()!
            let response = generateExerciseResponse(for: prompt, day: i)
            
            DispatchQueue.main.async {
                exerciseVM.addExercise(date: date, prompt: prompt, response: response)
                self.progress = 0.5 + Double(i) / Double(total) * 0.25
            }
        }
        print("Generated \(total) exercises")
    }

    private func generateSavedQuotes(quoteVM: QuoteViewModel) {
        print("Generating saved quotes...")
        let quotesToSave = stoicQuotes.shuffled().prefix(28)
        
        for (text, author) in quotesToSave {
            let quote = StoicQuote(id: UUID(), text: text, author: author)
            DispatchQueue.main.async {
                quoteVM.saveQuote(quote)
                self.progress = 0.75 + Double(quoteVM.savedQuotes.count) / Double(quotesToSave.count) * 0.25
            }
        }
        print("Generated \(quotesToSave.count) saved quotes")
    }

    // MARK: - Helpers

    private func isExampleDataPresent() -> Bool {
        return UserDefaults.standard.bool(forKey: exampleDataFlag)
    }

    private func weightedRandomIntensity(base: Int) -> Int {
        // More likely to be 5-7, less likely to be 1-2 or 9-10
        let weights = [1:2, 2:3, 3:5, 4:8, 5:15, 6:20, 7:18, 8:10, 9:4, 10:2]
        let totalWeight = weights.values.reduce(0, +)
        let rand = Int.random(in: 1...totalWeight)
        var sum = 0
        for (value, weight) in weights.sorted(by: { $0.key < $1.key }) {
            sum += weight
            if rand <= sum { return value }
        }
        return base
    }

    private func generateJournalEntry(for date: Date, mood: String, intensity: Int) -> String {
        // Generate a 150-400 word entry with Stoic themes, gratitude, challenges, and growth
        let themes = [
            "Today I reflected on the importance of gratitude and how it shapes my perspective.",
            "I faced a challenge that tested my patience, but I tried to respond with calm and reason.",
            "I practiced the dichotomy of control, letting go of what I cannot change.",
            "I found joy in simple routines and took time to appreciate the present moment.",
            "I reminded myself of memento mori, cherishing each day as a gift.",
            "I wrote about a setback and how I can learn from it, rather than dwell on frustration.",
            "I helped someone in need and felt a sense of connection and purpose.",
            "I focused on the discipline of desire, resisting impulses and choosing what is best."
        ]
        let seasonal = Calendar.current.component(.month, from: date)
        let seasonText: String
        switch seasonal {
        case 3...5: seasonText = "Spring brought a sense of renewal and hope."
        case 6...8: seasonText = "Summer's warmth lifted my spirits and encouraged outdoor reflection."
        case 9...11: seasonText = "Autumn reminded me of impermanence and the beauty of change."
        default: seasonText = "Winter was a time for introspection and building resilience."
        }
        let moodText = moodDescriptions.randomElement()!
        let challenge = [
            "I struggled with motivation but reminded myself to focus on progress, not perfection.",
            "There were moments of doubt, but I practiced self-compassion.",
            "I faced a difficult conversation and tried to listen with empathy.",
            "I felt stress about work, but used Stoic exercises to regain perspective."
        ].randomElement()!
        let growth = [
            "I see growth in my ability to respond rather than react.",
            "I am learning to accept setbacks as opportunities for learning.",
            "My gratitude practice is deepening my appreciation for life.",
            "I am more present and less distracted by worries about the future."
        ].randomElement()!
        let wordCount = Int.random(in: 150...400)
        let base = [seasonText, moodText, themes.randomElement()!, challenge, growth]
        var entry = base.joined(separator: " ")
        while entry.split(separator: " ").count < wordCount {
            entry += " " + [themes.randomElement()!, challenge, growth].randomElement()!
        }
        return String(entry.prefix(wordCount * 6)) // crude word limit
    }

    private func generateReflectionResponse(for prompt: String) -> String {
        let responses = [
            "Today I am grateful for the support of my friends and family. Their presence reminds me that I am not alone in facing life's challenges.",
            "I practiced virtue by choosing honesty in a difficult situation, even though it was uncomfortable.",
            "If Marcus Aurelius were in my position, he would remind me to focus on what I can control and let go of the rest.",
            "I was more present by putting away distractions and truly listening during conversations.",
            "A challenge I faced was feeling overwhelmed at work, but I responded by breaking tasks into smaller steps and taking breaks to breathe.",
            "I applied Stoic principles by accepting a change I could not influence and redirecting my energy to what I could improve.",
            "I let go of resentment by reminding myself that holding onto anger only harms me.",
            "I showed resilience by bouncing back from a setback and trying again the next day.",
            "Adversity taught me patience and the value of persistence.",
            "I practiced acceptance by acknowledging my feelings without judgment.",
            "I did something kind for someone else, which lifted my mood and theirs.",
            "I managed my emotions by pausing before reacting and considering the bigger picture.",
            "Tomorrow, I will approach challenges with curiosity rather than fear.",
            "Gratitude helped me see the good even in a difficult day.",
            "I responded to stress by taking a walk and reflecting on what truly matters."
        ]
        let base = responses.randomElement()!
        let extra = [
            "This practice is helping me grow in self-awareness and emotional regulation.",
            "I see progress in my ability to remain calm under pressure.",
            "Each day, I am learning to live more in accordance with nature and reason.",
            "Reflecting regularly is deepening my understanding of Stoic philosophy."
        ].randomElement()!
        return base + " " + extra
    }

    private func generateExerciseResponse(for prompt: String, day: Int) -> String {
        let base = [
            "This exercise challenged me to think differently about my day.",
            "I found value in reflecting on my actions and intentions.",
            "Practicing memento mori helped me appreciate the present.",
            "Focusing on virtue made me more mindful of my choices.",
            "Reframing a negative event allowed me to see a hidden benefit.",
            "Writing about a challenge gave me clarity and perspective.",
            "Listing things I am grateful for improved my mood.",
            "Taking a small risk today helped me grow in confidence.",
            "Letting go of what I can't control brought me peace."
        ].randomElement()!
        let progression = day < 40 ? "I am just beginning to understand these practices." : day < 80 ? "I notice I am becoming more consistent and thoughtful." : "I feel a deeper sense of growth and resilience over time."
        let detail = [
            "I wrote about my experiences and how I can apply these lessons tomorrow.",
            "This practice is helping me become more aware of my thoughts and actions.",
            "I am learning to accept setbacks as part of the journey.",
            "Each exercise builds on the last, and I see real progress."
        ].randomElement()!
        return base + " " + progression + " " + detail
    }
} 
#endif 