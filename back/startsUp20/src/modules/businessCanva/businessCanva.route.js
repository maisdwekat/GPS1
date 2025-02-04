import { Router } from "express";
import * as businessCanvaRoute from './controller/businessCanva.controller.js'
import { endpoint } from "./businessCanva.endpoint.js";
import { auth } from "../../midlleWare/auth.js";
const businessCanvaRouter=Router();
businessCanvaRouter.post('/addBusinessCanva/:projectId',auth(endpoint.add),businessCanvaRoute.addBusinessCanvas)
businessCanvaRouter.delete('/deleteBusinessCanva/:projectId', auth(endpoint.delete),businessCanvaRoute.deleteBusinessCanvas)
businessCanvaRouter.get('/getBusinessCanva/:projectId',auth(endpoint.show),businessCanvaRoute.getBusinessCanvas)
businessCanvaRouter.patch('/updateBusinessCanva/:projectId',auth(endpoint.update),businessCanvaRoute.updateBusinessCanvas)

export default businessCanvaRouter;