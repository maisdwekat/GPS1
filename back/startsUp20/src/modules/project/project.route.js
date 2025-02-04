import { Router } from "express";
import * as ProjectRoute from './controller/project.controller.js'
import { fileValidation, myMulter } from "../../Servicess/multer.js";
import { auth } from "../../midlleWare/auth.js";
import { endpoint } from "./project.endpoint.js";

const ProjectRouter=Router();
ProjectRouter.post('/add',auth(endpoint.add),myMulter(fileValidation.imag).single('image'),ProjectRoute.addProject)
ProjectRouter.delete('/delete/:id', auth(endpoint.delete),ProjectRoute.deleteProject)
ProjectRouter.get('/all',auth(endpoint.show),ProjectRoute.findAll)

ProjectRouter.get('/allByLocation',auth(endpoint.showByLocation),ProjectRoute.findByLocation)
ProjectRouter.get('/allByStage',auth(endpoint.showByStage),ProjectRoute.findByStage)
ProjectRouter.get('/allByCategory',auth(endpoint.showByCategory),ProjectRoute.findByCategory)

ProjectRouter.get('/allByUser/:userId',auth(endpoint.showByUser),ProjectRoute.findAllByUser)
ProjectRouter.patch('/update/:id',auth(endpoint.update),ProjectRoute.update)
ProjectRouter.post('/addTask/:id',auth(endpoint.addTasking),ProjectRoute.addTaskToCurrentStage)
ProjectRouter.delete('/deleteTask/:id/:taskId',auth(endpoint.delettask), ProjectRoute.deleteTaskFromCurrentStage)
ProjectRouter.get('/task/:id', auth(endpoint.showTask),ProjectRoute.getTasksForCurrentStage)
ProjectRouter.get("/recommended/:id", ProjectRoute.getRecommendedProjects)
ProjectRouter.patch("/updateSearchCount/:id", ProjectRoute.updateSearchCount);
ProjectRouter.get("/topSearched", ProjectRoute.getTopSearchedProjects);
ProjectRouter.get("/search", ProjectRoute.searchProjects);
//Gharam.... 
ProjectRouter.post('/addNote/:id', auth(endpoint.addNote), ProjectRoute.addNoteToProject);
ProjectRouter.delete('/deleteNote/:id/:noteId',auth(endpoint.deleteNote), ProjectRoute.deleteNote);
ProjectRouter.get('/getNotes/:id', auth(endpoint.showNotes),ProjectRoute.getNotes);
ProjectRouter.patch('/updateNote/:id/:noteId',auth(endpoint.updateNote), ProjectRoute.updateNote);

ProjectRouter.post('/rate/:id', auth(endpoint.addRatting), ProjectRoute.addRating);
ProjectRouter.get('/averageRating/:projectId',auth(endpoint.getAveregeRatting),ProjectRoute.getAverageRating);
//ProjectRouter.get('/ratings/:projectId',auth(endpoint.getRating),ProjectRoute.getProjectRatings);


export default ProjectRouter;