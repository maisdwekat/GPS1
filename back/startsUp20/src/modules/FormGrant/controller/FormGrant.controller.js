import { FormGrantModel } from "../../../../DB/models/FormGrant.model.js";
export const AddGrant=async(req , res)=>{
    const {name, phoneNumber , email , nameOfGrant}=req.body;
    req.body.createdBy=req.user._id;
    req.body.userNameCreated=req.user.name;
    const Addgrant=await FormGrantModel.create(req.body);
    if(!Addgrant){
        res.status(400).json({message:"error in add"})
    }
    else{
        res.status(200).json({message:"succsses", Addgrant})
    }
}

export const getGrant=async(req,res)=>{
    const findAll=await FormGrantModel.find({});
    if(!findAll){
        res.status(400).json({message:"error in get"})
    }
    else{
        res.status(200).json({message:"succsses", findAll}) 
    }
}