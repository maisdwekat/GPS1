import { EducationalCourseModel } from "../../../../DB/models/EducationalCourse.model.js";

export const addEducationalCourse=async(req,res)=>{
    const {nameOfCompany , nameOfEducationalCourse,description,DateOfCourse}=req.body;
    req.body.createdBy=req.user._id;
    try{
const addaddEducational=await EducationalCourseModel.create(req.body) ;
if(!addaddEducational){
    return res.status(400).json({message:"error in add"})
}else{
    return res.status(201).json({message:"succsses", addaddEducational})
}
    }catch(error){
        return res.status(500).json({message:`error ${error}`})
    }
}


export const getAllEducational=async(req,res)=>{
    const findAll=await EducationalCourseModel.find({});
    if(!findAll){
        return res.status(400).json({message:"error in get"})
    }else{
        return res.status(200).json({message:"succses",findAll})
    }
}

export const deleteEducational=async(req,res)=>{
    const{id}=req.params;
   const deleteOne=await EducationalCourseModel.findByIdAndDelete(id);
   if(!deleteOne){
    return res.status(400).json({message:"error in delete"})
   }
   else{
    return res.status(200).json({message:"succsses",deleteOne})
   }
}

export const UpdateEducational=async(req,res)=>{
    const{id}=req.params;
    const {nameOfCompany , nameOfEducationalCourse,description,DateOfCourse}=req.body;
    try{
        const Educational=await EducationalCourseModel.findById(id)
     if(!Educational){
        res.status(400).json({message:"Educational not found"})
     }
     else{
        Educational.nameOfCompany=nameOfCompany || Educational.nameOfCompany;
        Educational.nameOfEducationalCourse=nameOfEducationalCourse || Educational.nameOfEducationalCourse;
        Educational.description=description || Educational.description;
        Educational.DateOfCourse=DateOfCourse || Educational.DateOfCourse;
        const update=await Educational.save()
        return res.status(200).json({
           message:"update successfully" ,
           update
        })
     }
    }catch(error){
        return res.status(500).json({message:`error ${error}`})

    }

}