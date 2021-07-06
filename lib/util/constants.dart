//Firebase FireStore
const String USER_COLLECTION = 'users';
//User Fields
const String USER_ID = 'userid';
const String NAME = 'name';
const String EMAIL_ID = 'email';
const String PHONE = 'phoneNumber';
const String PROFILE_PIC = 'profilePic';
const String LINK = 'link';
const String DOB = 'dob';
const String HOMETOWN = 'hometown';
const String LAT = 'lat';
const String LNG = 'lng';

const String WORK = 'work';
const String EDU = 'education';
const String ORG = 'org';
const String CITY = 'city';
const String FROM = 'from';
const String TO = 'to';
const String IS_PRESENT = 'isPresent';

const String COURSE = 'course';
const String JOB_TITLE = 'job_title';

//dateFormat
const String BIRTHDAY_FORMAT = 'dd-MM-yyyy';
const String WORK_FORMAT = 'MMMM y';

//Firebase Auth
//server errors
const String WEAK_PASSWORD_ERR = 'weak-password';
const String EMAIL_IN_USE_ERR = 'email-already-in-use';
const String USER_NOT_FOUND_ERR = 'user-not-found';
const String PASSWORD_ERR = 'wrong-password';
const String ACCOUNT_EXISTS_ERR = 'account-exists-with-different-credential';
const String INVALID_CRED_ERR = 'invalid-credential';

//error messages
const String WEAK_PASSWORD_MSG = "The password provided is too weak.";
const String EMAIL_IN_USE_MSG = "An account already exists for that email.";
const String USER_NOT_FOUND_MSG = "No user found for that email.";
const String PASSWORD_MSG = 'Wrong password provided.';
const String ACCOUNT_EXISTS_MSG =
    'Account already exists with a different credential';
const String INVALID_CRED_MSG = 'Invalid credential';

//UI Strings
//AboutUs
const String VER = 'Version: ';
const String CONTACT_US = 'Contact Us:';
const String ADMIN_EMAIL = 'mayank.tripathi@tarento.com';
const String ADMIN_PHONE = '+918373941947';
const String ABOUT_APP = "Alumni Meet helps simplify and encourage alumni engagement activities, thereby leveraging the power of alumni relationships. It is the easiest way to connect with classmates and peers wherever we are in the world.Empowering alumni to not only connect with each other, but also back with the university is one of the most important functions of an alumni association. Because alumni hold shared experiences as students of their school, this lends itself to powerful networking opportunities; whether it’s in the form of class reunions or volunteer events. Even in their local communities, alumni can form affinity networks to pursue common interests with their peers.";

//ContactInfo
const String CONTACT_INFO = 'Contact Info';
const String NAME_HINT = 'John Doe';
const String NAME_LABEL = 'Full Name';
const String EMAIL_HINT = 'john.doe@gmail.com';
const String EMAIL_LABEL = 'Email';
const String LINK_HINT = 'www.linkedin/joe.com';
const String LINK_LABEL = 'Profile Link';
const String SUBMIT = 'Submit';

//WorkEduInfo
const String WORK_INFO = 'Work Info';
const String ORG_LABEL = 'Organization Name';
const String INST_LABEL = 'Institution Name';
const String CITY_LABEL = 'City Name';
const String JOB_LABEL = 'Designation';
const String COURSE_LABEL = 'Course with Specialization';
const String FROM_LABEL = 'From';
const String TO_LABEL = 'To';
const String PRESENT_LABEL = 'Present';

//PersonalInfo
const String PERSONAL_INFO = 'Work Info';
const String DOB_LABEL = 'Date of Birth';
const String HT_LABEL = 'HomeTown';

//UserProfile
const String ALUM_LABEL = 'Alumni Profile';
const String PRO_DETAILS = 'Professional Details';
const String EDU_DETAILS = 'Education Details';

//Home
const String HOME = 'Home';
const String MY_PROFILE = 'My Profile';
const String ALUM_DIR = 'Alumni Directory';
const String ABT_US = 'About Us';
const String SETTINGS = 'Settings';
const String LOGOUT = 'Logout';

//Login
const String PASS_FIELD = 'password';
const String PASS_LABEL = 'Password';
const String LOGIN = 'Login';
const String DONT_HAVE_ACC = 'Don\'t have an account ?';

//Register
const String REGISTER = 'Register';
const String ALREADY_HAVE_ACC = 'Don\'t have an account ?';

//Form Validation errors
const String NAME_ERR = 'Please enter your full name';
const String EMAIL_ERR = 'Email address can\'t be left blank';
const String EMAIL_VALID_ERR = 'Not a valid Email';
const String LINK_VALID_ERR = 'Please enter a valid url';
const String ORG_ERR = 'Please enter a valid name';
const String CITY_ERR = 'Please enter your city name';
const String JOB_ERR = 'Please enter your Designation';
const String COURSE_ERR = 'Please enter your Course name';
const String START_DATE_ERR = 'Please fill a Starting date';
const String COMPLETE_DATE_ERR = 'Please fill a Completion date';
const String DOB_ERR = 'Please fill Date of Birth';
const String HT_ERR = 'Please enter your hometown';
const String PASS_ERR = 'Password can\'t be left blank';
const String PHONE_ERR = 'Mobile Number can\'t be blank';
const String PHONE_VALID_ERR = 'Please enter a valid Mobile Number';
const String LOCATION_ERR = 'No Location found for this user';

//MAP
const String MAP_TITLE = 'View Location on Map';
const String DONE = 'Done';
const String ADDRESS = 'Address';

//widget
const String APP_NAME = 'Alumni Meet';
const String OR = 'OR';
const String SIGN_IN_GOOGLE = 'Sign-In with Google';
const String GOOGLE = 'google';
const String PHONE_NUM = 'Mobile Number';
const String PHONE_HINT = '9876598765';
const String SET_LOCATION = 'Set Location';
const String VIEW_ON_MAP = 'View on Map';

//Location
const String LOCATION_DISABLED = "Location services are disabled.";
const String LOCATION_PERMISSION_ERR = "Location permissions are denied";
const String LOCATION_PERMISSION_DENIED_ERR =
    "Location permissions are permanently denied, we cannot request permissions.";
const String LOCATION_UPDATED_SUCCESS = "Current Location Updated Successfully";
