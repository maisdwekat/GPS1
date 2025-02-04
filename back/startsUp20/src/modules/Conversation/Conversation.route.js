import { Router } from "express";
import { auth } from "../../midlleWare/auth.js";
import { endpoint } from "./Conversation.endpoint.js";
import * as ConRoute from './controller/Conversation.controller.js'

const ConversationRouter=Router();
ConversationRouter.post('/sendMessage',auth(endpoint.add) , ConRoute.sendMessage)
ConversationRouter.post('/sendMessageAdmin/:userId',auth(endpoint.adminReply) , ConRoute.adminReply)
ConversationRouter.get('/getMessage',auth(endpoint.show),ConRoute.getConversation)

export default ConversationRouter