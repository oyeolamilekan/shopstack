class Analytics {
  var dataSet;
  var daySet;

  Analytics({this.dataSet, this.daySet});

  Analytics.fromJson(Map<String, dynamic> json) {
    dataSet = json['data_set'];
    daySet = json['day_set'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data_set'] = this.dataSet;
    data['day_set'] = this.daySet;
    return data;
  }
}

class LinearClicks {
  String day;
  int clicks;

  LinearClicks(this.day, this.clicks);
}