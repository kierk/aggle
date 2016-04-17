from firebase import firebase


# App ID:  1711245905757398
# App Secret: 1db86ba4008472f2d2d4a1b8fa4d99f8
# Max: 10154099496677328

# Test connection and authentication
firebase = firebase.FirebaseApplication('https://testnosqlschema.firebaseio.com/', authentication=None)

authentication = firebase.Authentication('THIS_IS_MY_SECRET', 'ozgurvt@gmail.com', extra={'id': 123})
firebase.authentication = authentication
print authentication.extra

user = authentication.get_user()
print user.firebase_auth_token

# Test get.
result = firebase.get('/users/2',     # Route
    None,                             # Kind of pointless, but it gets basically appeneded to Route
    {'print': 'pretty'},              # Query Params
    {'X_FANCY_HEADER': 'VERY FANCY'}) # Headers
print("GET result: " + result)

# Test post
result = firebase.post('/users',      # Route
    new_user,                         # Kind of pointless, but it gets basically appeneded to Route
    {'print': 'pretty'},              # Query Params
    {'X_FANCY_HEADER': 'VERY FANCY'}) # Headers

print("POST result: " + result)

