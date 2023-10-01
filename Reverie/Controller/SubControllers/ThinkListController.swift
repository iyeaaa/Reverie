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
    @State var showDetailPage = false
    
    @State var isAleadyLoadThinks = false
    
    @Namespace var namespace
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 25) {
                Text("Thinking")
                    .font(.custom("Roboto-Bold", size: 24))
//                    .padding(.vertical)
                ForEach(thinks, id: \.think.thinkID) { think in
                    Button {
                        withAnimation(.interactiveSpring(
                            response: 0.4,
                            dampingFraction: 0.6,
                            blendDuration: 0.3
                        )) {
                            currentThink = think
                            tabbarController?.tabBar.isHidden = true
                        }
                    } label: {
                        ThinkingCard(think)
                    }
                    .buttonStyle(ScaledButtonStyle())
                }
            }
            .padding()
            .padding(.horizontal)
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
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    RemoteImage(url: think.think.imageUrl)
                    .frame(width: size.width, height: size.height)
                }
                
                if currentThink == nil {
                    LinearGradient(
                        colors: [
                            .black.opacity(0.5),
                            .black.opacity(0.2),
                            .clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    if currentThink == nil {
                        Text(think.title)
                            .font(.title)
                            .offset(y: currentThink == nil ? 0 : safeArea().top)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.white)
                            .lineLimit(2)
                            .bold()
                            .padding(20)
                        
                        
                    }
                    Spacer()
                    ZStack {
                        VisualEffectView(effect: UIBlurEffect(style: .extraLight))
                            .frame(height: 60)
                            .opacity(0.7)
                        
                        HStack(spacing: 20) {
                            RemoteImage(url: think.think.ownerImageUrl)
                                .frame(width: 40, height: 40)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                )
                            Text(think.username)
                                .font(.system(size: 23))
                                .bold()
                                .foregroundStyle(.black)
                        }
                    }
                }
                
            }
            .clipShape(
                RoundedRectangle(cornerRadius: currentThink == nil ? 30 : 0, style: .continuous)
            )
            .frame(height: 250)
        }
        .matchedGeometryEffect(id: think.think.thinkID, in: namespace)
    }
    
    // MARK: - DetailThinkingCard
    func DetailThinkingCard(_ think: ThinkCellViewModel) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .trailing) {
                    ThinkingCard(think)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text(think.title)
                            .font(.system(size: 25, weight: .bold))
                        Divider()
                            .background(Color.gray)
                        Text(think.content)
                            .font(.system(size: 22))
                        Text("\(think.timestampString ?? "Unknown Time")")
                            .font(.system(size: 18, weight: .semibold))
                        Spacer(minLength: safeArea().bottom)
                    }
                    .scaleEffect(showDetailPage ? 1 : 0, anchor: .top)
                    .padding(30)
                }
            }
        }
        .background(
            Rectangle()
                .foregroundStyle(.white)
        )
        .onAppear {
            withAnimation(.interactiveSpring(
                response: 0.5,
                dampingFraction: 0.8,
                blendDuration: 0.6
            )) {
                showDetailPage = true
            }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                withAnimation(.interactiveSpring(
                    response: 0.3,
                    dampingFraction: 0.9,
                    blendDuration: 0.3
                )) {
                    currentThink = nil
                    tabbarController?.tabBar.isHidden = false
                }
                withAnimation(.interactiveSpring(
                    response: 0.3,
                    dampingFraction: 0.9,
                    blendDuration: 0.3
                )) {
                    showDetailPage = false
                }
            } label: {
                Image(systemName: "xmark.square.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .gray)
                    .font(.system(size: 35))
            }
            .padding(20)
            .offset(y: safeArea().top)
        }
        .scrollBounceBehavior(.basedOnSize)
        
    }
}

#Preview {
    ThinkListController()
}

// MARK: - Scaled Button Style
struct ScaledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.easeIn, value: configuration.isPressed)
    }
}

// MARK: - VisualEffectView
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView()
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect
    }
}
