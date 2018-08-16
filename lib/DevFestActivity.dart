class DevFestActivity {
  String id;
  String title;
  String desc;
  String cover;
  String day;
  DateTime start;
  DateTime end;
  String type;
  String speakers = "-1";
  String abstract;
  String location;

  DevFestActivity.generic(this.id, this.type, this.title, this.desc, this.cover, this.location, this.day,
      this.start, this.end, this.abstract);

  DevFestActivity(this.id, this.type, this.title, this.desc, this.cover, this.location, this.day,
      this.start, this.end, this.speakers, this.abstract);
}
