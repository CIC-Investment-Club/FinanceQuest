import Foundation

struct QuizQuestion: Identifiable, Equatable {
    let id: String
    let prompt: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
}

struct Lesson: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let questions: [QuizQuestion]
}

struct Unit: Identifiable, Equatable {
    let id: String
    let title: String
    let icon: String
    let accent: UnitAccent
    let lessons: [Lesson]
}

enum UnitAccent: String, Equatable {
    case emerald, sky, violet, sunset, mint
}

struct Course: Equatable {
    let title: String
    let subtitle: String
    let units: [Unit]
}

enum Curriculum {
    static let main: Course = Course(
        title: "Money Fundamentals",
        subtitle: "Build confidence, one lesson at a time",
        units: [
            Unit(
                id: "u1",
                title: "Money basics",
                icon: "dollarsign.circle.fill",
                accent: .emerald,
                lessons: [
                    Lesson(
                        id: "u1l1",
                        title: "What money does",
                        subtitle: "Medium of exchange & store of value",
                        questions: [
                            QuizQuestion(
                                id: "u1l1q1",
                                prompt: "The main role of money as a “medium of exchange” means:",
                                options: [
                                    "You only use cash",
                                    "It lets people trade without barter",
                                    "It must be gold",
                                    "It pays interest automatically"
                                ],
                                correctIndex: 1,
                                explanation: "Money as a medium of exchange helps people swap value without needing a double coincidence of wants (barter)."
                            ),
                            QuizQuestion(
                                id: "u1l1q2",
                                prompt: "“Store of value” means money can:",
                                options: [
                                    "Only be saved in a bank",
                                    "Hold purchasing power over time (usually)",
                                    "Never lose value",
                                    "Replace a budget"
                                ],
                                correctIndex: 1,
                                explanation: "A store of value means you can save it and expect to spend it later—though inflation can erode purchasing power."
                            ),
                            QuizQuestion(
                                id: "u1l1q3",
                                prompt: "Income is best described as:",
                                options: [
                                    "Money you already saved",
                                    "Money coming in over a period",
                                    "Your net worth",
                                    "Only salary from a job"
                                ],
                                correctIndex: 1,
                                explanation: "Income is cash inflow—salary, business profit, dividends, etc.—usually measured weekly, monthly, or yearly."
                            )
                        ]
                    ),
                    Lesson(
                        id: "u1l2",
                        title: "Wealth vs income",
                        subtitle: "Why they’re not the same",
                        questions: [
                            QuizQuestion(
                                id: "u1l2q1",
                                prompt: "Net worth (wealth) is roughly:",
                                options: [
                                    "Your monthly paycheck",
                                    "Assets minus liabilities",
                                    "Your credit score",
                                    "How much you spend"
                                ],
                                correctIndex: 1,
                                explanation: "Wealth is what you own minus what you owe—your balance sheet, not your paycheck."
                            ),
                            QuizQuestion(
                                id: "u1l2q2",
                                prompt: "Someone can have high income but low wealth if they:",
                                options: [
                                    "Invest passively",
                                    "Spend most of what they earn and carry debt",
                                    "Own a home",
                                    "Use a debit card"
                                ],
                                correctIndex: 1,
                                explanation: "High income doesn’t guarantee wealth—spending, taxes, and debt matter a lot."
                            )
                        ]
                    )
                ]
            ),
            Unit(
                id: "u2",
                title: "Budgeting",
                icon: "chart.pie.fill",
                accent: .sky,
                lessons: [
                    Lesson(
                        id: "u2l1",
                        title: "The 50/30/20 rule",
                        subtitle: "A simple starting framework",
                        questions: [
                            QuizQuestion(
                                id: "u2l1q1",
                                prompt: "In a classic 50/30/20 split, the “50” usually covers:",
                                options: [
                                    "Investments",
                                    "Needs like housing and groceries",
                                    "Fun spending only",
                                    "Emergency fund"
                                ],
                                correctIndex: 1,
                                explanation: "The 50% bucket is needs—rent, utilities, minimum debt payments, basic food, transport."
                            ),
                            QuizQuestion(
                                id: "u2l1q2",
                                prompt: "The “20” in 50/30/20 often targets:",
                                options: [
                                    "Dining out",
                                    "Savings and extra debt paydown",
                                    "Subscriptions",
                                    "Taxes"
                                ],
                                correctIndex: 1,
                                explanation: "Many guides use 20% for savings and accelerated debt repayment—adjust to your reality."
                            )
                        ]
                    ),
                    Lesson(
                        id: "u2l2",
                        title: "Emergency fund",
                        subtitle: "Your financial cushion",
                        questions: [
                            QuizQuestion(
                                id: "u2l2q1",
                                prompt: "A common starter emergency fund goal is:",
                                options: [
                                    "$0 until investing",
                                    "Roughly 3–6 months of essential expenses (rule of thumb)",
                                    "Exactly one paycheck",
                                    "The same as annual salary"
                                ],
                                correctIndex: 1,
                                explanation: "Three to six months of essential expenses is a common guideline—tune it to job stability and dependents."
                            ),
                            QuizQuestion(
                                id: "u2l2q2",
                                prompt: "Emergency cash is usually kept:",
                                options: [
                                    "In meme stocks",
                                    "Liquid and safe (e.g., savings account)",
                                    "Only in cash under a mattress",
                                    "In retirement accounts only"
                                ],
                                correctIndex: 1,
                                explanation: "You want quick access and low risk—high‑yield savings is a typical choice."
                            )
                        ]
                    )
                ]
            ),
            Unit(
                id: "u3",
                title: "Credit & debt",
                icon: "creditcard.fill",
                accent: .violet,
                lessons: [
                    Lesson(
                        id: "u3l1",
                        title: "APR in plain English",
                        subtitle: "What borrowing really costs",
                        questions: [
                            QuizQuestion(
                                id: "u3l1q1",
                                prompt: "APR on a loan or card mainly tells you:",
                                options: [
                                    "Your credit score",
                                    "The yearly cost of borrowing, expressed as a rate",
                                    "How much you earn",
                                    "Your tax bracket"
                                ],
                                correctIndex: 1,
                                explanation: "APR summarizes borrowing cost per year—compare offers carefully, including fees."
                            ),
                            QuizQuestion(
                                id: "u3l1q2",
                                prompt: "Making only minimum payments on high‑APR debt usually:",
                                options: [
                                    "Pays it off fastest",
                                    "Stretches repayment and increases total interest",
                                    "Improves APR automatically",
                                    "Builds an emergency fund"
                                ],
                                correctIndex: 1,
                                explanation: "Minimums keep you in debt longer; paying more cuts interest dramatically."
                            )
                        ]
                    ),
                    Lesson(
                        id: "u3l2",
                        title: "Credit scores",
                        subtitle: "Signals, not moral grades",
                        questions: [
                            QuizQuestion(
                                id: "u3l2q1",
                                prompt: "Payment history typically:",
                                options: [
                                    "Doesn’t matter",
                                    "Is a major factor in many scoring models",
                                    "Is private to you only",
                                    "Replaces income"
                                ],
                                correctIndex: 1,
                                explanation: "On-time payments are one of the biggest drivers of credit scores in common models."
                            ),
                            QuizQuestion(
                                id: "u3l2q2",
                                prompt: "Credit utilization means:",
                                options: [
                                    "How often you use cash",
                                    "How much of your credit limit you’re using",
                                    "Your investment return",
                                    "Your tax rate"
                                ],
                                correctIndex: 1,
                                explanation: "Lower utilization (vs. limits) often helps scores—many aim to keep it modest."
                            )
                        ]
                    )
                ]
            ),
            Unit(
                id: "u4",
                title: "Investing basics",
                icon: "chart.line.uptrend.xyaxis",
                accent: .sunset,
                lessons: [
                    Lesson(
                        id: "u4l1",
                        title: "Compound growth",
                        subtitle: "Time + return = snowball",
                        questions: [
                            QuizQuestion(
                                id: "u4l1q1",
                                prompt: "Compounding means your returns can:",
                                options: [
                                    "Only happen once",
                                    "Generate future returns on prior gains (in simplified terms)",
                                    "Guarantee no losses",
                                    "Remove the need to save"
                                ],
                                correctIndex: 1,
                                explanation: "Earnings can reinvest and grow—though markets fluctuate and returns aren’t guaranteed."
                            ),
                            QuizQuestion(
                                id: "u4l1q2",
                                prompt: "Diversification aims to:",
                                options: [
                                    "Pick one hot stock",
                                    "Spread risk across many investments",
                                    "Avoid all losses",
                                    "Maximize fees"
                                ],
                                correctIndex: 1,
                                explanation: "Don’t put all eggs in one basket—diversification manages risk, not luck."
                            )
                        ]
                    ),
                    Lesson(
                        id: "u4l2",
                        title: "Stocks vs bonds (intro)",
                        subtitle: "Different roles in a portfolio",
                        questions: [
                            QuizQuestion(
                                id: "u4l2q1",
                                prompt: "Equity (stock) ownership generally means:",
                                options: [
                                    "You lent money for a fixed coupon",
                                    "You own a slice of a company (with upside and risk)",
                                    "You own a loan to a government",
                                    "You’re guaranteed dividends"
                                ],
                                correctIndex: 1,
                                explanation: "Stocks are ownership shares—returns and risk vary widely."
                            ),
                            QuizQuestion(
                                id: "u4l2q2",
                                prompt: "A bond is often described as:",
                                options: [
                                    "Ownership of a company",
                                    "A loan to an issuer that typically pays interest",
                                    "A savings account",
                                    "A type of insurance"
                                ],
                                correctIndex: 1,
                                explanation: "Bonds are debt instruments—issuer promises to pay interest and return principal under terms."
                            )
                        ]
                    )
                ]
            ),
            Unit(
                id: "u5",
                title: "Taxes & retirement",
                icon: "building.columns.fill",
                accent: .mint,
                lessons: [
                    Lesson(
                        id: "u5l1",
                        title: "401(k) vs Roth (concept)",
                        subtitle: "When money is taxed differs",
                        questions: [
                            QuizQuestion(
                                id: "u5l1q1",
                                prompt: "A common idea behind a traditional 401(k) contribution is:",
                                options: [
                                    "Pay tax first, then invest",
                                    "Invest pre-tax (often), pay tax later on withdrawals (rules vary)",
                                    "No tax ever",
                                    "Only for day trading"
                                ],
                                correctIndex: 1,
                                explanation: "Traditional accounts often defer tax; withdrawals are generally taxed later—rules depend on plan and law."
                            ),
                            QuizQuestion(
                                id: "u5l1q2",
                                prompt: "Roth contributions are often made:",
                                options: [
                                    "With after-tax money; qualified withdrawals may be tax-free (rules vary)",
                                    "Only by employers",
                                    "Without limits",
                                    "Only after age 60"
                                ],
                                correctIndex: 0,
                                explanation: "Roth uses after-tax dollars; qualified withdrawals can be tax-free—check current IRS rules."
                            )
                        ]
                    )
                ]
            )
        ]
    )

    static func lesson(byId id: String) -> Lesson? {
        for unit in main.units {
            if let l = unit.lessons.first(where: { $0.id == id }) { return l }
        }
        return nil
    }

    static func unit(containingLessonId id: String) -> Unit? {
        for unit in main.units {
            if unit.lessons.contains(where: { $0.id == id }) { return unit }
        }
        return nil
    }
}
