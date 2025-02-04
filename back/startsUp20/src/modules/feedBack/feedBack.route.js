import { Router } from "express";
import { auth } from "../../midlleWare/auth.js";
import { endpoint } from "./feedBack.endpoint.js";
import * as feddbackRoute from './controller/feedBack.controller.js';
const feedBackRouter=Router();
feedBackRouter.post('/add',auth(endpoint.add), feddbackRoute.addFeedBack)
feedBackRouter.delete('/delete/:id', auth(endpoint.delete),feddbackRoute.deleteFeedBack)
feedBackRouter.get('/all', auth(endpoint.show),feddbackRoute.showAll)
feedBackRouter.get('/all/:id', auth(endpoint.show),feddbackRoute.showUserfeed)

export default feedBackRouter;