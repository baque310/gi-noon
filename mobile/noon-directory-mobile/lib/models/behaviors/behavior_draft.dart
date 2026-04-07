class BehaviorDraft {
  final Map<String, int> ratings;
  String notes;

  BehaviorDraft({required this.ratings, this.notes = ''});

  factory BehaviorDraft.empty() {
    return BehaviorDraft(ratings: {});
  }

  BehaviorDraft copy() {
    return BehaviorDraft(ratings: Map.from(ratings), notes: notes);
  }
}
