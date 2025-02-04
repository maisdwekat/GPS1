import { Router } from "express";
import * as RequestRoute from './controller/Request.controller.js'
import { auth } from "../../midlleWare/auth.js";
import { endpoint } from "./Request.endpoint.js";
import { fileValidation, myMulter } from "../../Servicess/multer.js";
const RequestRouter=Router();
RequestRouter.get('/requests/project/:projectId',auth(endpoint.showByproject),RequestRoute.getRequestsByProject);
RequestRouter.post(
    '/requests/:projectId',
    auth(endpoint.add),
    myMulter(fileValidation.pdf).single('agreementFile'), 
    RequestRoute.createRequest
  );
  
RequestRouter.patch('/requests/:requestId',auth(endpoint.update),RequestRoute.updateRequest);

export default RequestRouter;