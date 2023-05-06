import 'package:flutter/material.dart';
import 'package:yaniv_calculator/file_handler.dart';

class Rules extends StatelessWidget {
  const Rules({super.key});

  static const _rules = [
    'Introduction:',
    '',
    'Yaniv is an exciting and strategic card game that originated in Israel.',
    '',
    'The game is played with a standard deck of 52 cards and can be enjoyed by 2 to 5 players.',
    'The objective of the game is to have the lowest card point value in your hand.',
    'Players must decide whether to draw cards, discard cards, or call "Yaniv" in an effort to end the round with the lowest possible score.',
    'Setup:',
    '',
    '1. Shuffle a standard 52-card deck and deal 5 cards face-down to each player.',
    '2. Place the remaining cards face-down in the center of the table as the draw pile.',
    '3. Turn the top card of the draw pile face-up to create the discard pile.',
    '',
    'Gameplay:',
    '',
    "1. Starting with the player to the dealer's left and proceeding clockwise, each player takes a turn consisting of the following actions:",
    '  a. Draw: A player must either draw the top card from the draw pile or pick up the top card from the discard pile.',
    '  b. Discard: After drawing a card, the player must discard one card from their hand, placing it face-up on top of the discard pile.',
    '',
    '2. Players can call "Yaniv" at the beginning of their turn if the total point value of the cards in their hand is 7 or less. When a player calls "Yaniv," it signals the end of the round.',
    '',
    'Scoring:',
    '',
    '1. When a player calls "Yaniv," all other players reveal their cards, and the point values are calculated. The card values are as follows:',
    '   - Number cards (2-10) are worth their face value.',
    '   - Face cards (J, Q, K) are worth 10 points.',
    '   - Aces (A) are worth 1 point.',
    '',
    '2. If the player who called "Yaniv" has the lowest point total, the other players receive penalty points equal to the point value of the cards in their hand. If another player has an equal or lower point value than the player who called "Yaniv," the caller receives a penalty of 30 points (called an "Assaf") plus the point value of their hand, while the other players receive points equal to their card values.',
    '',
    "3. The game continues for a predetermined number of rounds or until a player's cumulative score reaches a certain threshold (e.g., 100 or 200 points). The player with the lowest total score at the end of the game is the winner.",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._rules
                .map((ruleText) => Flexible(child: Text(ruleText)))
                .toList(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => FileHandler.instance.clear(),
              child: const Text('Clear all data'),
            ),
          ],
        ),
      ),
    );
  }
}
