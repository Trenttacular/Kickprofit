# KickProfit — Mac Transfer & Build Guide

## Prerequisites (Mac)

- macOS 14 Sonoma or later
- Xcode 16 (free from Mac App Store — ~7 GB download)
- Homebrew (install at brew.sh if not present)
- An Apple ID (free — required for code signing)

---

## Step 1: Install XcodeGen (run once on Mac)

```bash
brew install xcodegen
```

XcodeGen reads `project.yml` and generates the `.xcodeproj` file automatically.
Re-run `xcodegen generate` whenever you add new Swift files.

---

## Step 2: Get the code onto your Mac

**Option A — via Git:**
```bash
git clone https://github.com/Trenttacular/kickprofit KickProfit
cd KickProfit
```

**Option B — via iCloud Drive / USB:**
Copy the entire `KickProfit` folder (the one containing `project.yml`
and the inner `KickProfit/` source folder). Open Terminal and `cd` into it.

---

## Step 3: Generate the Xcode project

```bash
xcodegen generate
```

Expected output:
```
⚙️  Resolving project...
✅  Created project at KickProfit.xcodeproj
```

---

## Step 4: Open in Xcode

```bash
open KickProfit.xcodeproj
```

---

## Step 5: Configure signing

1. Click the blue `KickProfit` project icon in the navigator
2. Select the `KickProfit` **target**
3. Open the **Signing & Capabilities** tab
4. Check **Automatically manage signing**
5. Set **Team** to your Apple ID (add it via Xcode → Settings → Accounts)

---

## Step 6: Build and run

```
Cmd+B    verify zero compile errors
Cmd+R    build and run in simulator
```

Recommended simulator: iPhone 16 Pro

---

## Step 7: (Optional) Run on a real iPhone

1. Connect iPhone via USB
2. iPhone: Settings → Privacy & Security → Developer Mode → enable and restart
3. In Xcode: select your connected iPhone from the device picker
4. `Cmd+R` — accept "Trust this Developer" on device if prompted

---

## After adding new Swift files on Windows

```bash
git pull
xcodegen generate
```

---

## Project structure

```
KickProfit/                              repo root
  project.yml                           XcodeGen spec
  KickProfit.xcodeproj                  generated on Mac — git-ignored
  KickProfit/                           Swift source folder
    App/
      KickProfitApp.swift
      RootTabView.swift
    Assets.xcassets/
    Info.plist
    Models/
      Flip.swift
      Goal.swift
    Services/
      AnalyticsEngine.swift
    Views/
      Components/
        Extensions.swift
        DeltaBadge.swift
        StatPill.swift
      Home/
        HomeView.swift
        HeroProfitCard.swift
        PaceCard.swift
        RecentFlipRow.swift
      LogFlip/
        QuickLogFlipView.swift
        ShoeStepView.swift
        PricingStepView.swift
        ReviewSaveView.swift
        NumpadView.swift
        ProfitPreviewCard.swift
        ConfettiView.swift
      History/
        HistoryView.swift
        FlipDetailView.swift
      Reports/
        ReportsView.swift
      Settings/
        SettingsView.swift
```

---

## Bundle ID

`com.trenttacular.KickProfit`

---

## Troubleshooting

| Symptom | Fix |
|---|---|
| `xcodegen: command not found` | `brew install xcodegen` |
| "No such module 'Charts'" | Verify Deployment Target = iOS 17.0 |
| Files missing from Xcode navigator | Run `xcodegen generate` again |
| "No account for team" signing error | Xcode → Settings → Accounts → add Apple ID |
| SwiftData crash on launch | Long-press app in Simulator → Delete App, then re-run |
