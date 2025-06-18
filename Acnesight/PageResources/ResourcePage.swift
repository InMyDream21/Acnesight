//
//  ResourcePage.swift
//  Acnesight
//
//  Created by Vira Fitriyani on 18/06/25.
//

import SwiftUI

struct ResourcePage: View {
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 10) {
                Button(action: {
                    // back to ResultDetailView
                }) {
                    Label("Acne Information", systemImage: "chevron.left")
                        .foregroundColor(.blue)
                }
                
                Text("References & Credits")
                    .font(.title).bold()
            }
            .padding(.horizontal, 22)
            .padding(.top)
            .padding(.bottom, 10)
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("📗 Medical information and classification of acne in this application refers to the following sources:")
                            .font(.system(size: 11)).bold()
                            .padding(.bottom, 10)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Kaza, R. (2016). Types of Acne and Associated Therapy: A Review. ResearchGate.")
                                .font(.caption)
                            Link("link.researchgate.net",
                                 destination: URL(string: "https://www.researchgate.net/publication/304251729_Types_of_Acne_and_Associated_Therapy_A_Review")!)
                            .font(.caption)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Vasam, M. (2023). Acne vulgaris: A review of the pathophysiology, treatment, and recent nanotechnology based advances. National Institutes of Health (PMC)")
                                .font(.caption)
                            Link("link.ncbi.nlm.nih.gov", destination: URL(string: "https://pmc.ncbi.nlm.nih.gov/articles/PMC10709101/")!)
                                .font(.caption)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Acne Types Overview. (n.d.). Verywell Health.")
                                .font(.caption)
                            Link("link.verywellhealth.com", destination: URL(string: "https://www.verywellhealth.com/types-of-inflamed-pimples-15615#toc-pustules")!)
                                .font(.caption)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .frame(maxWidth: 330)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("📷 Some of the illustrations and images in this application come from online sources which are used for educational and non-commercial purposes. We thank the copyright owners for their contributions. Some image sources:")
                            .font(.system(size: 11)).bold()
                            .padding(.bottom, 10)
                        
                        Text("Pustule photos by: Dr. Reena’s Blog & Liudmila Chernetska")
                            .font(.caption)
                        Text("Papule photos by: Derm Collective & Cleveland Clinic")
                            .font(.caption)
                        Text("Blackhead photos by: Poonam Sachdev on WebMD & The Cosmetic Clinic")
                            .font(.caption)
                        Text("Whitehead photos by: Cleveland Clinic & Laura Schober on Health.com")
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .frame(maxWidth: 330)
                    
                }
                .padding()
            }
        }
    }
}

#Preview {
    ResourcePage()
}
