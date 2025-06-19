//
//  ResultDetailView.swift
//  Acnesight
//
//  Created by Vira Fitriyani on 16/06/25.
//

import SwiftUI

struct ResultDetailView: View {
    let detectedTypes: [AcneType]
    @State private var selectedType: AcneType
    @Environment(Router.self) var router
    
    // Initialize selectedType with the first detected acne type
    init(detectedTypes: [AcneType]) {
        self.detectedTypes = detectedTypes
        _selectedType = State(initialValue: detectedTypes.first ?? .pustule)
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 15) {
                    Button(action: {
                        router.navigateBack()
                    }) {
                        Label("Result", systemImage: "chevron.left")
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Text("Acne Information")
                        .font(.largeTitle).bold()
                        .padding(.horizontal)
                }
                
                Picker("Acne Type", selection: $selectedType) {
                    ForEach(detectedTypes, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .tint(Color("PrimaryColor"))
                
                Text("\(selectedType.rawValue)")
                    .font(.system(size: 17)).bold()
                    .padding(.horizontal)
                
            ScrollView {
                    HStack(spacing: 16) {
                        VStack {
                            Image(sampleImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 100)
                                .clipped()
                                .cornerRadius(8)
                            Text("Closer Look")
                                .font(.caption)
                        }
                        
                        VStack {
                            Image(zoomedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 100)
                                .clipped()
                                .cornerRadius(8)
                            Text("Zoomed in")
                                .font(.caption)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        detailSection(title: "Overview", text: overviewText)
                        detailSection(title: "Possible Cause", text: causeText)
                        detailSection(title: "What you shouldn't do", text: shouldntText)
                        detailSection(title: "Common ways to treat", text: treatText)
                    }
                    .padding(.horizontal, 2)
                    
                    // Footer
                    VStack(alignment: .center) {
                        Text("This result is based on scientific papers. You can see it through")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        Button(action: {
                            router.navigateToResource()
                        }) {
                            Text("here")
                                .font(.system(size: 10))
                                .foregroundColor(.blue)
                                .underline()
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
            }
        }
        .padding(.leading, 30)
        .padding(.trailing, 30)
    }
    
    func detailSection(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.black)

            Text(text)
                .font(.caption)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(maxWidth: 333, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 2)
    }
    
    var sampleImage: String {
        switch selectedType {
        case .pustule:
            return "samplePustule"
        case .papule:
            return "samplePapule"
        case .nodule:
            return "sampleNodule"
        case .blackhead:
            return "sampleBlackhead"
        case .whitehead:
            return "sampleWhitehead"
        }
    }
    
    var zoomedImage: String {
        switch selectedType {
        case .pustule:
            return "samplePustule_zoom"
        case .papule:
            return "samplePapule_zoom"
        case .nodule:
            return "sampleNodule_zoom"
        case .blackhead:
            return "sampleBlackhead_zoom"
        case .whitehead:
            return "sampleWhitehead_zoom"
        }
    }

    var overviewText: String {
        switch selectedType {
        case .pustule:
            return "Pustule is a small bump and inflammatory lesion that occurs on the skin by clogging the pores with excess oil and dead skin cells. Pustule contains fluid or pus in the center."
        case .papule:
            return "Papule is an inflamed blemishes that can be large or small. They look like red bumps or lumps on the skin and don't have a white head. papule is considered an intermediary step between non-inflammatory and inflammatory lesions."
        case .nodule:
            return "Nodule is a severe form of inflammatory acne that develops when the pores become clogged by bacteria, excess oil and dead skin cells."
        case .blackhead:
            return "Blackheads are non-inflammatory acne lesions that develop on the skin due to excess oil and dead skin cells obstructing hair shafts. A blackhead is referred to as an open comedo because the skin surface remains exposed and has a dark look, such as black or brown."
        case .whitehead:
            return "Whiteheads are small bumps and non-inflammatory acne lesion that develops on the skin when oil, bacteria and skin cells block the opening of hair follicle pores. Whiteheads are referred to as closed comedones since the bumps are closed and white."
        }
    }

    var causeText: String {
        switch selectedType {
        case .pustule:
            return """
                    • Bacteria, clogged pores, and hormonal imbalance
                    • May form from untreated papules or comedones
                    """
        case .papule:
            return """
                    • Inflamed whitehead due to bacterial invasion (Cutibacterium acnes)
                    • Immune response causes redness and swelling
                    • Often triggered by hormone fluctuations, stress, diet
                    """
        case .nodule:
            return """
                    • Severe inflammation deep within the skin
                    • Hormonal imbalance, genetic predisposition, or stress
                    """
        case .blackhead:
            return """
                    • Sebum oxidizes, causing black or dark appearance
                    • Often worsened by excess oil and pollution exposure
                    """
        case .whitehead:
            return """
                    • Clogged hair follicles with oil (sebum) and dead skin cells
                    • Often due to hormonal changes (puberty, menstrual cycle, etc)
                    • Use of comedogenic skincare or makeup products
                    """
        }
    }

    var shouldntText: String {
        switch selectedType {
        case .pustule:
            return """
                    • Avoid popping pustule, it may spread bacteria and worsen inflammation
                    • Avoid alcohol-based toners or overly drying products
                    • Avoid picking pustule with dirty hands or tools
                    """
        case .papule:
            return """
                    • Avoid pop or press it
                    • Avoid harsh scrubs, it may worsen inflammation
                    • Don’t use too many active ingredients at once
                    """
        case .nodule:
            return """
                    • Do not pop it to avoid deep scarring
                    • Avoid overusing strong actives that irritate skin barrier
                    • Don’t delay the treatment to prevent worsen condition or permanent marks
                    """
        case .blackhead:
            return """
                    • Avoid forceful extraction or metal tools
                    • Don’t use pore strips aggressively, it may damage skin
                    • Avoid occlusive or waxy products
                    """
        case .whitehead:
            return """
                    • Avoid squeeze or pick whitehead, it may cause inflammation or scarring
                    • Avoid heavy makeup or oily skincare
                    • Don’t overwash your face to prevent striping skin and trigger more oil production
                    """
        }
    }

    var treatText: String {
        switch selectedType {
        case .pustule:
            return """
                    • OTC tropical retinoid and tropical antimikroba
                    • (Alternative) topical antimicrobial agents and (Alternative) topical retinoids or azelaic acid
                    """
        case .papule:
            return """
                    • OTC tropical retinoid and tropical antimikroba
                    • (Alternative) topical antimicrobial agents and (Alternative) topical retinoids or azelaic acid
                    """
        case .nodule:
            return """
                    • OTC antibiotik oral dan tropical retinoid
                    • Alternative) oral isotretinoin or (Alternative) oral antibiotics and (Alternative) topical retinoids
                    """
        case .blackhead:
            return """
                    • OTC tropical retinoid
                    • (Alternative) topical retinoids, azelaic acid or salicylic acid
                    """
        case .whitehead:
            return """
                    • OTC tropical retinoid
                    • (Alternative) topical retinoids, azelaic acid or salicylic acid
                    """
        }
    }
}

struct ResultDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ResultDetailView(detectedTypes: [.papule, .pustule, .nodule, .blackhead, .whitehead])
            .environment(Router())
    }
}
