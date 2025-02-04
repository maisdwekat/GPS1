import { Router } from "express";
import { endpoint } from "./idea.endpoint.js";
import { auth } from "../../midlleWare/auth.js";
import * as IdeaRoute from './Controller/idea.controller.js'
const IdeaRouter=Router();   
IdeaRouter.post('/add', auth(endpoint.add),IdeaRoute.createIdea)
IdeaRouter.post('/addComment/:IdeaId',auth(endpoint.add),IdeaRoute.addComment)
IdeaRouter.post('/addlike/:commentId',auth(endpoint.add),IdeaRoute.AddLikeToComment)
IdeaRouter.delete('/deleteIdea/:id',auth(endpoint.delete),IdeaRoute.deleteIdea)
IdeaRouter.get('/get/:id',auth(endpoint.show),IdeaRoute.getIdea)
IdeaRouter.get('/getAll',auth(endpoint.show),IdeaRoute.getAllIdea )
IdeaRouter.get('/getAllForUser/:id',auth(endpoint.show),IdeaRoute.getAllIdeaForUser )

IdeaRouter.patch('/update/:id',auth(endpoint.update), IdeaRoute.updateIdea)
IdeaRouter.get('/getAllComment/:id', auth(endpoint.show),IdeaRoute.getAllCommentsInIdea)
IdeaRouter.delete('/deletecomment/:ideaId/:commentId' , auth(endpoint.delete),IdeaRoute.deleteCommentFromIdea)
IdeaRouter.patch('/updateComment/:ideaId/:commentId',auth(endpoint.update),IdeaRoute.updateCommentInIdea)
IdeaRouter.delete('/deletelike/:ideaId/:commentId/:likeId', auth(endpoint.delete),IdeaRoute.deleteLikeInComment)
IdeaRouter.get('/getRocomanded',auth(endpoint.show),IdeaRoute.getRecommendedIdeas)
IdeaRouter.post('/likeIdea/:ideaId', auth(endpoint.add),IdeaRoute.AddLikeToidea)
IdeaRouter.get('/alllike/:ideaId',auth(endpoint.show),IdeaRoute.findlikes)
IdeaRouter.delete('/deletelike/:ideaId',auth(endpoint.delete),IdeaRoute.deletelikeFromIdea)
export default IdeaRouter;