class Event {
  final String title;

  Event(this.title);

  // Convert Event to JSON
  Map<String, dynamic> toJson() {
    return {'title': title};
  }

  // Create Event from JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(json['title']);
  }
}
