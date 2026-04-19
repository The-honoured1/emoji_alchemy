import json
import random

def generate_data():
    # Base emojis
    base = ["💧", "🔥", "🌍", "💨"]
    
    # Pool of emojis across different categories
    nature = ["🌱", "🌳", "🌿", "🏜️", "🌾", "🌸", "🌻", "🌲", "🌵", "🍄", "🍁", "🍂", "🍃"]
    fauna = ["🐻", "🦁", "🐯", "🐱", "🐶", "🐺", "🦊", "🦝", "🐮", "🐷", "🐭", "🐹", "🐰", "🐻‍❄️", "🐨", "🐼", "🐸", "🐉", "🦖", "🦕", "🐢", "🐍", "🦎", "🐙", "🦑", "🦐", "🦞", "🦀", "🐡", "🐠", "🐟", "🐬", "🐳", "🐋", "🦈", "🐊", "🐅", "🐆", "🦓", "🦍", "🦧", "🐘", "🦛", "🦏", "🐪", "🐫", "🦒", "🦘", "🐃", "🐂", "🐄", "🐎", "🐖", "🐏", "🐑", "🐐", "🦌", "🐕", "🐩", "🐈", "🐓", "🦃", "🦚", "🦜", "🦢", "🕊️", "🐇", "🦝", "🦨", "🦥", "🦦", "🦫", "🦘", "🦡"]
    space = ["☀️", "🌙", "⭐", "🪐", "🌠", "🌌", "🌍", "🌎", "🌏", "☄️", "🛸", "🚀", "🛰️", "🔭"]
    weather = ["🌫️", "🌬️", "🌀", "🌈", "⛈️", "🌩️", "🌨️", "🌧️", "🌦️", "☁️", "🌤️", "🌥️"]
    items = ["⚒️", "🛠️", "⚙️", "🕰️", "💎", "⚖️", "🗡️", "🛡️", "🏹", "🔮", "🪄", "🪔", "🕯️", "📖", "📜", "📂", "🔋", "💡", "🔦", "💻", "🖱️", "🖥️", "📱", "📻", "📺", "📷", "📽️", "🎬", "🎭", "🎨", "🧵", "🧶"]
    food = ["🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍈", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝", "🍅", "🍆", "🥑", "🥦", "🥬", "🥒", "🌽", "🥕", "🧄", "🧅", "🥔", "🥐", "🍞", "🌭", "🍔", "🍟", "🍕"]
    
    all_emojis = list(set(base + nature + fauna + space + weather + items + food))
    
    # Expand with more random emojis if needed
    current_count = len(all_emojis)
    target_emojis = 250 # Enough to get > 10,000 combinations
    
    start_code = 0x1F300
    while len(all_emojis) < target_emojis:
        new_emoji = chr(start_code)
        if new_emoji not in all_emojis:
            all_emojis.append(new_emoji)
        start_code += 1

    # Hand-crafted logical base recipes (seed)
    recipes = {
        "💧,🔥": "💨",
        "💧,🌍": "🌱",
        "🔥,🌍": "🌋",
        "💨,🌍": "🌪️",
        "💧,💧": "🌊",
        "🔥,🔥": "☀️",
        "🌍,🌍": "⛰️",
        "💨,💨": "🌬️",
        "🌱,💧": "🌳",
        "🌱,🔥": "🍂",
        "🌍,💨": "🏜️",
        "🌊,🔥": "🌫️",
        "🌩️,🌍": "💎",
        "🌞,🌧️": "🌈",
        "☁️,⚡": "⛈️",
        "🧊,🔥": "💧",
        "🌱,🌱": "🌿",
        "🌳,🌳": "🌲",
        "💨,🔥": "⚡",
    }

    # Procedurally generate the rest to reach 10,000+
    print(f"Generating combinations for {len(all_emojis)} emojis...")
    
    # Use a set to track combinations (sorted pair to ensure commutativity)
    recipe_keys = set()
    for k in recipes.keys():
        recipe_keys.add(tuple(sorted(k.split(","))))

    attempts = 0
    while len(recipes) < 10000 and attempts < 1000000:
        a = random.choice(all_emojis)
        b = random.choice(all_emojis)
        pair = tuple(sorted([a, b]))
        
        if pair not in recipe_keys:
            # Pick a "result" that feels somewhat related or just random if needed
            # For massive expansion, we'll pick a random one from the pool
            # but favor later ones in the list to encourage progression
            result = random.choice(all_emojis)
            recipes[f"{pair[0]},{pair[1]}"] = result
            recipe_keys.add(pair)
        attempts += 1

    data = {
        "base_emojis": base,
        "recipes": recipes,
        "all_emojis": all_emojis # For metadata/names mapping if needed
    }

    with open('assets/game_data.json', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print(f"Success! Generated {len(recipes)} recipes.")

if __name__ == "__main__":
    generate_data()
