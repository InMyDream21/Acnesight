//
//  JustifiedTextExample2.swift
//  FrameUpExample
//
//  Created by Ryan Lintott on 2022-11-15.
//

import SwiftUI
import WidgetKit

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero

    static func reduce(value _: inout Value, nextValue: () -> Value) {
        _ = nextValue()
    }
}

extension StringProtocol {
    func size(using font: UIFont) -> CGSize {
        return String(self).size(using: font)
    }
}

extension String {
    func size(using font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
    
    func splitMultilineByCharacter(font: UIFont, maxWidth: CGFloat) -> [String] {
        guard self.size(using: font).width > maxWidth else {
            return [self]
        }
        
        var characters = Array(self).map({String($0)})
        var multiline = [characters.removeFirst()]
        var index = 0
        
        while !characters.isEmpty {
            let character = characters.removeFirst()
            
            let line = multiline[index] + character
            
            if line.size(using: font).width <= maxWidth {
                multiline[index] = line
            } else {
                multiline.append(character)
                index += 1
            }
        }
        return multiline
    }
    
    func splitMultiline(by separator: Character = " ", font: UIFont, maxWidth: CGFloat) -> [String] {
        guard self.size(using: font).width > maxWidth else {
            return [self]
        }
        
        var parts = self.split(separator: separator)
        
        var multiline = [String]()
        
        while !parts.isEmpty {
            let part = String(parts.removeFirst())
            
            let line = [multiline.last, part].compactMap({$0}).joined(separator: String(separator))
            
            if !line.isEmpty && line.size(using: font).width <= maxWidth {
                if !multiline.isEmpty {
                    multiline[multiline.endIndex - 1] = line
                } else {
                    multiline.append(line)
                }
            } else {
                let wordParts = String(part).splitMultilineByCharacter(font: font, maxWidth: maxWidth)
                multiline += wordParts
            }
        }
        return multiline.map({String($0)})
    }
    
    func justified(font: UIFont, maxWidth: CGFloat) -> String {
        let separator: Character = " "
        let hairSpace: String = "\u{200A}"
        
        let lines = splitMultiline(font: font, maxWidth: maxWidth)
        
        return lines
            .map { line in
                let words = line.split(separator: separator)
                guard words.count > 1 else { return words.joined() }
                let justifiedSeparator = String(hairSpace)
                var justifiedLine = words.joined(separator: justifiedSeparator)
                var hairSpaceCount = 0
                while justifiedLine.size(using: font).width < maxWidth {
                    hairSpaceCount += 1
                    justifiedLine += hairSpace
                }
                hairSpaceCount -= 1
                let (minCount, extraCount) = hairSpaceCount.quotientAndRemainder(dividingBy: words.count - 1)
                let last = lines.last == line
                let spaces = Array(0..<words.count)
                    .map { i in
                        last ? " " : String.init(repeating: hairSpace, count: minCount) + (i < extraCount ? hairSpace : "")
//                        String.init(repeating: hairSpace, count: minCount) + (i < extraCount ? hairSpace : "")
                    }
                
                return zip(words, spaces)
                    .map {
                        String($0 + $1)
                    }
                    .joined()
                    .trimmingCharacters(in: .whitespaces)
            }
            .joined(separator: "\n")
    }
}



struct JustifiedText : View {
    let text: String
    let maxWidth : CGFloat
    var uiFont: UIFont = .systemFont(ofSize: 16,weight: .regular)
    
    var body: some View {
        Text(text.justified(font: uiFont, maxWidth: maxWidth))
            .font(Font(uiFont))
            .padding(0)
    }
}

let copyTest = "Lorem Ipsum is simply dummy text of the printing and tith desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."

#Preview {
    JustifiedText(text: copyTest, maxWidth: 300)
}



//#Preview {
//    JustifiedTextExample2(text: "Lorem Ipsum is simply dummy text of the printing and tith desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
//                          
//, maxWidth: 200)
//    .background(.red)
//}
