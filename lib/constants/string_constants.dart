class StringC {
  // Common string constants.
  static const String empty = '';

  // String constants in the schemas.
  static const String id = 'id';
  static const String topic = 'topic';
  static const String attachments = 'attachments';
  static const String notes = "notes";
  static const String createdAt = 'created_at';
  static const String scheduledTo = 'scheduled_to';
  static const String iteration = 'iteration';
  static const String localDbKey = 'localdb.db';

  static const String topicTable = 'topic_table';

  static const String done = 'done';

  // Path constants.
  static const String logoPath = 'images/revision.png';
  static const String googlePath = 'images/google.png';
  static const String applePath = 'images/apple.png';
  static const String noFavIconPath = 'images/no_favicon.png';
  static const String starPath = 'images/star.png';
  static const String friendPath = 'images/friend.png';

  static const String lottieComplete = 'lottiefiles/topic_complete.json';
  static const String lottieDelete = 'lottiefiles/topic_delete.json';


  // String constants in the login/ sign-in page.
  static const String login = 'Login';
  static const String createAccount= "Create Account";
  static const String appName = 'Re-Vision';
  static const String doNotHaveAccount = "Don't have an account? ";
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String emailOrAppleId = 'Email or Apple Id';
  static const String password = 'Password';
  static const String welcome = 'Welcome to Re-vision...';
  static const String forgor = 'Forgot Password?';

  // String constants used in the dashboard.
  static const String dashboard = 'Dashboard';
  static const String overview = 'Overview';
  static const String pending = "Pending Today";
  static const String stars = 'Stars';

  // String constants in the home page.
  static const String homeTitle = empty;
  static const String tapToSeeMore = 'Tap to see more';
  static const String completeAlert = 'Are you sure you want to mark this topic as completed?';
  static const String deleteAlert = 'Are you sure you want to delete this topic?';
  static const String pleaseEnterATopic = 'Please enter a topic.';
  static const String revision = "Revision";


  // String constants in the topics page.
  static const String addTopic = 'Add topic';
  static const String updateTopic = 'Update Topic';
  static const String topicLabel = 'Topic';
  static const String addAttachment = 'Attachments';
  static const String selectAttachmentType = 'Select Attachment Type';
  static const String note = 'Note';

  static const String article = 'Article';
  static const String pdf = 'Documents';
  static const String video = 'Video';
  static const String image = 'Image';
  static const String pasteTheLinkHere = 'Paste the link here.';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String link = 'link';

  static const String deleteAttachment = 'Delete this attachment?';
  static const String ok = 'Okay';

  static const String saveArticles = 'Save article(s)';
  static const String separator  = '◈◈◈';
  static const String tapToOpenWeb = 'Tap to open web-view';
  static const String tapToOpenFile = 'Tap to open the file';

  static const String areYouSureExit = 'Are you sure want to exit?';
  static const String consequences = 'You have unsaved content, and will be lost unless you save it.';
  static const String discard = 'Discard';

  static const String invalidUrl = 'Invalid Url';
  static const String savedSuccessfully = 'Saved Successfully';
  static const String errorInSaving = 'Error while saving the topic!';

  // String constants used in profile page.
  static const String starsProf = "Stars";
  static const String friends = 'Friends';
  static const String editProfile = "Edit Profile";
  static const String findFriends = "Find Friends";
  static const String search = 'Search Friends by their email';
  static const String logout = 'Logout';
  static const String logoutDesc = "Are you sure want to logout of Re-vision?";

  // String constants used in search page.
  static const String request = 'Request';
  static const String requested = 'Requested';
  static const String unfriend = "Unfriend";

  // String constants used in notifications page.
  static const String frRequests = "Friend Request(s)";
  static const String notifications = "Notifications";
  static const String accept = "Accept";
}