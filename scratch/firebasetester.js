var Firebase = require("firebase");

// App ID:  <REDACTED>
// App Secret: <REDACTED>
// Max: <REDACTED>

// Authenticate with Facebook using an existing OAuth 2.0 access token
var ref = new Firebase("https://testnosqlschema.firebaseio.com/");

// Test auth
//ref.authWithOAuthToken("facebook", "<REDACTED>", function(error, authData) {
//  if (error) {
//    console.log("Login Failed!" + error);
//  } else {
//    console.log("Authenticated successfully with payload:" + authData);
//  }
//});

// Test POST
var usersRef = ref.child("EugeneTest");
usersRef.set({
  kolotest1: {
    "Email": "June 23, 1912",
    "Full Name": "Gene Kolotest"
  }
});

// Test UPDATE
usersRef.update({
  "TestKey": "TestValueNew"
});
