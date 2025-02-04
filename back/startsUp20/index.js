import express from 'express'
import dotenv from 'dotenv'
import cors from 'cors'
import * as indexRouter from './src/modules/index.route.js'
import ConnectDb from './DB/connection.js'
import './src/modules/Server/server.js'
import './src/modules/notification/notifacation.js'
import path from 'path';
import pkg from 'node-wit';
const { Wit } = pkg;
const app = express()


app.use(express.json())
dotenv.config()
ConnectDb()

app.use(cors())
app.use('/api/v1/auth', indexRouter.authRouter)
app.use('/api/v1/project', indexRouter.ProjectRouter)
app.use('/api/v1/conversation', indexRouter.ConversationRouter)
app.use('/api/v1/feedback', indexRouter.feedBackRouter)
app.use('/api/v1/idea', indexRouter.IdeaRouter)
app.use('/api/v1/EducationalCourse',indexRouter.EducationalRouter)
app.use('/api/v1/FormEducation',indexRouter.FormEducationRouter)
app.use('/api/v1/grant',indexRouter.grantRouter)
app.use('/api/v1/fromgrant', indexRouter.FormGrantRouter)
app.use('/api/v1/actionRequest',indexRouter.ActionRequestRouter)
app.use('/api/v1/businessCanva',indexRouter.businessCanvaRouter)
app.use('/api/v1/investment',indexRouter.investmentRouter)
app.use('/api/v1/request',indexRouter.RequestRouter)
app.use('/api/v1/admin',indexRouter.AdminSendRouter)

const client = new Wit({ accessToken: 'T2XA6PTHDTTAN4NYNQGQYQJYE2V6XLXN' });
app.post('/chat', async (req, res) => {
  const { message } = req.body;

  try {
    const response = await client.message(message);
    const reply = response.entities['intent'] ? response.entities['intent'][0].value : "Sorry, I didn't understand that.";
    res.json({ reply });
  } catch (error) {
    res.status(500).json({ error: 'Error processing the message', message: error.message });
  }
});















app.use('*', (req, res) => {
  res.status(500).json({ message: "invalid page" })
})
app.listen(process.env.port, (req, res) => {
  console.log(`Running Server ${process.env.port}`)

})
