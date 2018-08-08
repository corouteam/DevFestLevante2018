class DevFestActivity {
  final String id;
  final String title;
  final String desc;
  final String day;
  final DateTime start;
  final DateTime end;
  final String type;
  final String speakers;

  DevFestActivity.generic(this.id, this.type, this.title, this.desc, this.day,
      this.start, this.end);

  DevFestActivity(this.id, this.type, this.title, this.desc, this.day,
      this.start, this.end, this.speakers);
}
