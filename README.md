# Blood on the Clocktower App releases

[You can find the latest app version downloads here.](https://github.com/ThePandemoniumInstitute/botc-release/releases)

If you encounter a bug or want to suggest a new feature, feel free to [open a ticket!](https://github.com/ThePandemoniumInstitute/botc-release/issues/new/choose)

Depending on your operating system, you have to select the correct file:
- **Windows:** Blood-on-the-Clocktower-App-Setup-[version].exe
- **Mac:** Blood-on-the-Clocktower-App-[version].dmg
- **Linux:** Blood-on-the-Clocktower-App-[version].AppImage

## Custom scripts
Your custom (and homebrew) scripts can be augmented with "meta data" to improve the play experience and make it easier for your players to see what script exactly is being played. In order to do this, just add a `meta` entry to your custom script JSON, with the following (optional) properties:

```json
  {
    "id": "_meta",
    "name": "Your Custom Script Name",
    "author": "Your Name",
    "logo": "https://i.imgur.com/logo.png",
    "background": "https://i.imgur.com/background-image.jpg"
  }
```

## Homebrew scripts
If you're interested in creating your own "homebrew" scripts or characters, there's a [JSON Schema available](script-schema.json) which will give you an idea about how your JSON should look like, in order to be supported by the app. You can also use this schema to validate your JSON file. Here's an example of how a character might be defined:

```json
{
  "id": "widow",
  "name": "Widow",
  "edition": "experimental",
  "image": [
    "https://i.imgur.com/widow.png",
    "https://i.imgur.com/widow_good.png"
  ],
  "team": "minion",
  "firstNight": 22,
  "firstNightReminder": "Show the Grimoire for as long as the Widow needs. The Widow chooses a player. :reminder:",
  "otherNight": 0,
  "otherNightReminder": "",
  "reminders": ["Poisoned"],
  "remindersGlobal": ["Knows"],
  "setup": false,
  "ability": "On your 1st night, look at the Grimoire and choose a player: they are poisoned. 1 good player knows a Widow is in play.",
  "special": [
    {
      "name": "grimoire",
      "type": "signal",
      "time": "night"
    }
  ],
  "jinxes": [
    {"id": "alchemist", "reason": "The Alchemist can not have the Widow ability."},
    {"id": "magician", "reason": "When the Widow sees the Grimoire, the Demon and Magician's character tokens are removed."},
    {"id": "poppygrower", "reason": "If the Poppy Grower is in play, the Widow does not see the Grimoire until the Poppy Grower dies."},
    {"id": "damsel", "reason": "Only 1 jinxed character can be in play."},
    {"id": "heretic", "reason": "Only 1 jinxed character can be in play."}
  ]
}
```
Note that most of these properties are optional and in fact a few of them (`jinxes`, `special`) will very rarely, if ever, be needed for Homebrew content and might be subject to change.
