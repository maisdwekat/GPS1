import { io } from 'socket.io-client';

const socket = io('http://localhost:3000');  // الاتصال بالخادم

// عند إرسال رسالة من العميل
function sendMessage(chatId, senderId, receiverId, message) {
  const messageData = { chatId, senderId, receiverId, message };
  
  // إرسال الرسالة إلى الخادم
  socket.emit('sendMessage', messageData);
}

// استلام الرسائل من الخادم
socket.on('receiveMessage', (messageData) => {
  console.log('Received message:', messageData);
});

// مثال لإرسال رسالة
sendMessage('chat123', 'user1', 'user2', 'Hello, this is a test message!');
