import { Types,Schema,model, now } from "mongoose";
const EducationalCourseSchema=new Schema({
    nameOfCompany:{
        type:String,
        required:true,
    },
    nameOfEducationalCourse:{
        type:String,
        required:true,
    },
    description:{
        type:String,
        required:true,  
    },
    DateOfCourse:{
        type:Date,
        required:true
    },
    createdBy:{
        type:Types.ObjectId,
        ref:'user',
        required:true
    }
    
},{timestamps:true})
const EducationalCourseModel=model('EducationalCourse',EducationalCourseSchema)
export {EducationalCourseModel}