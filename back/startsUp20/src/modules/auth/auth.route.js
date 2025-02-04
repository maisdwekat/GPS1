import { Router } from "express";

import * as AuthRoute from './controller/auth.controller.js'
import * as validateAuth from '../auth/auth.validation.js'
import { validation } from "../../midlleWare/validation.js";
import { fileValidation, myMulter } from "../../Servicess/multer.js";
const authRouter=Router()
authRouter.post( '/signup', myMulter(fileValidation.imag).single('image'),  validation(validateAuth.signup), AuthRoute.signup   );
 authRouter.post('/signin',validation(validateAuth.signin),AuthRoute.signin)
authRouter.get('/confirmEmail/:token',AuthRoute.confirmEmail)
authRouter.patch('/sendcode',validation(validateAuth.sendCode),AuthRoute.sendCode)
authRouter.patch('/forgetpassword',validation(validateAuth.forgetPassword),AuthRoute.forgetPassward)
authRouter.get('/active',AuthRoute.getLastActiveUsers)
export default authRouter;