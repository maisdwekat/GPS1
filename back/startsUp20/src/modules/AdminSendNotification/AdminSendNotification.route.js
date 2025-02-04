import { Router } from "express";
import *  as AdminRoute from './controller/adminToUser.js'
import { auth } from "../../midlleWare/auth.js";
import { endpoint } from "./AdminSendNotification.endpoint.js";

const AdminSendRouter=Router();
AdminSendRouter.post('/send/:userId', auth(endpoint.add) , AdminRoute.sendCustomNotification)
export default AdminSendRouter