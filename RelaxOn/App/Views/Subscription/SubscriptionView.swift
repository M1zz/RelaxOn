//
//  SubscriptionView.swift
//  RelaxOn
//
//  Paywall UI for subscription
//

import SwiftUI
import StoreKit

struct SubscriptionView: View {

    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    @State private var isPurchasing = false
    @State private var showError = false
    @State private var errorMessage = ""

    // 법적 링크 (App Store 가이드라인 3.1.2 필수)
    private let termsOfUseURL = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!
    private let privacyPolicyURL = URL(string: "https://m1zz.github.io/RelaxOn/privacy.html")!

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.05, blue: 0.15),
                    Color(red: 0.15, green: 0.1, blue: 0.2),
                    Color(red: 0.2, green: 0.15, blue: 0.25)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Close button
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white.opacity(0.5))
                            .frame(width: 44, height: 44)
                    }
                    .padding(.trailing, 16)
                    .padding(.top, 12)
                    .accessibilityLabel(L.A11y.closeButton.localized)
                }

                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        headerSection()

                        // Feature comparison
                        featureComparison()

                        // Price & subscribe
                        purchaseSection()

                        // Restore
                        Button(action: {
                            Task {
                                await subscriptionManager.restorePurchases()
                                if subscriptionManager.isPremium {
                                    dismiss()
                                }
                            }
                        }) {
                            Text(L.Subscription.restore.localized)
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.6))
                                .underline()
                        }

                        // 법적 고지 및 약관/개인정보 링크
                        legalSection()
                            .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .alert(L.Subscription.error.localized, isPresented: $showError) {
            Button("OK") {}
        } message: {
            Text(errorMessage)
        }
    }

    // MARK: - Header

    @ViewBuilder
    private func headerSection() -> some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(.PrimaryPurple).opacity(0.3))
                    .frame(width: 100, height: 100)

                Image(systemName: "crown.fill")
                    .font(.system(size: 48))
                    .foregroundColor(Color(.PrimaryPurple))
            }

            Text(L.Subscription.title.localized)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text(L.Subscription.description.localized)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 16)
    }

    // MARK: - Feature Comparison

    @ViewBuilder
    private func featureComparison() -> some View {
        VStack(spacing: 16) {
            // Free tier
            tierCard(
                title: L.Subscription.freeTier.localized,
                icon: "person.fill",
                color: .gray,
                features: [
                    (L.Subscription.freeSoundsLimit.localized, true),
                    (L.Subscription.freeCategoriesLimit.localized, true),
                    (L.Subscription.unlimitedSounds.localized, false),
                    (L.Subscription.allCategories.localized, false)
                ]
            )

            // Premium tier
            tierCard(
                title: L.Subscription.premiumTier.localized,
                icon: "crown.fill",
                color: Color(.PrimaryPurple),
                features: [
                    (L.Subscription.unlimitedSounds.localized, true),
                    (L.Subscription.allCategories.localized, true),
                    (L.Subscription.freeSoundsLimit.localized, true),
                    (L.Subscription.freeCategoriesLimit.localized, true)
                ],
                highlighted: true
            )
        }
    }

    @ViewBuilder
    private func tierCard(
        title: String,
        icon: String,
        color: Color,
        features: [(String, Bool)],
        highlighted: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }

            ForEach(features.indices, id: \.self) { index in
                let feature = features[index]
                HStack(spacing: 10) {
                    Image(systemName: feature.1 ? "checkmark.circle.fill" : "xmark.circle")
                        .font(.system(size: 16))
                        .foregroundColor(feature.1 ? .green : .white.opacity(0.3))
                    Text(feature.0)
                        .font(.system(size: 14))
                        .foregroundColor(feature.1 ? .white : .white.opacity(0.4))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(highlighted ? 0.12 : 0.06))
                .overlay(
                    highlighted ?
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.PrimaryPurple).opacity(0.5), lineWidth: 1.5)
                    : nil
                )
        )
    }

    // MARK: - Purchase Section

    @ViewBuilder
    private func purchaseSection() -> some View {
        VStack(spacing: 12) {
            if let product = subscriptionManager.monthlyProduct {
                // Trial info
                if let trial = subscriptionManager.trialText {
                    Text(trial)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(.PrimaryPurple))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Color(.PrimaryPurple).opacity(0.15))
                        .cornerRadius(8)
                }

                // Price
                Text(L.Subscription.priceFormat.localized.replacingOccurrences(of: "{price}", with: product.displayPrice))
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))

                // Subscribe button
                Button(action: {
                    isPurchasing = true
                    Task {
                        do {
                            try await subscriptionManager.purchase()
                            if subscriptionManager.isPremium {
                                dismiss()
                            }
                        } catch {
                            errorMessage = error.localizedDescription
                            showError = true
                        }
                        isPurchasing = false
                    }
                }) {
                    HStack(spacing: 8) {
                        if isPurchasing {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 16))
                            Text(L.Subscription.subscribe.localized)
                                .font(.system(size: 17, weight: .bold))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(.PrimaryPurple),
                                Color(.PrimaryPurple).opacity(0.8)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: Color(.PrimaryPurple).opacity(0.4), radius: 12, x: 0, y: 6)
                }
                .disabled(isPurchasing)
            } else {
                VStack(spacing: 12) {
                    ProgressView()
                        .tint(.white)

                    Text(L.Subscription.loadingProducts.localized)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.5))

                    Button(action: {
                        Task {
                            await subscriptionManager.fetchProducts()
                        }
                    }) {
                        Text(L.Subscription.retry.localized)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(.PrimaryPurple))
                    }
                }
                .padding()
            }
        }
    }

    // MARK: - Legal Section

    @ViewBuilder
    private func legalSection() -> some View {
        VStack(spacing: 12) {
            // 자동 갱신 안내 문구
            Text(L.Subscription.legalNotice.localized)
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.45))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            // 이용약관(EULA) / 개인정보 처리방침 링크
            HStack(spacing: 16) {
                Button(action: { openURL(termsOfUseURL) }) {
                    Text(L.Subscription.termsOfUse.localized)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .underline()
                }

                Text("·")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.4))

                Button(action: { openURL(privacyPolicyURL) }) {
                    Text(L.Subscription.privacyPolicy.localized)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .underline()
                }
            }
        }
        .padding(.top, 8)
    }
}
