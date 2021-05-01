class URLNetwork {
  // urlNetwork() {
  //   var url = '127.0.0.1:5000';
  //   return url;
  // }
urlNetwork() {
  var url = '10.0.2.2:5000';
  return url;
}
// urlNetwork() {
//   var url = '167.71.228.148';
//   return url;
// }
}

String uri = URLNetwork().urlNetwork();


getAllByCategory(String service, String cityState, String pageNo){
  var getAllByCategory = Uri.http(uri, '/kaizen/api/covidLeads/getAll/$service/$cityState/$pageNo');
  return getAllByCategory;
}

var getAllCitiesURI = Uri.http(uri, '/kaizen/api/covidLeads/getAllCities');
var getAllServicesURI = Uri.http(uri, '/kaizen/api/covidLeads/getAllServices');

var loginURI = Uri.http(uri, '/kaizen/api/covidLeads/loginVolunteer');
var currentCustomerURI = Uri.http(uri, '/kaizen/api/covidLeads/currentVolunteer');
var volunteerRegistrationURI = Uri.http(uri, '/kaizen/api/covidLeads/registerVolunteer');
var customerRefreshTokenURI = Uri.http(uri, '/kaizen/api/covidLeads/refreshTokenVolunteer');

var newLeadURI = Uri.http(uri, '/kaizen/api/covidLeads/addNewLead');
