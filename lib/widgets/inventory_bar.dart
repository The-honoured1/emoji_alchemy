import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/game_controller.dart';
import '../models/emoji_item.dart';
import 'emoji_widget.dart';
import '../logic/recipe_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class InventorySidebar extends StatelessWidget {
  const InventorySidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final discovered = controller.filteredInventory;
    final categories = ["All", ...RecipeManager.categories.keys];

    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: Color(0xFF16161C),
        border: Border(
          right: BorderSide(color: Colors.white10, width: 2),
        ),
      ),
      child: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF23232D),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: TextField(
                onChanged: (v) => controller.setSearchQuery(v),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: "Search emojis...",
                  hintStyle: TextStyle(color: Colors.white24),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.white24, size: 18),
                ),
              ),
            ),
          ),
          
          // Categories
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = controller.selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () => controller.setCategory(cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.purpleAccent : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : Colors.white10,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white38,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          const Divider(color: Colors.white10, height: 24),

          // Meaning Display (If selected)
          if (controller.selectedInventoryEmoji != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purpleAccent.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Text(controller.selectedInventoryEmoji!, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        RecipeManager.meanings[controller.selectedInventoryEmoji!] ?? "A mysterious substance...",
                        style: const TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.selectInventoryEmoji(null),
                      child: const Icon(Icons.close, size: 16, color: Colors.white24),
                    ),
                  ],
                ),
              ),
            ),

          // Grid of Emojis
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: discovered.length,
              itemBuilder: (context, index) {
                final emoji = discovered[index];
                return Draggable<String>(
                  data: emoji,
                  feedback: Material(
                    color: Colors.transparent,
                    child: EmojiWidget(
                      item: EmojiItem(emoji: emoji, id: 'preview'),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      controller.selectInventoryEmoji(emoji);
                      controller.addEmojiToCanvas(emoji, const Offset(400, 300));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF23232D),
                        borderRadius: BorderRadius.circular(12),
                        border: const Border(
                          bottom: BorderSide(color: Color(0xFF121217), width: 3),
                        ),
                      ),
                      child: Center(
                        child: Text(emoji, style: const TextStyle(fontSize: 28)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
