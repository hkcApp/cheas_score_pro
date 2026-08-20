import 'package:flutter/material.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  static const Color dotColor = Color(0xFF1565C0);
  static const Color bamColor = Color(0xFF2E7D32);
  static const Color chrColor = Color(0xFFB71C1C);

  static const Color eastColor = Color(0xFF1565C0);
  static const Color southColor = Color(0xFF2E7D32);
  static const Color westColor = Color(0xFFB71C1C);
  static const Color northColor = Color(0xFF6A1B9A);

  static const Color redDragonColor = Color(0xFFD32F2F);
  static const Color greenDragonColor = Color(0xFF2E7D32);
  static const Color whiteDragonColor = Color(0xFF616161);

  Color _tileColor(String text) {
    if (text.contains('筒')) return dotColor;
    if (text.contains('索')) return bamColor;
    if (text.contains('萬')) return chrColor;

    if (text.contains('東')) return eastColor;
    if (text.contains('南')) return southColor;
    if (text.contains('西')) return westColor;
    if (text.contains('北')) return northColor;

    if (text.contains('中')) return redDragonColor;
    if (text.contains('發')) return greenDragonColor;
    if (text.contains('白')) return whiteDragonColor;

    return Colors.black87;
  }

  TextSpan _text(
    String text, {
    FontWeight weight = FontWeight.normal,
    double size = 15,
  }) {
    return TextSpan(
      text: text,
      style: TextStyle(
        fontSize: size,
        color: Colors.black87,
        fontWeight: weight,
        height: 1.4,
      ),
    );
  }

  TextSpan _tile(
    String text, {
    FontWeight weight = FontWeight.normal,
  }) {
    return TextSpan(
      text: text,
      style: TextStyle(
        fontSize: 15,
        color: _tileColor(text),
        fontWeight: weight,
        height: 1.4,
      ),
    );
  }

  Widget _richText(List<TextSpan> spans) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: RichText(
        softWrap: true,
        text: TextSpan(children: spans),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 18,
        bottom: 8,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _subsectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 5,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _bullet(List<TextSpan> spans) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        bottom: 7,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 15,
              height: 1.4,
            ),
          ),
          Expanded(
            child: RichText(
              softWrap: true,
              text: TextSpan(children: spans),
            ),
          ),
        ],
      ),
    );
  }

  Widget _numbered(
    String number,
    List<TextSpan> spans,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        bottom: 7,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$number.',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
          ),
          Expanded(
            child: RichText(
              softWrap: true,
              text: TextSpan(children: spans),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox({
    required String title,
    required List<TextSpan> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        top: 4,
        bottom: 10,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          RichText(
            softWrap: true,
            text: TextSpan(children: children),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Play'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            16,
            4,
            16,
            24,
          ),


          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            _richText([
              _text(
                'This guide explains the basic flow of Chinese Mahjong for a new '
                'player. Follow the sections in order: set up the game, deal the '
                'tiles, play each turn, claim discarded tiles when allowed, and '
                'learn how to declare Mahjong.',
              ),
            ]),

            // -----------------------------------------------------------
            // 1. GAME SETUP
            // -----------------------------------------------------------

            _sectionTitle('1. Game Setup'),

            _richText([
              _text(
                'Chinese Mahjong is normally played by four players. '
                'Each player has a designated Wind position:',
              ),
            ]),

            _bullet([
              _tile('東'),
              _text(' East — Dealer'),
            ]),

            _bullet([
              _tile('南'),
              _text(' South'),
            ]),

            _bullet([
              _tile('西'),
              _text(' West'),
            ]),

            _bullet([
              _tile('北'),
              _text(' North'),
            ]),

            _richText([
              _text(
                'East (東) is always the Dealer.',
                weight: FontWeight.bold,
              ),
            ]),

            // -----------------------------------------------------------
            // 1.1 BUILD THE WALLS
            // -----------------------------------------------------------

            _subsectionTitle('1.1 Build the Walls'),

            _richText([
              _text(
                'You will use all 144 tiles, including:',
              ),
            ]),

            _bullet([
              _text('108 suited tiles — Dots, Bamboo, Characters'),
            ]),

            _bullet([
              _text('16 Wind tiles — '),
              _tile('東'),
              _text(' East, '),
              _tile('南'),
              _text(' South, '),
              _tile('西'),
              _text(' West, '),
              _tile('北'),
              _text(' North'),
            ]),

            _bullet([
              _text('12 Dragon tiles — '),
              _tile('中'),
              _text(' Red Dragon, '),
              _tile('發'),
              _text(' Green Dragon, '),
              _tile('白'),
              _text(' White Dragon'),
            ]),

            _bullet([
              _text('8 Flower tiles — Flowers & Seasons'),
            ]),

            _richText([
              _text(
                'Each player builds one wall in front of themselves.',
              ),
            ]),

            _bullet([
              _text('18 columns long'),
            ]),

            _bullet([
              _text('2 tiles high'),
            ]),

            _bullet([
              _text('36 tiles total'),
            ]),

            _richText([
              _text(
                'Four walls together = 144 tiles.',
                weight: FontWeight.bold,
              ),
            ]),

            _richText([
              _text(
                'All tiles remain face down. The four walls form a square '
                'around the center of the table.',
              ),
            ]),

            // -----------------------------------------------------------
            // 1.2 DETERMINE THE DEALER
            // -----------------------------------------------------------

            _subsectionTitle('1.2 Determine the Dealer — East Wind'),

            _richText([
              _text(
                'The player who becomes '),
              _tile('東'),
              _text(
                ' East is the Dealer.',
                weight: FontWeight.bold,
              ),
            ]),

            _richText([
              _text('Choose East using one of the two methods:'),
            ]),

            _richText([
              _text(
                'Method A — Dice',
                weight: FontWeight.bold,
              ),
            ]),

            _numbered('1', [
              _text('Each player rolls two dice.'),
            ]),

            _numbered('2', [
              _text(
                'The player with the highest total becomes '),
              _tile('東'),
              _text(' East, the Dealer.'),
            ]),

            _richText([
              _text(
                'Method B — Wind Tiles',
                weight: FontWeight.bold,
              ),
            ]),

            _numbered('1', [
              _text('Mix the four Wind tiles: '),
              _tile('東'),
              _text(' East • '),
              _tile('南'),
              _text(' South • '),
              _tile('西'),
              _text(' West • '),
              _tile('北'),
              _text(' North.'),
            ]),

            _numbered('2', [
              _text('Place them face down and mix them.'),
            ]),

            _numbered('3', [
              _text('Each player draws one Wind tile.'),
            ]),

            _numbered('4', [
              _text('Whoever draws '),
              _tile('東'),
              _text(' East becomes the Dealer.'),
            ]),

            _richText([
              _text(
                'Seat Order',
                weight: FontWeight.bold,
              ),
            ]),

            _richText([
              _text('Once East is determined, seat the players in this order: '),
              _tile('東'),
              _text(' East → '),
              _tile('南'),
              _text(' South → '),
              _tile('西'),
              _text(' West → '),
              _tile('北'),
              _text(' North'),
            ]),

            _richText([
              _text(
                'This Wind position remains with each player for the current '
                'game and determines the turn order.',
              ),
            ]),

            // -----------------------------------------------------------
            // 1.3 DETERMINE THE STARTING WALL
            // -----------------------------------------------------------

            _subsectionTitle('1.3 Determine the Starting Wall'),

            _richText([
              _text(
                'The Dealer ('),
              _tile('東'),
              _text(
                ' East) rolls two dice again. This roll determines:',
              ),
            ]),

            _numbered('1', [
              _text('Which wall to break.'),
            ]),

            _numbered('2', [
              _text('Where in that wall the dealing begins.'),
            ]),

            _richText([
              _text(
                'Step A — Choose the Wall',
                weight: FontWeight.bold,
              ),
            ]),

            _richText([
              _text('Count the walls in this order: '),
              _tile('東'),
              _text(' East → '),
              _tile('南'),
              _text(' South → '),
              _tile('西'),
              _text(' West → '),
              _tile('北'),
              _text(' North'),
            ]),

            _richText([
              _text(
                'Example: If East rolls 5:',
              ),
            ]),

            _numbered('1', [
              _text('East ('),
              _tile('東'),
              _text(')'),
            ]),

            _numbered('2', [
              _text('South ('),
              _tile('南'),
              _text(')'),
            ]),

            _numbered('3', [
              _text('West ('),
              _tile('西'),
              _text(')'),
            ]),

            _numbered('4', [
              _text('North ('),
              _tile('北'),
              _text(')'),
            ]),

            _numbered('5', [
              _text('East again ('),
              _tile('東'),
              _text(')'),
            ]),

            _richText([
              _text(
                'The East wall is therefore selected.',
                weight: FontWeight.bold,
              ),
            ]),

            _richText([
              _text(
                'Step B — Choose the Starting Column',
                weight: FontWeight.bold,
              ),
            ]),

            _richText([
              _text(
                'On the selected wall, count the number rolled from right to left. '
                'The column you land on is the breaking point.  Seperate that section '
                'to be used as Flower replacement tiles.  Dealing begins after this '
                'breaking point.',
              ),
            ]),

            // -----------------------------------------------------------
            // 1.4 DEAL THE TILES
            // -----------------------------------------------------------

            _subsectionTitle('1.4 Deal the Tiles'),

            _richText([
              _text(
                'Tiles are dealt in rounds of four, moving around the table in this order: '),
              _tile('東'),
              _text(' East → '),
              _tile('南'),
              _text(' South → '),
              _tile('西'),
              _text(' West → '),
              _tile('北'),
              _text(' North.'),
            ]),

            _richText([
              _text(
                'Dealing Sequence',
                weight: FontWeight.bold,
              ),
            ]),

            _numbered('1', [
              _text('First round: each player takes 4 tiles.'),
            ]),

            _numbered('2', [
              _text('Second round: each player takes 4 tiles.'),
            ]),

            _numbered('3', [
              _text('Third round: each player takes 4 tiles.'),
            ]),

            _richText([
              _text(
                'At this point, everyone has 12 tiles.',
              ),
            ]),

            _richText([
              _text('Then:'),
            ]),

            _bullet([
              _text('Each player takes 1 more tile → 13 tiles.'),
            ]),

            _bullet([
              _text('East ('),
              _tile('東'),
              _text(
                '), the Dealer, takes one extra tile → 14 tiles.',
              ),
            ]),

            _richText([
              _text(
                'East starts with 14 tiles because East plays first.',
                weight: FontWeight.bold,
              ),
            ]),

            // -----------------------------------------------------------
            // 1.5 EXCHANGE FLOWER TILES
            // -----------------------------------------------------------

            _subsectionTitle('1.5 Exchange Flower Tiles'),

            _richText([
              _text(
                'Before normal play begins, players must replace any Flower tiles '
                'in their hands.',
              ),
            ]),

            _richText([
              _text(
                'Flower replacement begins with: ',
              ),
              _tile('東'),
              _text(' East → '),
              _tile('南'),
              _text(' South → '),
              _tile('西'),
              _text(' West → '),
              _tile('北'),
              _text(' North'),
            ]),

            _numbered('1', [
              _text(
                'Place the Flower tile face up in the Flower area.',
              ),
            ]),

            _numbered('2', [
              _text(
                'Draw a replacement tile from the designated back end of the wall.',
              ),
            ]),

            _numbered('3', [
              _text(
                'If the replacement tile is also a Flower, place it face up and '
                'draw another replacement tile.',
              ),
            ]),

            _numbered('4', [
              _text(
                'Continue until you draw a non-Flower tile.',
              ),
            ]),

            _richText([
              _text(
                'Continue until all players have no Flower tiles remaining in '
                'their hands. Once the Flower exchange is complete, normal play begins.',
              ),
            ]),

            // -----------------------------------------------------------
            // 2. PLAYING THE GAME
            // -----------------------------------------------------------

            _sectionTitle('2. Playing the Game'),

            // -----------------------------------------------------------
            // 2.1 TURN ORDER
            // -----------------------------------------------------------

            _subsectionTitle('2.1 Turn Order'),

            _richText([
              _text('Play proceeds in this order: '),
              _tile('東'),
              _text(' East → '),
              _tile('南'),
              _text(' South → '),
              _tile('西'),
              _text(' West → '),
              _tile('北'),
              _text(' North → '),
              _tile('東'),
              _text(' East.'),
            ]),

            _richText([
              _text(
                'East ('),
              _tile('東'),
              _text(
                ') is the Dealer and plays first.',
                weight: FontWeight.bold,
              ),
            ]),

            _richText([
              _text('On your turn:'),
            ]),

            _numbered('1', [
              _text('Draw one tile.'),
            ]),

            _numbered('2', [
              _text('Decide whether to keep it.'),
            ]),

            _numbered('3', [
              _text('Discard one tile face up.'),
            ]),

            _numbered('4', [
              _text('Your turn ends.'),
            ]),

            _richText([
              _text('Normally, your hand contains:'),
            ]),

            _bullet([
              _text('13 tiles before drawing.'),
            ]),

            _bullet([
              _text('14 tiles after drawing.'),
            ]),

            _bullet([
              _text('13 tiles again after discarding.'),
            ]),

            _richText([
              _text(
                'A player has 14 tiles when declaring Mahjong.',
                weight: FontWeight.bold,
              ),
            ]),

            // -----------------------------------------------------------
            // 2.2 DRAWING A TILE
            // -----------------------------------------------------------

            _subsectionTitle('2.2 Drawing a Tile'),

            _richText([
              _text(
                'On your turn, draw one tile from the wall. ',
              ),
            ]),

            _richText([
              _text(
                'If the tile you draw is a Flower:',
              ),
            ]),

            _numbered('1', [
              _text('Place the Flower tile face up in the Flower area.'),
            ]),

            _numbered('2', [
              _text(
                'Draw a replacement tile from the designated back end of the wall.',
              ),
            ]),

            _numbered('3', [
              _text(
                'If the replacement is also a Flower, repeat the process.',
              ),
            ]),

            _numbered('4', [
              _text(
                'Once you draw a non-Flower tile, continue your turn normally.',
              ),
            ]),

            // -----------------------------------------------------------
            // 2.3 DISCARDING A TILE
            // -----------------------------------------------------------

            _subsectionTitle('2.3 Discarding a Tile'),

            _richText([
              _text(
                'After drawing, choose one tile to discard.',
              ),
            ]),

            _bullet([
              _text('Place the tile face up in the center of the table.'),
            ]),

            _bullet([
              _text(
                'Clearly announce the tile, for example, “3 Bamboo.”',
              ),
            ]),

            _richText([
              _text(
                'Once a tile has been discarded, other players may claim it '
                'according to the claiming rules before the next player draws.',
              ),
            ]),

            _richText([
              _text(
                'Once discarded, a tile cannot be taken back.',
                weight: FontWeight.bold,
              ),
            ]),

            // -----------------------------------------------------------
            // 2.4 CLAIMING A DISCARD
            // -----------------------------------------------------------

            _subsectionTitle('2.4 Claiming a Discard'),

            _richText([
              _text(
                'A discarded tile may be claimed to complete certain sets.',
              ),
            ]),

            _richText([
              _text(
                'A. Pung — Three of a Kind',
                weight: FontWeight.bold,
              ),
            ]),

            _richText([
              _text(
                'A Pung consists of three identical tiles. You may claim another '
                'player’s discard if it completes a Pung. The Pung must be immediately revealed.',
              ),
            ]),

            _richText([
              _text(
                'B. Kong — Four of a Kind',
                weight: FontWeight.bold,
              ),
            ]),

            _richText([
              _text(
                'There are three ways to form a Kong:',
              ),
            ]),

            _numbered('1', [
              _text(
                'Exposed Kong from a discard — Claim a discard to complete four '
                'identical tiles, reveal the Kong, and draw a supplement tile.',
              ),
            ]),

            _numbered('2', [
              _text(
                'Exposed Kong from your hand — If you already have an exposed Pung '
                'and draw the fourth identical tile, you may add it to the Pung to '
                'form a Kong. Draw a supplement tile.',
              ),
            ]),

            _numbered('3', [
              _text(
                'Concealed Kong — If you have all four identical tiles in your hand, '
                'you may declare a concealed Kong. Reveal the four tiles briefly, turn '
                'them face down, and draw a supplement tile.',
              ),
            ]),

            _richText([
              _text(
                'C. Chow — Three consecutive tiles '
                'in the Same Suit',
                weight: FontWeight.bold,
              ),
            ]),

            _richText([
              _text(
                'A Chow consists of three consecutive numbered tiles in the same suit.  '
                'Only the next player in turn (player on the right of the discarder) '
                'may claim a discarded tile to form a Chow.  '
                'The Chow must be immediately revealed.',
              ),
            ]),

            _infoBox(
              title: 'Priority Rules',
              children: [
                _text(
                  'If multiple players want the same discarded tile:',
                ),
                const TextSpan(text: '\n'),
                _text(
                  '1. Mahjong has the highest priority.\n'
                  '2. Pung/Kong has priority over Chow.\n'
                  '3. Chow can only be claimed by the next player in turn order.',
                  weight: FontWeight.bold,
                ),
              ],
            ),

            // -----------------------------------------------------------
            // 2.5 FORMING YOUR HAND
            // -----------------------------------------------------------

            _subsectionTitle('2.5 Forming Your Hand'),

            _richText([
              _text(
                'A standard Mahjong hand normally contains:',
              ),
            ]),

            _bullet([
              _text('4 sets — Pung, Chow, Kong or one of the 12 '
              'patterns in the Game Rules.'),
            ]),

            _bullet([
              _text('1 pair — two identical tiles'),
            ]),

            _richText([
              _text(
                'This produces a normal winning hand of 14 tiles.',
                weight: FontWeight.bold,
              ),
            ]),

            _richText([
              _text(
                'East begins the game with 14 tiles because East is the Dealer and '
                'plays first. All other players normally have 13 tiles until they draw.',
              ),
            ]),

            // -----------------------------------------------------------
            // 2.6 DECLARING MAHJONG
            // -----------------------------------------------------------

            _subsectionTitle('2.6 Declaring Mahjong'),

            _richText([
              _text(
                'You may declare Mahjong when:',
              ),
            ]),

            _bullet([
              _text('Your hand contains 4 sets + 1 pair.'),
            ]),

            _bullet([
              _text('You have 14 tiles.'),
            ]),

            _bullet([
              _text(
                'Your hand qualifies for one of the 12 approved Patterns in the Game Rules.',
              ),
            ]),

            _richText([
              _text('You can win in two ways:'),
            ]),

            _richText([
              _text(
                'A. Self-Draw — 自摸 (Zimo)',
                weight: FontWeight.bold,
              ),
            ]),

            _richText([
              _text(
                'You draw the winning tile yourself from the wall.',
              ),
            ]),

            _richText([
              _text(
                'B. Claiming a Discard',
                weight: FontWeight.bold,
              ),
            ]),

            _richText([
              _text(
                'Another player discards the tile you need to complete your winning hand, '
                'and you claim it.',
              ),
            ]),

            _richText([
              _text(
                'When you declare Mahjong:',
                weight: FontWeight.bold,
              ),
            ]),

            _numbered('1', [
              _text('Announce “Mahjong!”'),
            ]),

            _numbered('2', [
              _text('Reveal your entire hand face up.'),
            ]),

            _numbered('3', [
              _text('Scoring begins according to the Game Rules.'),
            ]),

            // -----------------------------------------------------------
            // 2.7 END OF THE ROUND
            // -----------------------------------------------------------

            _subsectionTitle('2.7 End of the Round'),

            _richText([
              _text(
                'A hand ends when:',
              ),
            ]),

            _bullet([
              _text('A player declares Mahjong.'),
            ]),

            _bullet([
              _text(
                'The wall runs out of tiles and nobody has won — a draw.',
              ),
            ]),

            _richText([
              _text(
                'Dealer Rotation',
                weight: FontWeight.bold,
              ),
            ]),

            _richText([
              _text('If '),
              _tile('東'),
              _text(
                ' East wins, East remains the Dealer for the next hand.',
              ),
            ]),

            _richText([
              _text('If another player wins, the Dealer rotates in this order: '),
              _tile('東'),
              _text(' East → '),
              _tile('南'),
              _text(' South → '),
              _tile('西'),
              _text(' West → '),
              _tile('北'),
              _text(' North → '),
              _tile('東'),
              _text(' East.'),
            ]),

            // -----------------------------------------------------------
            // 2.8 BASIC TABLE ETIQUETTE
            // -----------------------------------------------------------

            _subsectionTitle('2.8 Basic Table Etiquette — Beginner Essentials'),

            _bullet([
              _text(
                'Keep your tiles organized and hidden from the other players.',
              ),
            ]),

            _bullet([
              _text(
                'Keep the Wind positions clear: '),
              _tile('東'),
              _text(' East, '),
              _tile('南'),
              _text(' South, '),
              _tile('西'),
              _text(' West, and '),
              _tile('北'),
              _text(' North.'),
            ]),

            _bullet([
              _text(
                'Remember that '),
              _tile('東'),
              _text(' East is the Dealer.'),
            ]),

            _bullet([
              _text('Announce your discards clearly.'),
            ]),

            _bullet([
              _text(
                'Do not touch the wall except when drawing or performing an allowed '
                'supplement draw.',
              ),
            ]),

            _bullet([
              _text(
                'When claiming a discard, speak up immediately.',
              ),
            ]),

            _bullet([
              _text(
                'Once a tile has been discarded, it cannot be taken back.',
              ),
            ]),

            _bullet([
              _text(
                'Keep exposed Pungs, Chows, and Kongs clearly separated from your '
                'concealed tiles.',
              ),
            ]),
          ],
        ),
      ),
      ),
    );
  }
}
