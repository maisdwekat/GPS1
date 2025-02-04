import admin from 'firebase-admin';
import express from 'express';
import path from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs';
import { userModel } from '../../../DB/models/user.model.js';

const app = express();
app.use(express.json());


const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const filePath = path.resolve(__dirname, '../../modules/config/serviceAccountKey.json');


console.log('Resolved path:', filePath);


fs.access(filePath, fs.constants.F_OK, (err) => {
  if (err) {
    console.error('❌ File does not exist. Please check the path:', err);
    return;
  }

  try {
    const serviceAccount = JSON.parse(fs.readFileSync(filePath, 'utf8'));
    console.log('✅ Firebase service account file loaded successfully');

    if (!admin.apps.length) {
      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
        databaseURL: 'https://your-database-url.firebaseio.com',
      });
      console.log('✅ Firebase initialized');
    } else {
      console.log('ℹ️ Firebase is already initialized');
    }
  } catch (error) {
    console.error('❌ Error reading or initializing Firebase:', error);
  }
});


const sendNotification = async (fcmToken, message) => {
  const payload = {
    notification: {
      title: 'إشعار جديد',
      body: message,
    },
  };

  try {
    const response = await admin.messaging().send({
      token: fcmToken,
      notification: payload.notification,
    });
    console.log('✅ Notification sent successfully:', response);
  } catch (error) {
    console.error('❌ Error sending notification:', error);
  }
};


app.post('/sendNotificationToUser/:userId', async (req, res) => {
  const { userId } = req.params; 
  const { message } = req.body; 

  try {
    const user = await userModel.findById(userId);
    console.log('User found:', user);
    console.log('FCM Token:', user.fcmToken);
    
    if (!user || !user.fcmToken) {
      return res.status(400).send('❌ User or FCM token not found');
    }

   
    await sendNotification(user.fcmToken, message);
    res.status(200).send('✅ Notification sent successfully');
  } catch (error) {
    console.error('❌ Error in sending notification:', error);
    res.status(500).send('❌ Error sending notification');
  }
});


const port = 3005;
app.listen(port, () => {
  console.log(`🚀 Server is running on port ${port}`);
});
export {sendNotification}