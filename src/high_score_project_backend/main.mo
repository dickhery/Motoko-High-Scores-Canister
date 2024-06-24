import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";

actor {
  stable var highScores: [(Principal, Text, Int)] = [];

  public query func getHighScores(): async [(Principal, Text, Int)] {
    return highScores;
  };

  public shared(msg) func addHighScore(name: Text, score: Int): async Bool {
    let caller: Principal = msg.caller;
    let newScore: (Principal, Text, Int) = (caller, name, score);
    highScores := Array.append(highScores, [newScore]);
    if (Array.size(highScores) > 5) {
      highScores := removeLowestScore(highScores);
    };
    return true;
  };

  // Helper function to remove the lowest score
  func removeLowestScore(scores: [(Principal, Text, Int)]): [(Principal, Text, Int)] {
    var minIndex: Int = 0;
    var minScore: Int = scores[0].2;
    for (i in Iter.range(1, Array.size(scores) - 1)) {
      if (scores[i].2 < minScore) {
        minScore := scores[i].2;
        minIndex := i;
      };
    };
    // Create a new array without the lowest score
    var newScores: [(Principal, Text, Int)] = [];
    for (i in Iter.range(0, Array.size(scores) - 1)) {
      if (i != minIndex) {
        newScores := Array.append(newScores, [scores[i]]);
      };
    };
    return newScores;
  };

  public shared(msg) func resetHighScores(): async () {
    highScores := [];
  };
};
