

import ConversationModel from '../../../../DB/models/Conversation.model.js';

export const sendMessage = async (req, res) => {
  const { content } = req.body;  
  const { id } = req.user;  
  const adminId = '6775a0001cd12f6efd817902'; 

  try {
    let conversation = await ConversationModel.findOne({
      userId: id,
      adminId: adminId,
    });

    if (!conversation) {
      conversation = new ConversationModel({
        userId: id,
        adminId: adminId,
        messages: [{ sender: id, senderRole: 'user', message: content }],
      });
    } else {
      
      conversation.messages.push({ sender: id, senderRole: 'user', message: content });
    }

   
    await conversation.save();
    res.status(200).json({ message: 'Message sent successfully', conversation });
  } catch (error) {
    res.status(500).json({ message: 'Error sending message', error: error.message });
  }
};


export const adminReply = async (req, res) => {
  const { userId } = req.params;  
  const { content } = req.body;
  const { id } = req.user;  
  const adminId = id;  
  try {
    
    const conversation = await ConversationModel.findOne({
      userId: userId,
      adminId: adminId,
    });

    if (!conversation) {
      return res.status(404).json({ message: 'Conversation not found' });
    }

    
    const lastUserMessage = conversation.messages
      .filter(message => message.senderRole === 'user')
      .pop(); 

    const parentMessageId = lastUserMessage ? lastUserMessage._id : null; 

   
    const newMessage = {
      sender: adminId,
      senderRole: 'admin',
      message: content,
      parentMessageId,  
    };

    conversation.messages.push(newMessage);  
    
    await conversation.save();

    res.status(200).json({ message: 'Admin reply sent successfully', conversation });
  } catch (error) {
    res.status(500).json({ message: 'Error sending admin reply', error: error.message });
  }
};



export const getConversation = async (req, res) => {
  const { id } = req.user; 
 
  const  adminId  =  '6775a0001cd12f6efd817902'; 

  try {
    const conversation = await ConversationModel.findOne({
      userId: id,
     adminId
    });

    if (!conversation) {
      return res.status(404).json({ message: 'Conversation not found' });
    }

    
    const sortedMessages = conversation.messages.sort(
      (a, b) => new Date(a.timestamp) - new Date(b.timestamp)
    );

    
    res.status(200).json({ messages: sortedMessages });
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving conversation', error: error.message });
  }
};