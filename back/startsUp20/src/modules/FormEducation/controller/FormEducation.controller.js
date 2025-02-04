import { FormEducationModel } from "../../../../DB/models/FormCourses.model.js";

export const AddForm=async(req , res)=>{
    const {name , phoneNumber , email , nameOfEducationalCourse}=req.body;
    req.body.createdBy=req.user._id;
    req.body.userNameCreated=req.user.name
     const addToForm=await FormEducationModel.create(req.body);
     if(!addToForm){
        return res.status(400).json({message:"error in adding"})
     }
     else{
        return res.status(200).json({message:"sucsses", addToForm})

     }

}
export const getAll=async(req,res)=>{
    const showAll=await FormEducationModel.find({})
    if(!showAll){
        return res.status(400).json({message:"error no data"})
    }else{
        return res.status(200).json({message:"sucsses", showAll})
    }
}