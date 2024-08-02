const serviceAccount = require('C:\\Flutter\\hello_world\\flutter_application_1\\certs\\catholic-terps-app-firebase-adminsdk-ieyn5-21c09d33d1.json');
const admin = require('firebase-admin');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
module.exports = db;
