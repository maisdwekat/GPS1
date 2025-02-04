import { Router } from "express";
import * as EducationalRoute from './controller/EducationalCourse.controller.js'
import { auth } from "../../midlleWare/auth.js";
import { endpoint } from "./EducationalCourse.endpoint.js";

const EducationalRouter=Router();
EducationalRouter.post('/add',auth(endpoint.add),EducationalRoute.addEducationalCourse)
EducationalRouter.get('/all',auth(endpoint.show),EducationalRoute.getAllEducational)
EducationalRouter.delete('/delete/:id',auth(endpoint.delete),EducationalRoute.deleteEducational)
EducationalRouter.patch('/update/:id',auth(endpoint.update),EducationalRoute.UpdateEducational)
export default EducationalRouter;