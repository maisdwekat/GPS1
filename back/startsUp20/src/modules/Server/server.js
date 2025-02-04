import express from 'express';
import { admin, db } from '../firebase.js';
import { auth } from "../../midlleWare/auth.js";
import { endpoint } from './server.endpoint.js';
import { userModel } from '../../../DB/models/user.model.js';

const app = express();
app.use(express.json());  

app.post('/sendMessage/:userId', auth(endpoint.add), async (req, res) => {
  try {
    const { userId } = req.params;
    const { message } = req.body;
    const investorId = req.user._id; 

    const userName = await userModel.findById(userId);
    const investorName = await userModel.findById(investorId);
   
    const chatId = `${investorId}_${userId}`;


    const chatRef = db.ref(`chats/${chatId}`);

   
    const messageRef = chatRef.push();

    await messageRef.set({
      senderId: investorId.toString(),
      senderName: investorName.name,
      receiverId: userId,
      receiverName: userName.name,
      message,
      timestamp: admin.database.ServerValue.TIMESTAMP,
    });

    await chatRef.update({
      lastMessage: message,
      lastTimestamp: admin.database.ServerValue.TIMESTAMP,
    });

    res.status(200).send({ success: true, message: 'Message saved to Firebase' });
  } catch (error) {
    console.error('Error in POST /sendMessage:', error);
    res.status(500).send({ success: false, message: 'Error saving message to Firebase' });
  }
});

app.post('/sendMessage/:investorId', auth(endpoint.add), async (req, res) => {
  try {
    const { investorId } = req.params;
    const { message } = req.body;
    const userId = req.user._id;

    const chatId = `${investorId}_${userId}`;
    const userName = await userModel.findById(userId);
    const investorName = await userModel.findById(investorId);

    const chatRef = db.ref(`chats/${chatId}`);

    const messageRef = chatRef.push();

    await messageRef.set({
      senderName: userName.name,
      senderId: userId.toString(),
      receiverId: investorId,
      receiverName: investorName.name,
      message,
      timestamp: admin.database.ServerValue.TIMESTAMP,
    });

    await chatRef.update({
      lastMessage: message,
      lastTimestamp: admin.database.ServerValue.TIMESTAMP,
    });

    res.status(200).send({ success: true, message: 'Message saved to Firebase' });
  } catch (error) {
    console.error('Error in POST /sendMessage:', error);
    res.status(500).send({ success: false, message: 'Error saving message to Firebase' });
  }
});







app.get('/getConversations/:userId', async (req, res) => {
  try {
    const { userId } = req.params;

    const conversationsSnapshot = await db.ref('chats').once('value');
    const conversationsData = conversationsSnapshot.val();
    
    if (!conversationsData) {
      console.log("No conversations found.");
      return res.status(200).send({ success: true, conversations: [] });
    }

    const conversations = [];

    
    Object.entries(conversationsData).forEach(([chatId, chatData]) => {
      console.log("Checking chatId:", chatId, "Data:", chatData);  

     
      Object.entries(chatData).forEach(([messageId, messageData]) => {
        console.log("Checking messageId:", messageId, "MessageData:", messageData);

  
        if (messageData.senderId === userId || messageData.receiverId === userId) {
          conversations.push({
            chatId,
            messageId,
            ...messageData
          });
        } else {
          console.log(`UserId ${userId} does not match senderId (${messageData.senderId}) or receiverId (${messageData.receiverId})`);
        }
      });
    });

    if (conversations.length === 0) {
      console.log(`No conversations found for userId: ${userId}`);
    }

    res.status(200).send({ success: true, conversations });
  } catch (error) {
    console.error('Error in GET /getConversations:', error);
    res.status(500).send({ success: false, message: 'Error retrieving conversations' });
  }
});








app.get('/getChats/:userId', async (req, res) => {
  try {
    const { userId } = req.params;

   
    const conversationsSnapshot = await db.ref('chats').once('value');
    const conversationsData = conversationsSnapshot.val();
res.json(conversationsData)
    if (!conversationsData) {
      return res.status(200).send({ success: true, conversations: [] });
    }

    const conversations = [];

    for (const [chatId, chatData] of Object.entries(conversationsData)) {
      const [user1, user2] = chatId.split('_');

      if (user1 === userId || user2 === userId) {
        const isUser1 = user1 === userId;
        const otherUserId = isUser1 ? user2 : user1;
        const senderName = isUser1 ? chatData.senderName : chatData.receiverName;
        const receiverName = isUser1 ? chatData.receiverName : chatData.senderName;
       

        conversations.push({
          chatId,
          otherUserId,
          senderName:conversationsData.senderName,
          receiverName:conversationsData.receiverName,
          lastMessage: chatData.lastMessage,
          lastTimestamp: chatData.lastTimestamp,
        });
      }
    }

    conversations.sort((a, b) => b.lastTimestamp - a.lastTimestamp);

    res.status(200).send({ success: true, conversations });
  } catch (error) {
    console.error('Error in GET /getChats:', error);
    res.status(500).send({ success: false, message: 'Error retrieving chats' });
  }
});


app.listen(3000, () => {
  console.log('Server running on port 3000');
});

