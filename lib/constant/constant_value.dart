//IPv4 session
const String ipv4 = "10.10.10.210";

//Header session
const Map<String, String> headers = {
  "Access-Control-Allow-Origin": "*",
  'Content-Type': 'application/json',
  'Accept-Language': 'th',
  'Accept': '*/*'
};

//Farmer session
const String baseURL = "http://" + ipv4 + ":8080";
