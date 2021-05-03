class URLNetwork {
  // urlNetwork() {
  //   var url = '127.0.0.1:5000';
  //   return url;
  // }
// urlNetwork() {
//   var url = '10.0.2.2:5000';
//   return url;
// }
urlNetwork() {
  var url = 'india-covid-leads-backend-4nznf.ondigitalocean.app';
  return url;
}
}

String uri = URLNetwork().urlNetwork();


getAllByCategory(String service, String cityState, String pageNo){
  var getAllByCategory = Uri.https(uri, '/kaizen/api/covidLeads/getAll/$service/$cityState/$pageNo');
  return getAllByCategory;
}

var getAllCitiesURI = Uri.https(uri, '/kaizen/api/covidLeads/getAllCities');
var getAllServicesURI = Uri.https(uri, '/kaizen/api/covidLeads/getAllServices');

var loginURI = Uri.https(uri, '/kaizen/api/covidLeads/loginVolunteer');
var currentCustomerURI = Uri.https(uri, '/kaizen/api/covidLeads/currentVolunteer');
var volunteerRegistrationURI = Uri.https(uri, '/kaizen/api/covidLeads/registerVolunteer');
var customerRefreshTokenURI = Uri.https(uri, '/kaizen/api/covidLeads/refreshTokenVolunteer');

var newLeadURI = Uri.https(uri, '/kaizen/api/covidLeads/addNewLead');
var allSonsorsURI = Uri.https(uri, '/kaizen/api/covidLeads/getAllSponsor');

volunteerDetailsURI(String user) {
  var volunteerDetailsURI = Uri.https(
      uri, '/kaizen/api/covidLeads/volunteerDetails/$user');
  return volunteerDetailsURI;
}

volunteerProfileStatusURI(String status) {
  var volunteerProfileStatusURI = Uri.https(
      uri, '/kaizen/api/covidLeads/volunteerProfileStatus/$status');
  return volunteerProfileStatusURI;
}