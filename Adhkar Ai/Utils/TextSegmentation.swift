import Foundation

enum ArabicSegmentType {
    case bismillah
    case ayah
}

struct ArabicSegment: Identifiable {
    let id = UUID()
    let type: ArabicSegmentType
    let content: String
    let number: String?
}

struct ArabicTextProcessor {
    static func segment(text: String) -> (bismillah: String?, ayahs: [ArabicSegment]) {
        // Updated regex to catch slight variations in diacritics as per PWA fallback logic
        let bismillahRegex = try! NSRegularExpression(pattern: "^(بِسْمِ\\s+اللَّهِ\\s+الرَّحْمَنِ\\s+الرَّحِيمِ[\\.\\s]*)", options: [])
        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        
        var bismillah: String? = nil
        var remainingText = text
        
        if let match = bismillahRegex.firstMatch(in: text, options: [], range: range) {
            let bismillahRange = Range(match.range(at: 1), in: text)!
            bismillah = String(text[bismillahRange]).trimmingCharacters(in: .whitespacesAndNewlines)
            remainingText = String(text[bismillahRange.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // Regex to find Ayah markers like (١), (٢), etc.
        let ayahMarkerRegex = try! NSRegularExpression(pattern: "(\\([\\u0660-\\u0669\\d]+\\))", options: [])
        let remainingRange = NSRange(remainingText.startIndex..<remainingText.endIndex, in: remainingText)
        
        var segments: [ArabicSegment] = []
        let matches = ayahMarkerRegex.matches(in: remainingText, options: [], range: remainingRange)
        
        var lastIndex = remainingText.startIndex
        
        if matches.isEmpty {
            // No ayah markers, treat whole thing as one segment
            if !remainingText.isEmpty {
                segments.append(ArabicSegment(type: .ayah, content: remainingText, number: nil))
            }
        } else {
            for match in matches {
                let markerRange = Range(match.range(at: 1), in: remainingText)!
                let marker = String(remainingText[markerRange])
                
                // Text before the marker
                let contentRange = lastIndex..<markerRange.lowerBound
                let content = String(remainingText[contentRange]).trimmingCharacters(in: .whitespacesAndNewlines)
                
                if !content.isEmpty {
                    segments.append(ArabicSegment(type: .ayah, content: content, number: marker))
                } else if !segments.isEmpty {
                    // This marker applies to the previous segment if it was empty (though unlikely with trim)
                    // Or if we just started, we wait for the next text.
                } else {
                    // Opening marker with no preceding text? Just add placeholder
                    segments.append(ArabicSegment(type: .ayah, content: "", number: marker))
                }
                
                lastIndex = markerRange.upperBound
            }
            
            // Any trailing text?
            if lastIndex < remainingText.endIndex {
                let trailing = String(remainingText[lastIndex...]).trimmingCharacters(in: .whitespacesAndNewlines)
                if !trailing.isEmpty {
                    segments.append(ArabicSegment(type: .ayah, content: trailing, number: nil))
                }
            }
        }
        
        return (bismillah, segments)
    }
}
