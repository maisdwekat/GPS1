import { Types,Schema,model, now } from "mongoose";
const grantSchema=new Schema({
    nameOfCompany:{
        type:String,
        required:true,
    },
    nameOfGrant:{
        type:String,
        required:true,
    }, 
    description:{
        type:String,
        required:true,  
    },
    DateOfEndoFGrant:{
        type:Date,
        required:true
    },
    createdBy:{
        type:Types.ObjectId,
        ref:'user',
        required:true
    },
    userName:{
        type:String,
        ref:'user',
        required:true 
    }
},{timestamps:true})
const grantModel=model('grant',grantSchema);
export {grantModel}