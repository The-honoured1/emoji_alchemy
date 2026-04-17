class RecipeManager {
  static const Map<String, List<String>> categories = {
    "Elements": ["🔥", "💧", "🌍", "💨", "🌫️", "🌋", "🌊", "☀️", "⛰️", "🌧️", "☄️", "⛈️", "🌈", "🌀", "🏔️", "🌪️", "🗻", "🧊", "🪨"],
    "Nature": ["🌱", "🌳", "🌿", "🏜️", "🌾", "🌸", "🍯", "🧸", "🦋", "🦅", "🦖", "🦕", "🦠", "🧬", "🕸️", "🌵", "🐪", "🐟", "🦈", "🐋", "🐸", "🐚", "🌲", "🌻", "🍌", "🦍"],
    "Life": ["👶", "👦", "👨", "👩", "👴", "👵", "💀", "🧟", "🧛", "🧜", "🧚", "👼", "👻", "🐵", "🦁", "🦊", "🐶", "🐱", "🐭", "🐔", "🐣", "🐥", "🧠", "🦖", "👰", "🤵", "🏇", "👨‍🚀", "Alien", "🛸"],
    "Food": ["🥛", "🍦", "🥣", "Bread", "🥪", "🍖", "🍗", "🍟", "🍕", "🤮", "🍷", "🥳", "🥧", "😋", "🍿", "🍫", "🍱", "🍎", "🍇", "🧀", "🥚", "🍔", "🥤", "🧋", "🍨", "🍾", "🍣", "🍩", "🧁", "🥓", "🍳"],
    "Tech": ["💻", "🖱️", "🖥️", "🎮", "📱", "📶", "🌐", "🚀", "👨‍🚀", "🛸", "🪐", "🛰️", "🔭", "🔋", "🔦", "🤖", "🦾", "👾", "📡", "📸", "🤳", "🔒", "🔓", "🎞️", "💾", "💿", "📻", "🔊", "📢", "🔌"],
    "Tools": ["🪓", "🪵", "🔨", "🛠️", "🔧", "🧱", "🏠", "🏘️", "🏙️", "🏰", "⚓", "🚢", "🚗", "🏎️", "🏆", "🥇", "🥈", "🥉", "🔫", "🎖️", "🚒", "🚑", "⚕️", "⚙️", "🏗️", "🗽", "🏢", "🛩️", "⛵", "🛥️", "⚔️", "🛡️", "🏹", "🎯", "⚓", "🛠️", "🪑", "🛋️", "🛠️", "⚙️", "⚒️", "🛠️"],
    "Magic": ["🪄", "🧙", "🧙‍♂️", "🔮", "✨", "👑", "👸", "🤴", "💍", "💎", "👹", "👺", "🦄", "🐉", "🐲", "⚗️", "✨", "🪄", "🔮"],
    "Misc": ["❤️", "💖", "💝", "💔", "🩹", "💡", "💰", "🏦", "⏰", "⌛", "🎭", "🎤", "🎶", "🎵", "💃", "👯", "🎉", "🎂", "🎊", "🎸", "🥁", "⏳", "🤯", "⚖️", "🚓", "🏚️", "🌃", "💸", "📉", "📈", "🌀"]
  };

  static const Map<String, String> clues = {
    "🦖": "A prehistoric lizard that ruled the earth",
    "🚀": "A vessel built to leave our world",
    "🧬": "The code that builds every living thing",
    "🌋": "A mountain that breathes fire",
    "🍦": "A frozen treat made of milk",
    "🤖": "A man made of metal and logic",
    "🐉": "A flying lizard from ancient myths",
    "🏙️": "A forest of steel and stone buildings",
    "💍": "A circle of gold to promise a life",
    "🍣": "Raw fish from the deepest ocean",
  };

  static const Map<String, String> meanings = {
    "🔥": "Intense heat and energy",
    "💧": "Cool fluid and hydration",
    "🌍": "Solid ground and earth",
    "💨": "Invisible air and movement",
    "⏰": "The passing of eternity",
    "🦠": "The smallest unit of existence",
    "🛡️": "A wall to protect the self",
    "⚔️": "A sharp edge of conflict",
    "🧪": "The pursuit of hidden knowledge",
    "🪄": "The power to defy reality",
  };

  static String getEmojiCategory(String emoji) {
    for (var entry in categories.entries) {
      if (entry.value.contains(emoji)) return entry.key;
    }
    return "Misc";
  }

  static const Map<String, String> recipes = {
    // Basic Elements & Nature
    "🔥,💧": "🌫️",
    "🌍,🌱": "🌳",
    "⚡,🧠": "🤯",
    "🐱,🐟": "😋",
    "🌫️,❄️": "☁️",
    "🔥,🌍": "🌋",
    "💧,💧": "🌊",
    "🔥,🔥": "☀️",
    "🌍,🌍": "⛰️",
    "🌱,🌱": "🌿",
    "💨,💧": "🌧️",
    "💨,🔥": "☄️",
    "🌍,💧": "🌱",
    "💨,🌍": "🏜️",
    "💨,🌱": "🌾",
    "☀️,🌧️": "🌈",
    "☁️,⚡": "⛈️",
    "⛰️,🔥": "🌋",
    "⛰️,🌊": "岛",
    "🌊,🌊": "🌀",
    "☀️,🌊": "☁️",
    "☁️,☁️": "🌧️",
    "🌊,🌡️": "💨",
    "💨,💨": "🌪️",
    "🌪️,🏠": "🏚️",
    "🌋,💧": "⛰️",
    "⛰️,⛰️": "🏔️",
    "🏔️,☀️": "🌊",
    "🌍,🔥": "🌋",
    "🌍,💨": "🌪️",
    "🧪,🌍": "🧬",
    "🧬,💧": "🦠",
    "🦠,⏰": "🌱",
    "🌱,☀️": "🌸",
    "🌸,🐝": "🍯",
    "🐝,🌸": "🍯",
    "🍯,🐻": "🧸",
    "🥚,🔥": "🐣",
    "🐣,⏰": "🐥",
    "🐥,🌾": "🐔",
    "🐔,🥚": "🐣",
    "🐔,🦊": "💀",
    "🐭,🧀": "🪤",
    "🐱,🐭": "💥",
    "🐶,🦴": "🐕",
    "🧬,🌍": "🦖",
    "🦖,☄️": "💀",
    "🦖,🐦": "🦅",
    "🦄,🌈": "🦋",
    "🦋,🌸": "🎨",
    "🐛,⏰": "🦋",
    "🕷️,🕸️": "🕷️",
    "🕷️,👨": "🦸",
    "🦇,🧛": "🧛",
    "🧛,👨": "🧟",
    "🧟,🧠": "🤯",
    "🐒,⏰": "👨",
    "👨,👩": "👶",
    "👶,⏰": "👦",
    "👦,⏰": "👨",
    "👨,💼": "👔",
    "👔,💻": "👨‍💻",
    "👨,🎓": "👨‍🔬",
    "👨,🍳": "🧑‍🍳",
    "👨,🌾": "👨‍🌾",
    "👨‍🔬,🧪": "🧬",
    "👨,🔨": "👷",
    "👷,🧱": "🏠",
    "🏠,🏠": "🏘️",
    "🏘️,🏘️": "🏙️",
    "🏙️,🌃": "🏙️",
    "🏠,🔥": "🔥",
    "🏠,💧": "🚿",
    "🏠,🌬️": "🪁",
    "🧱,🧱": "🧱",
    "🪵,🪓": "🪵",
    "🪵,🔨": "🪑",
    "🪑,🛋️": "🏠",
    "🔨,🔧": "🛠️",
    "👨,🔬": "👨‍⚕️",
    "👨‍⚕️,💊": "🩹",
    "🩹,🩹": "🏥",
    "👨,🎨": "🎨",
    "👨,💻": "👨‍💻",
    "👨‍💻,💻": "🤖",
    "👨,🏗️": "👷",
    "👷,🏠": "🏘️",
    "🏘️,🏗️": "🏙️",
    "🏙️,🏙️": "🌃",
    "🌾,🍞": "🍞",
    "🍞,🔥": "🥪",
    "🐮,🥛": "🥛",
    "🥛,⏰": "🧀",
    "🧀,🍞": "🍕",
    "🍗,🔥": "🍖",
    "🍖,🍞": "🍔",
    "🍎,🥧": "🥧",
    "🍇,⏰": "🍷",
    "💡,🧠": "🤯",
    "💰,💰": "🏦",
    "🏦,💎": "💰",
    "⏰,🌍": "⌛",
    "⌛,👨": "💀",
    "🎭,🎨": "🎭",
    "🎤,🎶": "🎵",
    "🎵,💃": "👯",
    "👯,🥳": "🎉",
    "🎉,🎂": "🥳",
    "⛰️,🏔️": "🗻",
    "🗻,❄️": "🧊",
    "☀️,🏜️": "🌵",
    "🌵,💧": "🐪",
    "🌊,🌋": "🪨",
    "🪨,🔨": "🗿",
    "🌪️,🌊": "🌀",
    "🌈,✨": "🦄",
    "🦄,💀": "👹",
    "🌊,🦠": "🐟",
    "🐟,🐟": "🦈",
    "🐟,⏰": "🐋",
    "🐟,🌍": "🐸",
    "🐸,⏰": "🦖",
    "🦖,🧬": "🐉",
    "🦖,🦅": "🐲",
    "🦟,🦴": "🦖",
    "🦟,🩸": "🧛",
    "🦇,👨": "🦇",
    "🕸️,👨": "🕷️",
    "🐴,🪄": "🦄",
    "🐑,🐑": "☁️",
    "🐔,🍞": "🥪",
    "🐌,💧": "🐚",
    "🚀,🪐": "🛰️",
    "🛰️,📶": "🌐",
    "🌐,💻": "📡",
    "📡,🌌": "👽",
    "👽,👨": "🛸",
    "🛸,🌌": "🌌",
    "🌑,🪐": "🌕",
    "🚀,🔥": "💥",
    "🛰️,🔭": "🌌",
    "🌌,🌠": "✨",
    "💻,🧠": "🤖",
    "🤖,👨": "🦾",
    "🦾,🧠": "🤖",
    "📱,📶": "🌐",
    "🎮,🖥️": "🕹️",
    "🕹️,⚡": "👾",
    "🔋,⚡": "⚡",
    "💻,🛡️": "🔒",
    "🔒,🔑": "🔓",
    "📱,📷": "🤳",
    "🤳,🌐": "📸",
    "🍦,☕": "🍦",
    "🥣,🥛": "🥣",
    "🍞,🍳": "🍳",
    "🥩,🥖": "🍔",
    "🍔,🍟": "🍟",
    "🍕,🥤": "🥤",
    "🥤,🧊": "🧋",
    "🍫,🍦": "🍨",
    "🍇,🍷": "🍷",
    "🍷,🥳": "🍾",
    "🍾,🎉": "🎊",
    "🍱,🥢": "🍣",
    "🍣,🐟": "🍣",
    "🔨,⚙️": "🛠️",
    "🛠️,🏠": "🏗️",
    "🏗️,🏙️": "🗽",
    "🏙️,🏢": "🏦",
    "🏦,💰": "🤑",
    "🚗,🏎️": "🏁",
    "🏁,🏆": "🥇",
    "🚢,⚓": "🚢",
    "✈️,☁️": "🛩️",
    "🛩️,🚀": "🛸",
    "⚓,🌊": "⛵",
    "⛵,💨": "🛥️",
    "⚓,⚓": "⚓",
    "🧙‍♂️,📖": "🪄",
    "🪄,✨": "🔮",
    "🔮,🌌": "🪐",
    "👸,🤴": "💍",
    "💍,💰": "💎",
    "💎,🔥": "✨",
    "💀,🧟": "🧟",
    "👹,👺": "👺",
    "👻,🕯️": "👻",
    "🕯️,🔥": "💡",
    "💡,💡": "✨",
    "⏰,💀": "⌛",
    "⌛,⏳": "⏰",
    "❤️,🩹": "❤️",
    "💔,🪄": "❤️",
    "🎭,🎶": "🎵",
    "🎤,🎸": "🎸",
    "🎸,🥁": "🎶",
    "🎶,🕺": "💃",
    "💃,🎊": "🎉",
    "⚔️,🛡️": "🎖️",
    "🔫,🧱": "💥",
    "💣,🔥": "💥",
    "💣,🏰": "🏚️",
    "🛡️,🧙": "🔮",
    "⚔️,🧪": "🧪",
    "🚗,⛽": "💨",
    "⛽,🔥": "💥",
    "🚲,⚡": "🏍️",
    "🛶,🌊": "⛵",
    "🛥️,⚡": "🏎️",
    "🚁,🏙️": "🏙️",
    "🛸,🐄": "🥩",
    "🧬,🧪": "🦠",
    "🦠,🔥": "🧪",
    "🔬,🩸": "🧬",
    "🔭,✨": "🌌",
    "🌌,🌑": "🌕",
    "💻,💻": "🖥️",
    "🖥️,🌐": "🌐",
    "📡,👽": "🛸",
    "☀️,🌵": "🏜️",
    "🌊,🏔️": "🧊",
    "🌪️,🌳": "🪵",
    "🪵,🪵": "🪵",
    "🪨,🪨": "⛰️",
    "⛰️,☁️": "🏔️",
    "❤️,💍": "👰",
    "👰,🤵": "💍",
    "🧠,📱": "🤯",
    "🤯,🌌": "🪐",
    "🎭,🎭": "🎭",
  };

  static String? combine(String emoji1, String emoji2) {
    List<String> sorted = [emoji1, emoji2]..sort();
    String key = sorted.join(",");
    
    // 1. Check exact hardcoded recipes
    if (recipes.containsKey(key)) return recipes[key];

    // 2. Smart Synthesis Engine
    final cat1 = getEmojiCategory(emoji1);
    final cat2 = getEmojiCategory(emoji2);

    if (emoji1 == "🔥" || emoji2 == "🔥") {
       if (cat1 == "Nature" || cat2 == "Nature") return "🌫️";
       if (cat1 == "Life" || cat2 == "Life") return "💀";
       if (cat1 == "Food" || cat2 == "Food") return "🍳";
       return "🌋";
    }

    if (emoji1 == "💧" || emoji2 == "💧") {
       if (cat1 == "Nature" || cat2 == "Nature") return "🌱";
       if (cat1 == "Life" || cat2 == "Life") return "👶";
       return "🌊";
    }

    if (emoji1 == "🌍" || emoji2 == "🌍") {
       if (cat1 == "Nature" || cat2 == "Nature") return "⛰️";
       return "🧱";
    }

    if (cat1 == "Tech" && cat2 == "Tech") return "⚙️";
    if (cat1 == "Food" && cat2 == "Food") return "😋";
    if (cat1 == "Nature" && cat2 == "Nature") return "🌲";
    if (cat1 == "Life" && cat2 == "Life") return "🧬";
    if (cat1 == "Magic" || cat2 == "Magic") return "✨";
    if (cat1 == "Tools" || cat2 == "Tools") return "🛠️";
    if (cat1 == "Misc" && cat2 == "Misc") return "🌀";

    if (cat1 == "Tech" || cat2 == "Tech") return "🔋";
    if (cat1 == "Life" || cat2 == "Life") return "🧬";
    
    return "✨";
  }

  static List<String> getStartingEmojis() {
    return ["🔥", "💧", "🌍", "💨"];
  }

  static String? getHint(Set<String> discovered) {
    for (var entry in recipes.entries) {
      List<String> ingredients = entry.key.split(",");
      if (discovered.contains(ingredients[0]) &&
          discovered.contains(ingredients[1]) &&
          !discovered.contains(entry.value)) {
        return "Hint: Try combining ${ingredients[0]} and ${ingredients[1]}!";
      }
    }
    return "Keep experimenting! Every combo produces something.";
  }
}
