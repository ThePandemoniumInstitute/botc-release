# Blood on the Clocktower App releases

[You can find the latest app version downloads here.](https://github.com/ThePandemoniumInstitute/botc-release/releases)

If you encounter a bug or want to suggest a new feature, feel free to [open a ticket!](https://github.com/ThePandemoniumInstitute/botc-release/issues/new/choose)

Depending on your operating system, you have to select the correct file:
- **Windows:** Blood.on.the.Clocktower.Online_[version]_x64-setup.exe
- **Mac (M1 or newer):** Blood.on.the.Clocktower.Online_[version]_aarch64.dmg
- **Mac (Intel):** Blood.on.the.Clocktower.Online_[version]_x64.dmg
- **Linux:** _currently not supported_ (check [this](https://bugs.webkit.org/show_bug.cgi?id=235885) and [this](https://github.com/tauri-apps/wry/issues/85) issue for progress)

## Custom scripts
Your custom (and homebrew) scripts can be augmented with "meta data" to improve the play experience and make it easier for your players to see what script exactly is being played. In order to do this, just add a `meta` entry to your custom script JSON, with the following (optional) properties:

```json
  {
    "id": "_meta",
    "name": "Your Custom Script Name",
    "author": "Your Name",
    "logo": "https://i.imgur.com/logo.png",
    "hideTitle": false,
    "background": "https://i.imgur.com/background-image.jpg",
    "almanac": "https://almanac.example/script.html",
    "bootlegger": ["Your custom bootlegger rule"],
    "firstNight": ["dusk","minioninfo", "demoninfo","poisoner","...","dawn"],
    "otherNight": ["dusk","poisoner","...","dawn"]
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

### Special App Features

Homebrew characters can use some of the app features through the `special` property, which contains an array of each special app feature that this character will use.
Each of these `special` features requires a `type` and `name` property, at the very least. Some of them also need a `value`, `time` or `global` property or any combination of them.
The available special app features are listed below, grouped by their `type`.

#### Type: `selection`

This type modifies how the character selection process at the beginning of the game works.

- **Name: `bag-disabled`:** This character can't be selected to go into the bag. (to be distributed to the players) <br>**Example:** Drunk, Marionette
- **Name: `bag-duplicate`:** This character can be added more than once to the bag. (to be distributed to the players) <br>**Example:** Legion, Riot
- **Name: `good-duplicate`:** This character allows any good character to be added more than once to the bag. If it's on an NPC in play, it also allows duplicate bluffs. <br>**Example:** Atheist, Pope

#### Type: `ability`

This type allows the Storyteller to activate a special character ability, like returning all ghost vote tokens or allowing players to point at another player.
All abilities can be modified by the `time` and `global` parameters.

- **Name: `pointing`:** Starts a "point at a player" type of special vote, which allows some or all players to democratically choose a player. <br>**Example:** Boomdandy, Fiddler
- **Name: `ghost-votes`:** This ability returns all spent ghost votes to dead players. <br>**Example:** Ferryman
- **Name: `distribute-roles`:** This ability sends out the currently assigned characters to all players. <br>**Example:** Gardener

#### Type: `player`

This type allows the player with the associated character to use a special action. It is meant to be used independently from the Storyteller. These abilities can be modified by the `time` parameter.

- **Name: `open-eyes`:** Lets the player with this character open their eyes at night. (assuming `time: "night"` is used in combination with this) The player can either fully open their eyes or have them half open (called 'peeking') with different effects. Fully opened eyes will allow the player to see all night informations that are being sent, while posing a small risk to be discovered by the player that has received the night signal. Opening their eyes only half-way allows them to see _who_ received the night signal, but not the content. Both modes also allow the player to send and receive private text messages to any non-neighbouring player. <br>**Example:** Wraith

#### Type: `signal`

This type allows the Storyteller to send a player special information through the night "wake" interface.
Can be modified by the `time` parameter.

- **Name: `grimoire`:** Send a copy of the Grimoire to the player. The grimoire copy can be modified before being sent. <br>**Example:** Spy, Widow
- **Name: `card`:** Send a pre-defined custom Storyteller card to a player with this character. Requires a `value` to contain the card text.
- **Name: `player`:** Allows a player with this character to send a pre-defined custom response to the Storyteller. Requires a `value` to contain the response text.

#### Type: `vote`

This type modifies how the nomination or vote is being run.

- **Name: `hidden`:** The vote will be run in secret. (only the Storyteller can see the results) <br>**Example:** Organ Grinder
- **Name: `multiplier`:** Assigning any reminder token of this character to a player will modify their vote count with a multiplier. Requires a `value` to define the multiplier. <br>**Example:** Bureaucrat, Thief

#### Type: `reveal`

This type modifies what happens when the game ends, right before the character reveal.

- **Name: `replace-character`:** Assigning the _first `remindersGlobal` reminder token_ (e.g. "Is the Philosopher") to a player will replace their current character with this one when the game ends.  <br>**Example:** Drunk, Philosopher

#### Optional properties: `time`, `value`, `global`

- **Property `time`:** This property limits when a specific ability or effect can be used. Currently only works on `ability` and `signal` type of effects. Possible values:
  - "pregame"
  - "day"
  - "night"
  - "firstNight"
  - "firstDay"
  - "otherNight"
  - "otherDay"
- **Property `value`:** Can be a Number or String that is used as a parameter for a special ability or effect.
- **Property `global`:** An awkward compromise to allow Lil'Monsta to work when it is not in play. Currently defines what kind of characters have the special ability as long as this character is on the script. I'd probably not use this if I were you, because it might be subject to change if I can think of a better way to make Lil'Monsta work. Can contain any character type value ("townsfolk", "outsider", "minion", "demon", "traveller") or the special value "dead" which allows all dead players to pick.
