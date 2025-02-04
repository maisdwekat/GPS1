import { Schema, Types, model } from "mongoose";
const feedBackSchema=new Schema({
    description:{
        type:String,
        required:true
    },
    createdBy: {
        type: Types.ObjectId,
        ref: 'user',
        required: true,
      },
      userName:{
        type:String,
        ref:'user',
        required:true
      }
})
const feedBackModel=model('feedback', feedBackSchema)
export {feedBackModel}