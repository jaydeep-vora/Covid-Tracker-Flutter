class CovidPatientsResponse {
  String message;
  List<StateWiseData> data;
  int code;

  CovidPatientsResponse({this.message, this.data, this.code});

  CovidPatientsResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = new List<StateWiseData>();
      json['data'].forEach((v) {
        data.add(new StateWiseData.fromJson(v));
      });
    }
    code = json['code'];
  }
}

class StateWiseData {
  String deaths,
      active,
      deltadeaths,
      lastupdatedtime,
      statecode,
      deltarecovered;
  String confirmed, statenotes, deltaconfirmed, state, recovered;

  StateWiseData(
      {this.deaths,
      this.active,
      this.deltadeaths,
      this.lastupdatedtime,
      this.statecode,
      this.deltarecovered,
      this.confirmed,
      this.statenotes,
      this.deltaconfirmed,
      this.state,
      this.recovered});

  StateWiseData.fromJson(Map<String, dynamic> json) {
    deaths = json['deaths'];
    active = json['active'];
    deltadeaths = json['deltadeaths'];
    lastupdatedtime = json['lastupdatedtime'];
    statecode = json['statecode'];
    deltarecovered = json['deltarecovered'];
    confirmed = json['confirmed'];
    statenotes = json['statenotes'];
    deltaconfirmed = json['deltaconfirmed'];
    state = json['state'];
    recovered = json['recovered'];
  }
}
