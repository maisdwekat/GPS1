import { Router } from "express";
import { auth } from "../../midlleWare/auth.js";
import { endpoint } from "./FormGrant.endpoint.js";
import * as FormGrantRoute from './controller/FormGrant.controller.js'
const FormGrantRouter=Router()
FormGrantRouter.post('/add', auth(endpoint.add),FormGrantRoute.AddGrant)
FormGrantRouter.get('/getAll',auth(endpoint.show),FormGrantRoute.getGrant)
export default FormGrantRouter