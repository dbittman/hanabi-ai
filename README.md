hanabi-ai
=========

An AI written to play the card game Hanabi

Written by Daniel Bittman and Nicholas Wold (github.com/nicholaswold)

# A.I. Notes

When I play (not great, but decent), here's my thought process:
  * Check each of my teammates
    * Do they have a move?
      * If so, then pass
      * If not, then consider what clues I can give them...
        * Can I give them a move? (Best) [the more moves a clue can give them the better]
        * Can I prevent them from making a bad move? (Also good) [typically means i don't want them to discard a five]
  * Store all of these potential clues in my brain-databank of moviness.
  * Now check what I know about my hand
    * Can I play a card and get points? (Best)
