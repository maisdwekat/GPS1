import mongoose from 'mongoose';


const messageSchema = new mongoose.Schema({
  sender: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'user', 
    required: true
  },
  senderRole: {
    type: String,
    enum: ['user', 'admin'],  
    required: true
  },
  message: {
    type: String,
    required: true
  },
  timestamp: {
    type: Date,
    default: Date.now
  },
  parentMessageId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Message', 
    default: null
  }
});


const conversationSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'user',  
    required: true
  },
  adminId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'user',  
    required: true
  },
  messages: [messageSchema]
});


const ConversationModel = mongoose.model('Conversation', conversationSchema);

export default ConversationModel;
