import { Router } from "express";
import * as FormEducationRoute from './controller/FormEducation.controller.js'
import { auth } from "../../midlleWare/auth.js";
import { endpoint } from "./FormEducation.endpoint.js";

const FormEducationRouter=Router();
FormEducationRouter.post('/add', auth(endpoint.add) , FormEducationRoute.AddForm)
FormEducationRouter.get('/all',auth(endpoint.show),FormEducationRoute.getAll)
export default FormEducationRouter;