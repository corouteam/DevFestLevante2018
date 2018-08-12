class DevFestActivity {
  String id;
  String title;
  String desc;
  String day;
  DateTime start;
  DateTime end;
  String type;
  String speakers = "-1";

  DevFestActivity.generic(this.id, this.type, this.title, this.desc, this.day,
      this.start, this.end);

  DevFestActivity(this.id, this.type, this.title, this.desc, this.day,
      this.start, this.end, this.speakers);
}
