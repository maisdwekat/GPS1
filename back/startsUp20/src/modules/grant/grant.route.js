import { Router } from "express";
import * as grantRoute from './controller/grant.controller.js'
import { auth } from "../../midlleWare/auth.js";
import { endpoint } from "./grant.endpoint.js";


const grantRouter=Router();
grantRouter.post('/add', auth(endpoint.add),grantRoute.Addgrant)
grantRouter.get('/all', auth(endpoint.show),grantRoute.getAllgrant)
grantRouter.delete('/delete/:id',auth(endpoint.delete),grantRoute.deleteGrant)
grantRouter.patch('/update/:id',auth(endpoint.update), grantRoute.updateGrant)
export default grantRouter