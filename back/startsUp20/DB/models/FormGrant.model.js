import { Types,Schema,model, now } from "mongoose";
const FormGrant=new Schema({
    name:{
        type:String,
        required:true
    },
    phoneNumber:{
        type:String,
        required:true,
    },
    email:{
        type:String,
        required:true,  
    },
    nameOfGrant:{
        type:String,
        required:true
    },
    createdBy:{
      type:Types.ObjectId,
      ref:"user",
      required:true  
    },
    userNameCreated:{
        type:String,
        ref:"user",
        required:true  
    }
})
const FormGrantModel=model('FormGrant',FormGrant)
export {FormGrantModel}