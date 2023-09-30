//
//  ThinkListController.swift
//  Reverie
//
//  Created by 이예인 on 9/30/23.
//

import SwiftUI

struct ThinkListController: View {
    var tabbarController: UITabBarController?
    
    @State var thinks: [ThinkCellViewModel] = []
    @State var currentThink: ThinkCellViewModel? = nil
    
    @State var isAleadyLoadThinks = false
    
    @Namespace var namespace
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                ForEach(thinks, id: \.think.thinkID) { think in
                    if currentThink?.think.thinkID != think.think.thinkID {
                        Button {
                            withAnimation(.interactiveSpring(
                                response: 0.7,
                                dampingFraction: 0.5,
                                blendDuration: 0.5
                            )) {
                                currentThink = think
                                tabbarController?.tabBar.isHidden = true
                            }
                        } label: {
                            ThinkingCard(think)
                        }
                        .padding()
                        .padding(.horizontal)
                    }
                }
            }
        }
        .scrollBounceBehavior(.automatic)
        .onAppear {
            if !isAleadyLoadThinks {
                ThinkService.fetchThinks { thinks in
                    self.thinks = thinks.map { ThinkCellViewModel(think: $0) }
                }
            }
        }
        .overlay(alignment: .top) {
            if let currentThink {
                DetailThinkingCard(currentThink)
                    .ignoresSafeArea()
            }
        }
        .overlay(alignment: .bottom) {
            if currentThink == nil {
                WriteButton()
            }
        }
    }
    
    // MARK: - Write Button
    func WriteButton() -> some View {
        Button {
            
        } label: {
            HStack {
                Image(systemName: "pencil.and.outline")
                    .bold()
                Text("Write")
                    .bold()
            }
            .foregroundStyle(.black)
        }
        .padding(10)
        .padding(.horizontal, 15)
        .background(
            Capsule(style: .continuous)
                .strokeBorder(Color(red: 180/255, green: 180/255, blue: 180/255), lineWidth: 1.5)
                .background(Capsule().fill(Color(red: 240/255, green: 241/255, blue: 242/255)))
        )
        .offset(y: -20)
    }
    
    // MARK: - ThinkingCard
    func ThinkingCard(_ think: ThinkCellViewModel) -> some View {
        VStack {
            ZStack(alignment: .topLeading) {
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    RemoteImage(url: think.think.imageUrl)
                    .frame(width: size.width, height: size.height)
                }
                
                LinearGradient(
                    colors: [
                        .black.opacity(0.5),
                        .black.opacity(0.2),
                        .clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(think.title)
                        .font(.title)
                }
                .offset(y: currentThink == nil ? 0 : safeArea().top)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.white)
                .lineLimit(2)
                .bold()
                .padding(20)
            }
            .clipShape(
                RoundedRectangle(cornerRadius: currentThink == nil ? 30.0 : 0, style: .continuous)
            )
            .frame(height: 250)
        }
        .transition(.identity)
        .matchedGeometryEffect(id: think.think.thinkID, in: namespace)
    }
    
    // MARK: - DetailThinkingCard
    func DetailThinkingCard(_ think: ThinkCellViewModel) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .trailing) {
                    ThinkingCard(think)
                    VStack(alignment: .leading, spacing: 20) {
                        Text(think.content)
                            .font(.system(size: 22))
                        Text(think.content)
                            .font(.system(size: 22))
                        Text(think.content)
                            .font(.system(size: 22))
                        Text("\(think.timestampString ?? "Unknown Time")")
                            .font(.system(size: 18, weight: .semibold))
                        Spacer(minLength: safeArea().bottom)
                    }
                    .padding()
                }
            }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                withAnimation(.interactiveSpring(
                    response: 0.7,
                    dampingFraction: 0.5,
                    blendDuration: 0.5
                )) {
                    currentThink = nil
                    tabbarController?.tabBar.isHidden = false
                }
            } label: {
                Image(systemName: "xmark.square.fill")
                    .foregroundStyle(.red)
            }
            .padding(20)
            .offset(y: safeArea().top)
        }
        .background(
            Color.white
        )
        .scrollBounceBehavior(.basedOnSize)
    }
}

#Preview {
    ThinkListController()
}

// MARK: - SafeArea
extension View {
    func safeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
            
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
            
        return safeArea
    }
}
