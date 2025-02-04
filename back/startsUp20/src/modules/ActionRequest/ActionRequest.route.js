import { Router } from "express";
import * as ActionRequestRoute from './controller/ActionRequest.controller.js'
import { auth } from "../../midlleWare/auth.js";
import { endpoint } from "./ActionRequest.endpoint.js";
import { fileValidation, myMulter } from "../../Servicess/multer.js";
const ActionRequestRouter=Router();

ActionRequestRouter.post('/add/:investmentId',auth(endpoint.add), myMulter(fileValidation.pdf).single('newDetails[agreementFile]'),ActionRequestRoute.addActionRequest)
ActionRequestRouter.patch('/update/:requestId',auth(endpoint.update),ActionRequestRoute.updateRequestStatus)
ActionRequestRouter.get('/all',auth(endpoint.show) , ActionRequestRoute.getAllActionRequests)
ActionRequestRouter.post('/check',auth(endpoint.check),ActionRequestRoute.checkDueDates)
export default ActionRequestRouter;