# 🔔 Custom Notification Sounds Guide

This guide covers the optional Dune-themed notification sound pack and how to add custom sounds to the app.

---

## 🎵 Optional Sound Pack (Recommended Approach)

The app ships **without bundled sounds** to keep the download size small. Users who want custom Dune-themed notification sounds can download an optional sound pack.

### For Users

1. Go to [Releases](https://github.com/StarTuz/dune-awakening-companion/releases)
2. Download `dune-sound-pack-v1.0.zip`
3. Extract to your device's notification sounds folder:
   - **Android**: Copy `.ogg` files to `Ringtones` or `Notifications` folder
   - **iOS**: Not supported (iOS doesn't allow custom notification sounds from downloads)
   - **Linux**: Place in `~/.local/share/sounds/` or use system sound settings
   - **Windows**: Place in `C:\Windows\Media\` or use system sound settings
4. In Settings → Sound → Notification sound, select the Dune sound

### For Developers

**Creating the sound pack release:**

1. Create a `sounds/` directory with the sound files
2. Zip the folder: `zip -r dune-sound-pack-v1.0.zip sounds/`
3. Upload to GitHub Releases alongside the app release

**Sound pack structure:**
```
dune-sound-pack-v1.0.zip
└── sounds/
    ├── README.txt          # Installation instructions
    ├── LICENSE.txt         # Sound licensing info
    ├── alert_critical.ogg  # Urgent alert (< 24h)
    ├── alert_warning.ogg   # Warning alert (< 48h)
    ├── alert_tax.ogg       # Tax reminder
    └── alert_test.ogg      # Test notification
```

---

## 🎨 Creating Dune-Themed Sounds

### Option 1: AI Sound Generation (Easiest)

**Tools:**
- [ElevenLabs Sound Effects](https://elevenlabs.io/sound-effects) - Text-to-SFX AI
- [Suno AI](https://suno.ai) - Music/sound generation
- [Stable Audio](https://stableaudio.com) - AI audio generation

**Prompts for Dune sounds:**
```
"Deep rumbling sandworm approaching, ominous desert vibration, 3 seconds"
"Sci-fi alert tone, spice melange shimmer, crystalline, urgent, 2 seconds"
"Ornithopter engine startup, futuristic helicopter, short burst"
"Desert wind warning siren, Arrakis, dystopian, brief"
"Fremen water ritual chime, mystical, notification sound"
```

### Option 2: Free Sound Libraries

**Sources (check licenses!):**
- [Freesound.org](https://freesound.org) - CC-licensed sounds
- [Pixabay Audio](https://pixabay.com/sound-effects/) - Royalty-free
- [Zapsplat](https://www.zapsplat.com) - Free with attribution
- [BBC Sound Effects](https://sound-effects.bbcrewind.co.uk/) - Personal use

**Search terms:**
- "desert wind", "sand storm", "rumble"
- "sci-fi alert", "futuristic notification", "spaceship beep"
- "crystal chime", "mystical tone", "alien signal"
- "industrial machinery", "mining equipment"

### Option 3: Create from Scratch

**Software:**
- [Audacity](https://www.audacityteam.org/) - Free, open source
- [LMMS](https://lmms.io/) - Free digital audio workstation
- [GarageBand](https://www.apple.com/mac/garageband/) - macOS, free

**Techniques for Dune vibes:**
1. **Sandworm rumble**: Layer low bass tones (40-80Hz), add distortion, slow pitch bend
2. **Spice shimmer**: High-frequency synthesizer, reverb, delay
3. **Desert wind**: White noise + low-pass filter, volume automation
4. **Fremen call**: Human voice pitch-shifted, added echo/reverb

### Option 4: Commission/License

- **Fiverr/Upwork**: Commission custom sounds ($20-100)
- **Audio Jungle**: Licensed sound packs ($1-20)
- **Epidemic Sound**: Subscription for commercial use

---

## 📋 Sound Requirements

### Technical Specs

| Platform | Format | Max Duration | Max Size |
|----------|--------|--------------|----------|
| Android | `.ogg`, `.mp3` | 30 sec | 1 MB |
| iOS | `.caf`, `.aiff` | 30 sec | 5 sec recommended |
| Linux | `.ogg`, `.wav` | No limit | Reasonable |
| Windows | `.wav` | No limit | Reasonable |

### Recommended Settings
- **Duration**: 1-3 seconds (short and punchy)
- **Sample Rate**: 44.1 kHz
- **Bit Depth**: 16-bit
- **Channels**: Mono (saves space)
- **Volume**: Normalized, not clipping

### Converting Sounds

**Using FFmpeg:**
```bash
# Convert to OGG (Android)
ffmpeg -i input.mp3 -c:a libvorbis -q:a 5 output.ogg

# Convert to CAF (iOS)
afconvert input.mp3 output.caf -d ima4 -f caff

# Trim to 3 seconds
ffmpeg -i input.mp3 -t 3 output.mp3

# Normalize volume
ffmpeg -i input.mp3 -filter:a loudnorm output.mp3
```

---

## 🎭 Sound Concepts for Dune

| Alert Type | Mood | Sound Idea |
|------------|------|------------|
| **Critical** (< 24h) | Urgent, alarming | Deep sandworm rumble + warning tone |
| **Warning** (< 48h) | Cautionary | Distant spice harvester, alert chime |
| **Tax Due** | Reminder | Coin/credit sound, guild bell |
| **Tax Overdue** | Urgent | Harkonnen danger signal |
| **Test** | Neutral | Ornithopter blip, generic sci-fi |

### Thematic Elements
- **Sandworms**: Deep bass, rumbling, subsonic vibration
- **Spice**: Crystalline, shimmering, otherworldly
- **Fremen**: Tribal drums, breath sounds, whispers
- **Technology**: Ornithopter sounds, shield hum, stillsuit beeps
- **Desert**: Wind, sand movement, desolation

---

## 📄 Licensing Considerations

⚠️ **Important**: Dune is a copyrighted property. Your sounds should be:

1. **Inspired by**, not copied from the movies/games
2. **Original creations** or properly licensed
3. **Not using** official Dune audio samples
4. **Clearly labeled** as fan-made/unofficial

Recommended licenses for your sound pack:
- **CC BY 4.0**: Attribution required
- **CC0**: Public domain
- **Custom**: "Free for personal use with Dune Awakening Companion"

---

## 🚀 Future: Built-in Sound Support

If there's demand, future versions could include:
1. In-app sound pack download (one-click from Settings)
2. Sound picker UI to choose between installed sounds
3. Preview button to hear sounds before selecting
4. Custom sound upload from device

For now, the optional download keeps the app lightweight.

---

*Last Updated: December 24, 2025*

