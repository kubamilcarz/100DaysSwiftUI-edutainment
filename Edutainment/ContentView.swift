//
//  ContentView.swift
//  Edutainment
//
//  Created by Kuba Milcarz on 22/11/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isGameActive = false // default: false
    
    private var lowerRange = 2
    @State private var upperRange = 7 // default: 4
    @State private var numberOfQuestions = 5 // default: 5
    @State private var score = 0
    // game logic
    @State private var currentQuestion = 1
    @State private var randomNumber = 2
    @State private var randomMultiplier = 2
    @State private var guess = 0
    @FocusState private var answerFieldFocused
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isAlertPresented = false
    
    @State private var isAnswerShowing = false
    @State private var answerTitle = ""
    @State private var answerMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AngularGradient(gradient: Gradient(colors: [Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.purple, Color.pink]), center: .center)
                    .ignoresSafeArea()
                
                if isGameActive {
                    VStack(spacing: 30) {
                        Spacer()
                        Text("How much is \(randomNumber) times \(randomMultiplier)?")
                            .font(.title)
                        TextField("Amount", value: $guess, format: .number)
                            .keyboardType(.numberPad)
                            .padding(.vertical, 20)
                            .background(RoundedRectangle(cornerRadius: 9).fill(.thinMaterial))
                            .focused($answerFieldFocused)
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                        Button("Answer") {
                            withAnimation {
                                answer()
                            }
                        }.buttonStyle(.borderedProminent)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
                } else {
                    VStack(spacing: 30) {
                        VStack(spacing: 10) {
                            Text("Welcome to Edutainment!")
                                .font(.title)
                                .multilineTextAlignment(.center)
                            Text("The perfect place to master multiplication table")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                        VStack(spacing: 30) {
                            Section("Choose the range") {
                                Stepper("From 2 up to \(upperRange)", value: $upperRange, in: 4...20, step: 1)
                            }
                            Section("Choose the number of questions") {
                                Picker(selection: $numberOfQuestions, label: Text("Choose the number of questions")) {
                                    Text("2").tag(2)
                                    Text("5").tag(5)
                                    Text("10").tag(10)
                                    Text("all").tag(upperRange - lowerRange)
                                }.pickerStyle(.segmented)
                            }
                        }
                        Spacer()
                        Button("Start the Game!") {
                            withAnimation {
                                startGame()
                            }
                        }.buttonStyle(.borderedProminent)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
                }
            }
            .alert(alertTitle, isPresented: $isAlertPresented) {
                Button("Continue", action: resetGame)
            } message: {
                Text(alertMessage)
            }
            .alert(answerTitle, isPresented: $isAnswerShowing) {
                Button("Ok", action: loadNextQuestion)
            } message: {
                Text(answerMessage)
            }
            
            .navigationTitle(isGameActive ? "Question \(currentQuestion) out of \(numberOfQuestions)" : "Edutainment")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(isGameActive ? "Score: \(score)" : "")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isGameActive ? "Start over": "") {
                        if isGameActive {
                            resetGame()
                        }
                    }
                }
            }
        }
        
    }
    
    func startGame() {
        
        if numberOfQuestions > (upperRange - lowerRange) {
            alertTitle = "Something went wrong..."
            alertMessage = "Number of questions cannot be higher than the upper range."
            isAlertPresented = true
            return
        }
        
        currentQuestion = 1
        randomNumber = Int.random(in: lowerRange...upperRange)
        randomMultiplier = Int.random(in: lowerRange...upperRange)
        
        isGameActive = true
        answerFieldFocused = true
    }
    
    func resetGame() {
        answerFieldFocused = false
        isGameActive = false
        
        upperRange = 4
        numberOfQuestions = 2
        score = 0
    }
    
    func answer() {
        answerFieldFocused = false
        
        if currentQuestion >= numberOfQuestions {
            if randomNumber*randomMultiplier == guess {
                score += 1
            }
            
            isAlertPresented = true
            alertTitle = "Game Over!"
            alertMessage = "Congrats! You scored \(score) out of \(numberOfQuestions). So far so good! Click `continue` to play again."
            return
        }
        
        isAnswerShowing = true
        
        if randomNumber * randomMultiplier == guess {
            score += 1
            answerTitle = "Correct!"
            answerMessage = "You were right! \(randomNumber) x \(randomMultiplier) = \(guess). Current score is \(score)."
        } else {
            answerTitle = "Wrong!"
            answerMessage = "\(randomNumber) x \(randomMultiplier) = \(randomNumber*randomMultiplier), not \(guess). Current score is \(score)."
        }
    }
    
    func loadNextQuestion() {
        currentQuestion += 1
        
        randomNumber = Int.random(in: lowerRange...upperRange)
        randomMultiplier = Int.random(in: lowerRange...upperRange)
        
        answerFieldFocused = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
