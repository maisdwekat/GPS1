import { Router } from 'express';
import * as InvestmentController from './controller/investment.controller.js'; 
import { fileValidation, myMulter } from "../../Servicess/multer.js";
import { auth } from "../../midlleWare/auth.js";
import { endpoint } from "./investment.endpoint.js";
const InvestmentRouter = Router();

InvestmentRouter.post('/add/:projectId',auth(endpoint.add),myMulter(fileValidation.pdf).single('agreementFile'),InvestmentController.addInvestment);

InvestmentRouter.patch( '/update/:investmentId',auth(endpoint.update), myMulter(fileValidation.pdf).single('agreementFile'), InvestmentController.updateInvestment);

InvestmentRouter.delete('/delete/:investmentId',auth(endpoint.delete), InvestmentController.deleteInvestment);

InvestmentRouter.get('/investments/investor/:investorId',auth(endpoint.byInvestor), InvestmentController.getInvestmentsByInvestor);

InvestmentRouter.get('/investments/project/:projectId',auth(endpoint.byProject), InvestmentController.getInvestmentsByProject);

InvestmentRouter.get('/investments/download/:investmentId',auth(endpoint.download),InvestmentController.downloadAgreementFile);


export default InvestmentRouter;
