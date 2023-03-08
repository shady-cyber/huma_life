class AppConstants {
  static const String APP_NAME = 'huma_life';
  static const String APP_SECRET_KRY ="PitpCe0ksIOuwSD3C8OnM9EpSkBktOSK1eGpzs6DNK4=";

  static const String CONNECTION_STRING = 'connection_string';

  static const double APP_VERSION = 1.2;

  static String BASE_URL ='';
  static const String LOGIN_URI = '/api/auth/login';
  static const String CONFIG_URI = '/api/config';
  static const String REFRESH_TOKEN = '/api/auth/refresh';
  static const String SEND_TOKEN = '/api/pushy/token';

  //attendance
  static const String ATTENDANCE_URI = '/api/attendance/signin';
  static const String ATTENDANCE_CHECK_IN = '/api/attendance/signin';
  static const String ATTENDANCE_CHECK_IN_QR_CARD = '/api/attendance/sign-in-card';
  static const String ATTENDANCE_CHECK_OUT = '/api/attendance/signout';
  static const String ATTENDANCE_MISSED_CHECK_OUT = '/api/attendance/missed';
  static const String ATTENDANCE_MISSED_CHECK_OUT_REQUEST = '/api/attendance/missed-checked-out';
  static const String MARK_ATTENDANCE = '/api/attendance/mark-attendance';
  static const String CONFIG_ATTENDANCE = '/api/attendance/config';
  static const String GET_CONFIG_ATTENDANCE = '/api/attendance/user-config';
  static const String ATTENDANCE_MISSED_DECISION = '/api/attendance/signout-from-temp-category-position';
  static const String REQUEST_ATTENDANCE_MISSED_DECISION = '/api/attendance/update-missed-signout-position';

  //loan request
  static const String LOAN_INDEX = '/api/loan/index';
  static const String LOAN_EFFECTIVE_MONTHS = '/api/loan/effective-months';
  static const String LOAN_REQUEST = '/api/loan/request-loan';
  static const String LOAN_NOTIFICATION = '/api/loan/show-loan-request';
  static const String LOAN_UPDATE = '/api/loan/update-loan-request';
  static const String LOAN_DECISION_HISTORY = '/api/loan/loan-decision-history';

  //loan delay request
  static String LOAN_MAIN_ID = '';
  static const String LOAN_DELAY_REQ = '/api/loan-delay/list-month/';
  static const String LOAN_DELAY_VIEW = '/api/loan-delay/view-loan-delay';
  static const String LOAN_DELAY_SEND = '/api/loan-delay/request-loan-delay';
  static const String LOAN_DELAY_NOTIFICATION = '/api/loan-delay/show-loan-delay-request';
  static const String LOAN_DELAY_DECISION = '/api/loan-delay/loan-delay-decision';
  static const String LOAN_DELAY_DECISION_HISTORY = '/api/loan-delay/decision-history';

  //clearance request
  static const String CLEARANCE_INDEX = '/api/clearance/index';
  static const String CLEARANCE_INDEX_CHARGE = '/api/clearance/my-charge';
  static const String CLEARANCE_REQ = '/api/clearance/request-clearance';
  static const String CLEARANCE_EMP = '/api/clearance/employees-clearance';
  static const String CLEARANCE_ITEM_STATUS = '/api/clearance/clearance-item-status';
  static const String CLEARANCE_SEND = '/api/clearance/clearance-submission';
  static const String CLEARANCE_DECISION_HISTORY = '/api/clearance/decision-history';
  static const String CLEARANCE_DECISION = '/api/clearance/clearance-decision';
  static const String CLEARANCE_NOTIFICATION_SHOW = '/api/clearance/show-clearance-request';

  //General request
  static const String GENERAL_REQ = '/api/general-request/store';
  static const String GENERAL_REQ_NOTIFICATION = '/api/general-request/show-general-request';
  static const String GENERAL_UPDATE = '/api/general-request/update-request';
  static const String GENERAL_DECISION_HISTORY = '/api/general-request/decision-history';

  //penalty request
  static const String PENALTY_INDEX_REQ = '/api/penalty/index';
  static const String PENALTY_SEND_REQ = '/api/penalty/request-penalty';
  static const String PENALTY_DECISION = '/api/penalty/penalty-decision';
  static const String PENALTY_NOTIFICATION = '/api/penalty/penalty-list-request';
  static const String PENALTY_NOTIFICATION_SHOW = '/api/penalty/show-penalty-request';
  static const String PENALTY_DECISION_HISTORY = '/api/penalty/decision-history';

  //cash InAdvance
  static const String CASH_IN_ADVANCE = '/api/cash/request-cash-in-advance';
  static const String CASH_IN_ADVANCE_NOTIFICATION = '/api/cash/index';
  static const String CASH_IN_ADVANCE_UPDATE = '/api/cash/cash-request-decision';
  static const String CASH_IN_ADVANCE_MANAGER = '/api/cash/show-cash-in-advance-request';
  static const String CASH_IN_ADVANCE_DECISION_HISTORY = '/api/cash/decision-history';

  //Employee
  static const String REPORTING_TO_ME = '/api/employee/my-employees';
  static const String EMPLOYEE_VACATION_REQUESTS = '/api/employee/show-vacation-request';
  static const String UPDATE_VACATION_REQUEST = '/api/employee/update-vacation-request';

  //Attendance Config
  static String Config = "2";
  static String Config_shared = "0";

  //vacation
  static const String LIST_VACATIONS = '/api/employee/vacations';
  static const String LIST_HISTORY_VACATIONS = '/api/employee/vacation-decision-history';
  static const String VACATION_REQUEST = '/api/employee/request-vacation';

  //Shared Key
  static const String TOKEN = 'huma_life_token';
  static const String ISADMIN = 'huma_life_is_admin';
  static const String WELCOME = 'huma_life_welcome';
  static const String EMP_PASSWORD = 'huma_life_emp_password';
  static const String EMP_CODE = 'huma_life_emp_code';
  static const String EMP_CODE_TEXT = '';
  static const String EMP_ARABIC_NAME = 'emp_arabic_name';
  static const String EMP_ENGLISH_NAME = 'emp_english_name';
  static const String LANGUAGE_CODE = 'language_code';
  static const String THEME = 'theme';
  static const String LAST_CHECK_IN_TIME = 'last_check_in_time';
  static const String FCM_TOKEN = 'fcm_token';

  //location company
  static const String LATITUDE = 'latitude';
  static const String LONGITUDE = 'longitude';

  //language code
  static const String Lang = 'locale';

  //Emp data
  static const String EMP_ADDRESSA = 'EmpAddressA';
  static const String EMP_ADDRESSE = 'EmpAddressE';
  static const String EMP_MOBILE = 'EmpMobileNo';
  static const String EMP_EMAIL = 'Email';
  static const String EMP_MANAGER = 'MANAGER';
  static const String EMP_BIRTHDAY = 'BirthDate';
  static const String EMP_GENDER = 'Gender';
  static const String EMP_IQAMANO = 'IqamaNo';
  static const String EMP_LOCATIONA = 'locationA';
  static const String EMP_LOCATIONE = 'locationE';
  static const String EMP_POSITIONA = 'PositionDescA';
  static const String EMP_POSITIONE = 'PositionDescE';
  static const String EMP_COMPNAME = 'companyName';
  static const String EMP_IMAGE = 'EmpProfilePhoto';

  //Google Map API CONSTANTS
  static const String GOOGLE_API_KEY = "AIzaSyAg6XLPYCH97U-z1BgMMlsi-lDRzagrbC0";
  static const String GOOGLE_MAP_URL = "https://www.google.com/maps/search/?api=1&query="; //<lat>47.5951518,-122.3316394<lng>";

}
